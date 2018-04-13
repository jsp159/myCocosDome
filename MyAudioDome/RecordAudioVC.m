//
//  RecordAudioVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/26.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import "RecordAudioVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "AEPlaythroughChannel.h"

#import "JX_GCDTimerManager.h"
#import "SelectMusicVC.h"
#import "CutAudioFileVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

#import "ExtAudioConverter.h"

#import "SoundSlider.h"
#import "BgMusicButton.h"

#import "AEReverbFilter.h"
#import "AEParametricEqFilter.h"

@interface RecordAudioVC ()<UITextFieldDelegate>
{
    BOOL bgMFlag;
    
    NSString * currentMusicName;
    
    NSInteger audioFileCount;
    
    NSTimeInterval bgMCurrentTime;
    
    BOOL headsetIsInput;
    
    float oldBgMValue;
    
    BOOL isRecording; //是否正在录音
    BOOL isBgPlaying; //背景音乐是否正在播放
    
    AVAudioRecorder * recorderValue;
    NSTimer * levelTimer;
    
    dispatch_group_t group;
    
    BOOL isHasFilter;
    
    NSInteger gainValue;
}

@property (nonatomic, strong) AEAudioFilePlayer *bgSound;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AERecorder *recorder;

@property (strong, nonatomic) IBOutlet UILabel *bgMValueLabel;
@property (strong, nonatomic) IBOutlet UISlider *bgMSlider;
@property (strong, nonatomic) IBOutlet UILabel *bgMTime;
@property (strong, nonatomic) IBOutlet UILabel *recordFileTimeLabel;

@property (nonatomic, strong) JX_GCDTimerManager *timerManager;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AEReverbFilter * reverbFilter;
@property (nonatomic, strong) AEParametricEqFilter * eqFilter;
@end

static NSString * const bgMusicTimer = @"BgMusicTimer";
static NSString * const recordFileimer = @"RecordFileimer";
static NSString * const dbValueTimer = @"RecordFileimer";

@implementation RecordAudioVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isRecording = NO;
    isBgPlaying = NO;
    
    bgMFlag = NO;
    currentMusicName = @"胡杏儿-感激遇到你";
    
    isHasFilter = YES;
    
    gainValue = -20;
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    NSFileManager *fm =  [NSFileManager defaultManager];
    NSArray *arr = [fm contentsOfDirectoryAtPath:documentsFolder error:nil];
    audioFileCount = arr.count;
    
    [self audioConfing];
    
    headsetIsInput = [self isHeadsetPluggedIn];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
    
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0  */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    
//    SoundSlider * sslider = [[SoundSlider alloc] initWithSoundSlider:30];
//    [self.view addSubview:sslider];
//    sslider.frame = CGRectMake(50, 460, 30, 180);
//    
////    UIImage* trackImg = [UIImage imageNamed: @"形状4"];
////    
////    [sslider setMinimumTrackImage:trackImg forState: UIControlStateNormal];
////    [sslider setMaximumTrackImage:trackImg forState: UIControlStateNormal];
//    
//    
//    BgMusicButton * bmBtn = [[BgMusicButton alloc] initWithFrame:CGRectMake(100, 530, 43, 43)];
//    [self.view addSubview:bmBtn];
    
    group = dispatch_group_create();
    
    _parametricTF.delegate = self;
    _parametricTF.text = [NSString stringWithFormat:@"20"];
}

- (void)audioConfing
{

    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _audioController = appDelegate.audioController;
    
    
    _bgSound = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:currentMusicName withExtension:@"mp3"] error:NULL];
    _bgSound.volume = 1.0;
    _bgSound.channelIsMuted = bgMFlag;
    _bgSound.loop = YES;
    
    bgMCurrentTime = _bgSound.currentTime;
    
    oldBgMValue = _bgSound.volume;
    _bgMSlider.value = _bgSound.volume;
    [_bgMSlider addTarget:self action:@selector(onChangeBgMValue:) forControlEvents:UIControlEventValueChanged];
    _bgMValueLabel.text = [NSString stringWithFormat:@"%.0f",_bgMSlider.value * 100];
    [_bgMSlider setThumbImage:[UIImage imageNamed:@"Thumb"] forState:UIControlStateNormal];
    [_bgMSlider setMaximumTrackTintColor:[UIColor redColor]];
    [_bgMSlider setMinimumTrackTintColor:[UIColor yellowColor]];
    
