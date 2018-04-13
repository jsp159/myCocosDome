//
//  ViewController.m
//  MyAudioDome
//
//  Created by jiangshiping on 17/11/16.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import "ViewController.h"
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "AEParametricEqFilter.h"
#import "AELowPassFilter.h"
#import "AEHighPassFilter.h"
#import "AEReverbFilter.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define DefaultSubPath @"Voice" //默认 二级目录 可以修改自己想要的 例如 "文件夹1/文件夹2/文件夹3"

#define SampleRateKey 44100.0 //采样率8000.0
#define LinearPCMBitDepth 16 //采样位数 默认 16
#define NumberOfChannels 1  //通道的数目

@interface ViewController ()
{
    NSTimeInterval playTime;
}

@property (nonatomic, strong) AEAudioFilePlayer *loop1;

//@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AERecorder * audioBgRecorder;
@property (nonatomic, strong) id<AEAudioReceiver> recorder;
@property (nonatomic, strong) id<AEAudioReceiver> recorder2;

@property (nonatomic, strong) AEAudioFileWriter *writer;
@property (nonatomic, strong) AEAudioFileWriter *bgWriter;

@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) AEAudioFilePlayer *bgPlayer;

@property(strong, nonatomic) AVAudioRecorder *recorder3;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _audioPlayer = appDelegate.audioController;
//    _audioPlayer = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleavedFloatStereo inputEnabled:YES];
//    _audioPlayer.preferredBufferDuration = 0.005;
//    _audioPlayer.useMeasurementMode = YES;
//    [_audioPlayer start:NULL];
////    [_audioPlayer setOutputEnabled:NO error:nil];
    
//    _audioPlayer.inputChannelSelection = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],nil];
    
//    _audioBgPlayer = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleavedFloatStereo inputEnabled:YES];
//    _audioBgPlayer.preferredBufferDuration = 0.005;
//    _audioBgPlayer.useMeasurementMode = YES;
//    [_audioBgPlayer start:NULL];
    
//    _audioSoundPlayer = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleavedFloatStereo inputEnabled:YES];
//    _audioSoundPlayer.preferredBufferDuration = 0.005;
//    _audioSoundPlayer.useMeasurementMode = YES;
//    [_audioSoundPlayer start:NULL];
    
    AudioStreamBasicDescription format;
    format.mSampleRate = 44100;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    format.mBytesPerPacket = sizeof(float);
    format.mFramesPerPacket = 1;
    format.mBytesPerFrame = sizeof(float);
    format.mChannelsPerFrame = 2;
    format.mBitsPerChannel = 8 * sizeof(float);
    
    _writer = [[AEAudioFileWriter alloc] initWithAudioDescription:format];
    
    AudioStreamBasicDescription format2;
    format2.mSampleRate = 44100;
    format2.mFormatID = kAudioFormatLinearPCM;
    format2.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    format2.mBytesPerPacket = sizeof(float);
    format2.mFramesPerPacket = 1;
    format2.mBytesPerFrame = sizeof(float);
    format2.mChannelsPerFrame = 2;
    format2.mBitsPerChannel = 8 * sizeof(float);
    
    _bgWriter = [[AEAudioFileWriter alloc] initWithAudioDescription:format2];
    
    playTime = 0;
    
    self.loop1 = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:@"胡杏儿-感激遇到你" withExtension:@"mp3"] error:NULL];
    _loop1.volume = 1.0;
    _loop1.channelIsMuted = YES;
    _loop1.loop = YES;
    
    [_audioPlayer addChannels:[NSArray arrayWithObject:_loop1]];
}