//    [_audioController addChannels:[NSArray arrayWithObject:_bgSound]];
    
    //    self.playthrough = [[AEPlaythroughChannel alloc] init];
    //    [_audioController addInputReceiver:_playthrough];
    //    [_audioController addChannels:@[_playthrough]];
}

- (void)outBgSoundPro
{
//    NSLog(@"_bgSound.regionDuration ==== %f",_bgSound.regionDuration);
//    NSLog(@"_bgSound.regionStartTime ===== %f",_bgSound.regionStartTime);
    
    bgMCurrentTime = _bgSound.currentTime;
    NSTimeInterval sumTime = _bgSound.regionDuration;
    NSTimeInterval overTime = sumTime - bgMCurrentTime;
    
    NSString * dateString = [self onChangeTimeFormat:overTime];
    
//    NSLog(@"dateString ====== %@",dateString);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //回到主线程做事情
        _bgMTime.text = dateString;
    });
    
}

- (void)onChangeBgMValue:(UISlider *)sender
{
//    _bgSound.volume = sender.value ;
//    _bgMValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value * 100];
    NSLog(@"sender value is %f",sender.value);
    uint64_t timeValue = (uint64_t)(sender.value * _bgSound.duration);
    NSLog(@"timeValue value is %llu",timeValue);
    [_bgSound playAtTime:timeValue];
}


- (IBAction)onCloseMic:(UIButton *)sender {
    
    [_audioController setInputEnabled:NO error:nil];
    [_audioController setInputGain:0];
    
    _bgSound.volume = oldBgMValue ;
    _bgMValueLabel.text = [NSString stringWithFormat:@"%.0f",_bgSound.volume * 100];
    _bgMSlider.value = oldBgMValue;
    
    if (isBgPlaying == NO) {
        [self onFinishRecord:nil];
    }
}

- (IBAction)onOpenMic:(UIButton *)sender {
    
    [_audioController setInputEnabled:YES error:nil];
    [_audioController setInputGain:1];
    
    oldBgMValue = _bgSound.volume;
    
    _bgSound.volume = 0 ;
    _bgMValueLabel.text = [NSString stringWithFormat:@"0"];
    _bgMSlider.value = 0;
    
    if (isBgPlaying == NO) {
        [self onStartRecord:nil];
    }
}

- (IBAction)onColseBgMusic:(UIButton *)sender {
    
    bgMFlag = YES;
    _bgSound.channelIsMuted = bgMFlag;
    
    bgMCurrentTime = _bgSound.currentTime;
    [_audioController removeChannels:[NSArray arrayWithObject:_bgSound]];
    isBgPlaying = NO;
    
    [self.timer invalidate];
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:bgMusicTimer];
    
    if (_audioController.inputEnabled == NO) {
        if (isRecording == YES) {
            [self onFinishRecord:nil];
        }
    }
}

- (IBAction)onOpenBgMusic:(UIButton *)sender {
    
    bgMFlag = NO;
    _bgSound.channelIsMuted = bgMFlag;
    
    [_audioController addChannels:[NSArray arrayWithObject:_bgSound]];
    [_bgSound playAtTime:bgMCurrentTime];
    
    isBgPlaying = YES;
    
    [self bgMGCDTimer];
    
    if (isRecording == NO) {
        [self onStartRecord:nil];
    }
}

- (IBAction)onSelectMusic:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    SelectMusicVC * selectMusicVC = [[SelectMusicVC alloc] init];
    [self.navigationController pushViewController:selectMusicVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    selectMusicVC.onSelectMusicName = ^(NSString *musicName){
        
        currentMusicName = musicName;
        
        [_audioController removeChannels:[NSArray arrayWithObject:_bgSound]];
        _bgSound = nil;
        
        NSString * fileName = [NSString stringWithFormat:@"%@.mp3",musicName];
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *musicPath = [path stringByAppendingPathComponent:@"localMusic"];
        NSString * filePath = [musicPath stringByAppendingPathComponent:fileName];
        
//        _bgSound = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"SNH48-天使与恶魔" withExtension:@"mp3"] error:NULL];
        _bgSound = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:filePath] error:NULL];
        _bgSound.volume = 1.0;
        _bgSound.channelIsMuted = NO;
        _bgSound.loop = YES;
        
        bgMCurrentTime = _bgSound.currentTime;
    };
}

- (IBAction)onEnterCutAudio:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    CutAudioFileVC * cutAudioFileVC = [[CutAudioFileVC alloc] init];
    [self.navigationController pushViewController:cutAudioFileVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)onChangeToMp3:(UIButton *)sender {
    
    [MBProgressHUD showMessag:@"保存中..." toView:self.view];
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.m4a"];
    NSString *outPath = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.mp3"];
    
    ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
    //converter.inputFile =  @"/Users/lixing/Desktop/playAndRecord.caf";
    converter.inputFile =  path;
    //output file extension is for your convenience
    converter.outputFile = outPath;
    
    //TODO:some option combinations are not valid.
    //Check them out
    converter.outputSampleRate = 44100;
    converter.outputNumberChannels = 2;
    converter.outputBitDepth = BitDepth_16;
    converter.outputFormatID = kAudioFormatMPEGLayer3;
    converter.outputFileType = kAudioFileMP3Type;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [converter convert];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //回到主线程做事情
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    });
    
    
    
}

- (IBAction)onPlayMp3:(UIButton *)sender {
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.mp3"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    NSError *error = nil;
    _player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
    
    if ( !_player ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    _player.removeUponFinish = YES;
    
    NSLog(@"文件的时长为%f",_player.duration);
    
    [_audioController addChannels:@[_player]];
    
}

- (IBAction)testSignalGCD:(UIButton *)sender {
    
    [self testUploadImage];
}

- (IBAction)onCloseFilter:(UISwitch *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
//        [_audioController removeFilter:_reverbFilter fromChannel:_player];
        [_audioController removeFilter:_eqFilter fromChannel:_player];
    }
    else
    {
        sender.selected = YES;
//        _reverbFilter = [[AEReverbFilter alloc] init];
////        _reverbFilter.randomizeReflections = 100;
//        
//        _reverbFilter.decayTimeAt0Hz = 2;
//        _reverbFilter.decayTimeAtNyquist = 2;
//        
//        double rNum = arc4random()%1000;
//        double dwNum = arc4random()%100;
//        
//        NSLog(@"rNum  ============================ %f",rNum);
//        NSLog(@"dwNum  ============================ %f",dwNum);
//        
//        _reverbFilter.dryWetMix = 50;
//        _reverbFilter.randomizeReflections = rNum;
//        
//        [_audioController addFilter:_reverbFilter toChannel:_player];
        
        _eqFilter = [[AEParametricEqFilter alloc] init];
        [self setupEqFilterCenterFrequency:[_parametricTF.text integerValue] gain:gainValue];
        
        [_audioController addFilter:_eqFilter toChannel:_player];
    }
}

- (void)setupEqFilterCenterFrequency:(double)centerFrequency gain:(double)gain {
    
    _eqFilter.centerFrequency = centerFrequency;
    _eqFilter.qFactor         = 1.0;
    _eqFilter.gain            = gain;
}

#pragma mark - textfiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [_parametricTF resignFirstResponder];
}