- (IBAction)playAudio:(UIButton *)sender {
    
    _loop1.channelIsMuted = NO;
    
//    AEParametricEqFilter * eqFilter = [[AEParametricEqFilter alloc] init];
//    eqFilter.centerFrequency = 10000;
//    eqFilter.qFactor         = 1.0;
//    eqFilter.gain            = 10;
//
//    [_audioPlayer addFilter:eqFilter];
    
//    AEReverbFilter * reverb = [[AEReverbFilter alloc] init];
//    reverb.dryWetMix = 80;
//    reverb.gain = 20;
//    [_audioPlayer addFilter:reverb];
    
//    AELowPassFilter * highPassFilter = [[AELowPassFilter alloc] init];
//    
//    [_audioPlayer addFilter:highPassFilter];
    
//    [_loop1 playAtTime:playTime];
    
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *error;
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
//    if (error)
//    {
//        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
//    }
//    [session setActive:YES error:&error];
//    if (error)
//    {
//        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
//    }
//    
//    //
//    // Create the microphone
//    //
//    self.microphone = [EZMicrophone microphoneWithDelegate:self];
//
//    //
//    // Start the microphone
//    //
    
}

- (IBAction)stopAudio:(UIButton *)sender {
    
//    playTime = _loop1.currentTime;
     _loop1.channelIsMuted = YES;
}

- (IBAction)startRecord:(UIButton *)sender {

//    _loop1.volume = _loop1.volume/2;
    
//    _recorder = [[AERecorder alloc] initWithAudioController:_audioPlayer];
    _recorder = [AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
        NSLog(@"frames ========== %u",(unsigned int)frames);
        NSLog(@"audio mDataByteSize -> mDataByteSize ============ %u",(unsigned int)audio->mBuffers->mDataByteSize);
        NSLog(@"audio mNumberChannels -> mNumberChannels ============ %u",(unsigned int)audio->mBuffers->mNumberChannels);
        NSLog(@"audio mNumberBuffers -> mNumberBuffers =========== %i",audio->mNumberBuffers);
        
//        AudioBufferList bufferList;
//        bufferList.mNumberBuffers = 1;
//        bufferList.mBuffers[0].mData = NULL;
//        bufferList.mBuffers[0].mDataByteSize = 0;
        
        OSStatus status = AEAudioFileWriterAddAudio(_writer, audio, frames);
        if ( status != noErr ) {
            NSLog(@"wirte err....");
        }
        
    }];
    
    
    _recorder2 = [AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
        NSLog(@"frames2 ========== %u",(unsigned int)frames);
        NSLog(@"audio2 mDataByteSize -> mDataByteSize ============ %u",(unsigned int)audio->mBuffers->mDataByteSize);
        NSLog(@"audio2 mNumberChannels -> mNumberChannels ============ %u",(unsigned int)audio->mBuffers->mNumberChannels);
        
        OSStatus status = AEAudioFileWriterAddAudio(_bgWriter, audio, frames);
        if ( status != noErr ) {
            NSLog(@"_bgWriter err....");
        }
    }];
    
//    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"recording.m4a"];
//    NSError *error = nil;
//    if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:@"OK", nil] show];
//        _recorder = nil;
//        return;
//    }
    
    
    
//    NSError *error2 = nil;
    
//    [_audioPlayer addInputReceiver:_recorder forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
//    [_audioPlayer addInputReceiver:[AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
//        
//    }]];
    
    _audioBgRecorder = [[AERecorder alloc] initWithAudioController:_audioPlayer];
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"test.m4a"];
    NSError *error = nil;
    [_writer beginWritingToFileAtPath:path fileType:kAudioFileM4AType bitDepth:16 channels:0 error:&error];
    
    NSString *path2 = [documentsFolders[0] stringByAppendingPathComponent:@"test2.m4a"];
    NSError *error2 = nil;
    [_bgWriter beginWritingToFileAtPath:path2 fileType:kAudioFileM4AType bitDepth:16 channels:1 error:&error2];
    