- (void)bgMGCDTimer {
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:bgMusicTimer
                                                           timeInterval:1.0
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf outBgSoundPro];
                                                                 }];
}


- (void)onStartRecord:(UIButton *)sender {
    
    NSLog(@"开始录音...");
    
    self.title = @"录音中";
    
    self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    
    NSString * audioName = [NSString stringWithFormat:@"Recording%li.m4a",(long)audioFileCount];
    NSString *path = [documentsFolder stringByAppendingPathComponent:audioName];
    NSError *error = nil;
    
    if (![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        self.recorder = nil;
        return;
    }
    
    isRecording = YES;
    
    [self getAudioDbValue];
    
    [_audioController addInputReceiver:_recorder];
    [_audioController addOutputReceiver:_recorder];
    if (headsetIsInput) {
        
    }
}

- (void)onFinishRecord:(UIButton *)sender {
    
    NSLog(@"结束录音...");
    self.title = @"准备录音";
    isRecording = NO;
    [_recorder finishRecording];
    [_audioController removeInputReceiver:_recorder];
    [_audioController removeOutputReceiver:_recorder];
    
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:dbValueTimer];
    
    if (audioFileCount >= 1) {
        [MBProgressHUD showMessag:@"保存中..." toView:self.view];
        [self onMergeAudioFile];
        audioFileCount = 1;
    }
    else
    {
        audioFileCount++;
    }
    
}


#pragma mark - 获取声音分贝
- (void)getAudioDbValue
{
    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    recorderValue = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorderValue)
    {
        [recorderValue prepareToRecord];
        recorderValue.meteringEnabled = YES;
        [recorderValue record];
        
        __weak typeof(self) weakSelf = self;
        [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:dbValueTimer
                                                               timeInterval:1.0
                                                                      queue:nil
                                                                    repeats:YES
                                                               actionOption:AbandonPreviousAction
                                                                     action:^{
                                                                         [weakSelf levelTimerCallback];
                                                                     }];
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
}

#pragma mark - 合并文件
- (void)onMergeAudioFile
{
    
    NSString *musicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    NSString * outPutFilePath = [musicPath stringByAppendingPathComponent:@"Recording0.m4a"];
    
    NSString *tmpPath1 = [musicPath stringByAppendingPathComponent:@"Recording0.m4a"];
    NSString *tmpPath2 = [musicPath stringByAppendingPathComponent:@"Recording1.m4a"];
    
    
    AVURLAsset *audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:tmpPath1]];
    AVURLAsset *audioAsset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:tmpPath2]];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    // 音频通道
    AVMutableCompositionTrack *audioTrack1 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    AVMutableCompositionTrack *audioTrack2 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    
    
    // 音频采集通道
    AVAssetTrack *audioAssetTrack1 = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetTrack *audioAssetTrack2 = [[audioAsset2 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    
    // 音频合并 - 插入音轨文件
    [audioTrack1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack1 atTime:kCMTimeZero error:nil];
    // `startTime`参数要设置为第一段音频的时长，即`audioAsset1.duration`, 表示将第二段音频插入到第一段音频的尾部。
    [audioTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:audioAssetTrack2 atTime:audioAsset1.duration error:nil];
    
    // 合并后的文件导出 - `presetName`要和之后的`session.outputFileType`相对应。
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    
    // 查看当前session支持的fileType类型
    NSLog(@"---%@",[session supportedFileTypes]);
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];
    session.outputFileType = AVFileTypeAppleM4A; //与上述的`present`相对应
    session.shouldOptimizeForNetworkUse = YES;   //优化网络
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@" session.status == %li",(long)session.status);
        
        if (session.status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"合并成功----%@", outPutFilePath);
            [[NSFileManager defaultManager] removeItemAtPath:tmpPath2 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程做事情
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        } else {
            // 其他情况, 具体请看这里`AVAssetExportSessionStatus`.
        }
        
    }];
}

- (IBAction)onPlayRecordAudio:(UIButton *)sender {
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.m4a"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    NSError *error = nil;
    _player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
    
    if ( !_player ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    _player.removeUponFinish = YES;
    
    NSLog(@"文件的时长为%f",_player.duration);
    
    __weak typeof(self) weakSelf = self;
    
    _player.completionBlock = ^{
        [weakSelf.timer invalidate];
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:recordFileimer];
    };
    
    
    if (isHasFilter) {
//        _reverbFilter = [[AEReverbFilter alloc] init];
//        _reverbFilter.randomizeReflections = 100;
//        _reverbFilter.dryWetMix = 50;
//        _reverbFilter.decayTimeAt0Hz = 2;
//        _reverbFilter.decayTimeAtNyquist = 2;
//        
//        [_audioController addFilter:_reverbFilter toChannel:_player];
        
        _eqFilter = [[AEParametricEqFilter alloc] init];
        [self setupEqFilterCenterFrequency:[_parametricTF.text integerValue] gain:gainValue];
        
        [_audioController addFilter:_eqFilter toChannel:_player];
    }
    
    [_audioController addChannels:@[_player]];
    
    [self recordFileGCDTimer];
    
}


- (void)recordFileGCDTimer {
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:recordFileimer
                                                           timeInterval:1.0
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf recordPlayTimeDown];
                                                                 }];
}

- (void)recordPlayTimeDown
{
    NSTimeInterval sumTime = _player.duration;
    NSTimeInterval overTime = sumTime - _player.currentTime;
    
    NSString * dateString = [self onChangeTimeFormat:overTime];
    
//    NSLog(@"dateString ====== %@",dateString);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //回到主线程做事情
        _recordFileTimeLabel.text = dateString;
    });
}


- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            //耳机插入
            NSLog(@"耳机插入");
            headsetIsInput = YES;
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            //耳机拔出
            NSLog(@"耳机拔出");
            headsetIsInput = NO;
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            
            break;
    }
}


- (NSString *)onChangeTimeFormat:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}




- (void)levelTimerCallback {
    [recorderValue updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorderValue averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * valueStr = [NSString stringWithFormat:@"%f", level*120];
//        NSLog(@"valueStr  =============== %@",valueStr);
    });
}




//不管何时,只要有通知中心的出现,在dealloc的方法中都要移除所有观察者.
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)testUploadImage
{
//    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
//    dispatch_queue_t queue = dispatch_queue_create("imageBlock", NULL);
//    
//    for (int i = 0; i < 5; i++) {
//        dispatch_async(queue, ^{
//            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self testFunc:i];
//                dispatch_semaphore_signal(sem);
//                
//            });
//            dispatch_semaphore_signal(sem);
//        });
//    }
    
    
//    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
//    
//    dispatch_group_enter(group);
//    dispatch_group_async(group, queue, ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self testFunc:1];
//            
//        });
//        
//        
//    });
//    
//    for (int i = 2; i < 7; i++) {
//        
//        dispatch_group_enter(group);
//        dispatch_group_async(group, queue, ^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self testFunc:i];
//                
//            });
//            
//            
//        });
//    }
//    
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"全部完成");
//    });
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self testFunc:1];
    });
    
    for (int i = 2; i < 7; i++) {
        
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            [self testFunc:i];
        });
    }
    
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5*NSEC_PER_SEC)));
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"全部完成");
    });
}

- (void)testFunc:(int)num
{
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("qiding", DISPATCH_QUEUE_CONCURRENT);
    
    
    
    //使用异步函数封装任务
    dispatch_async(queue, ^{
        NSLog(@"---start---");
        sleep(num);
        NSLog(@"num ======== %li",(long)num);
        dispatch_group_leave(group);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeGianValue:(UISlider *)sender {
    
    gainValue = sender.value;// (NSInteger)(sender.value*40) - 20;
    _gainLabel.text = [NSString stringWithFormat:@"%li",(long)gainValue];
}
@end