//    NSArray * recorderArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1], nil];
//    [_audioPlayer addInputReceiver:_recorder forChannels:recorderArr];
//    [_audioPlayer addInputReceiver:_recorder2 forChannels:recorderArr];
    [_audioPlayer addInputReceiver:_recorder forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
    [_audioPlayer addInputReceiver:_recorder2 forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
    
//    NSString *path2 = [documentsFolders[0] stringByAppendingPathComponent:@"testBgRecord.m4a"];
//    NSError *error2 = nil;
//    if (![_audioBgRecorder beginRecordingToFileAtPath:path2 fileType:kAudioFileM4AType bitDepth:_audioPlayer.audioDescription.mBitsPerChannel channels:_audioPlayer.audioDescription.mChannelsPerFrame error:&error2]) {
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                      message:[NSString stringWithFormat:@"Couldn't start recording2: %@", [error2 localizedDescription]]
//                                     delegate:nil
//                            cancelButtonTitle:nil
//                            otherButtonTitles:@"OK", nil] show];
//          _audioBgRecorder = nil;
//          return;
//    }
//    
//    [_audioPlayer addOutputReceiver:_audioBgRecorder];
    
    
    
}

//- (IBAction)startRecord:(UIButton *)sender {
//    
//    _bgRecorder = [[AERecorder alloc] initWithAudioController:_audioPlayer];
//    _soundRecorder = [[AERecorder alloc] initWithAudioController:_audioPlayer];
//    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"BgRecording.m4a"];
//    NSString *path2 = [documentsFolders[0] stringByAppendingPathComponent:@"SoundRecording.m4a"];
//    NSError *error = nil;
//    if ( ![_bgRecorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
//                                   delegate:nil
//                          cancelButtonTitle:nil
//                          otherButtonTitles:@"OK", nil] show];
//        _bgRecorder = nil;
//        return;
//    }
//    
//    NSError *error2 = nil;
////    if ( ![_soundRecorder beginRecordingToFileAtPath:path2 fileType:kAudioFileM4AType error:&error2] ) {
////        [[[UIAlertView alloc] initWithTitle:@"Error"
////                                    message:[NSString stringWithFormat:@"Couldn't start recording2: %@", [error2 localizedDescription]]
////                                   delegate:nil
////                          cancelButtonTitle:nil
////                          otherButtonTitles:@"OK", nil] show];
////        _soundRecorder = nil;
////        return;
////    }
//    if (![_soundRecorder beginRecordingToFileAtPath:path2 fileType:kAudioFileM4AType bitDepth:_audioPlayer.audioDescription.mBitsPerChannel channels:_audioPlayer.audioDescription.mChannelsPerFrame error:&error2]) {
//        [[[UIAlertView alloc] initWithTitle:@"Error"
//                                      message:[NSString stringWithFormat:@"Couldn't start recording2: %@", [error2 localizedDescription]]
//                                     delegate:nil
//                            cancelButtonTitle:nil
//                            otherButtonTitles:@"OK", nil] show];
//          _soundRecorder = nil;
//          return;
//    }
//    
//    [_audioPlayer addInputReceiver:_soundRecorder forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
////    [_audioPlayer addInputReceiver:[AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
////        
////    }]];
//    
//    [_audioPlayer addOutputReceiver:_bgRecorder];
//
//   
//    
//}

- (IBAction)stopRecord:(UIButton *)sender {
    
//    _loop1.volume = _loop1.volume * 2;
    
//    [_recorder finishRecording];
//    [_audioPlayer removeOutputReceiver:_recorder];
//    NSArray * recorderArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1], nil];
//    [_audioPlayer removeInputReceiver:_recorder fromChannels:recorderArr];
//    [_audioPlayer removeInputReceiver:_recorder2 fromChannels:recorderArr];
    [_audioPlayer removeInputReceiver:_recorder fromChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
    [_audioPlayer removeInputReceiver:_recorder2 fromChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
    
    [_writer finishWriting];
    
    [_bgWriter finishWriting];
}

- (IBAction)onPlayRecord:(UIButton *)sender {
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"test.m4a"];
    
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
    
    _player.completionBlock = ^{
        
    };
    [_audioPlayer addChannels:@[_player]];
}

- (IBAction)onPlayRecord2:(UIButton *)sender {
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"test2.m4a"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    NSError *error = nil;
    _bgPlayer = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
    
    if ( !_bgPlayer ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    _bgPlayer.removeUponFinish = YES;
    
    _bgPlayer.completionBlock = ^{
        
    };
    [_audioPlayer addChannels:@[_bgPlayer]];
    
}

- (IBAction)onPlayRecord3:(UIButton *)sender {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"/RRecord.wav"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    NSError *error = nil;
    _bgPlayer = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
    
    if ( !_bgPlayer ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    _bgPlayer.removeUponFinish = YES;
    
    _bgPlayer.completionBlock = ^{
        
    };
    [_audioPlayer addChannels:@[_bgPlayer]];
}

- (IBAction)onRecord2:(UIButton *)sender {
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder3 = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder3) {
        
        _recorder3.meteringEnabled = YES;
        [_recorder3 prepareToRecord];
        [_recorder3 record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self stopRecord:nil];
        });
        
        
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
    
}

- (IBAction)onStopRecord2:(UIButton *)sender {
    
    [self.recorder3 stop];
    
}

- (IBAction)onStartRecord3:(UIButton *)sender {
    
    NSLog(@"EZAudio 开始录音...");
    
    [self.microphone startFetchingAudio];
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"ezAudioFile.m4a"];
    NSError *error = nil;
    [_writer beginWritingToFileAtPath:path fileType:kAudioFileM4AType bitDepth:16 channels:2 error:&error];
}

- (IBAction)onStopRecord3:(UIButton *)sender {
    
    NSLog(@"EZAudio 停止录音...");
    
    [self.microphone stopFetchingAudio];
    
    [_writer finishWriting];
}

- (IBAction)onPlayRecord4:(UIButton *)sender {
    
    
}

#pragma mark - EZMicrophoneDelegate
//
// Note that any callback that provides streamed audio data (like streaming
// microphone input) happens on a separate audio thread that should not be
// blocked. When we feed audio data into any of the UI components we need to
// explicity create a GCD block on the main thread to properly get the UI
// to work.
//
- (void)microphone:(EZMicrophone *)microphone
  hasAudioReceived:(float **)buffer
    withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
{
    //
    // Getting audio data as an array of float buffer arrays. What does that mean?
    // Because the audio is coming in as a stereo signal the data is split into
    // a left and right channel. So buffer[0] corresponds to the float* data
    // for the left channel while buffer[1] corresponds to the float* data
    // for the right channel.
    //
    
    //
    // See the Thread Safety warning above, but in a nutshell these callbacks
    // happen on a separate audio thread. We wrap any UI updating in a GCD block
    // on the main thread to avoid blocking that audio flow.
    //
    //__weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        // All the audio plot needs is the buffer data (float*) and the size.
        // Internally the audio plot will handle all the drawing related code,
        // history management, and freeing its own resources.
        // Hence, one badass line of code gets you a pretty plot :)
        //
        
    });
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription
{
    //
    // The AudioStreamBasicDescription of the microphone stream. This is useful
    // when configuring the EZRecorder or telling another component what
    // audio format type to expect.
    //
    [EZAudioUtilities printASBD:audioStreamBasicDescription];
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone
     hasBufferList:(AudioBufferList *)bufferList
    withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
{
    //
    // Getting audio data as a buffer list that can be directly fed into the
    // EZRecorder or EZOutput. Say whattt...
    //
    OSStatus status = AEAudioFileWriterAddAudio(_writer, bufferList, bufferSize);
    if ( status != noErr ) {
        NSLog(@"wirte err....");
    }
}

//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone changedDevice:(EZAudioDevice *)device
{
    NSLog(@"Microphone changed device: %@", device.name);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
