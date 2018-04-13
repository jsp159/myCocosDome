//
//  CutAudioFileVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/27.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import "CutAudioFileVC.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "TheAmazingAudioEngine.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface CutAudioFileVC ()
{
    UISlider * afSlider;
    UILabel * afValueLabel;
    
    NSString * recordPath;
    
    NSTimeInterval recordFileTime;
    NSInteger recordFileSize;
    
    BOOL isHasCutFile;
}

@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) AEAudioFilePlayer *cutFilePlayer;

@end

@implementation CutAudioFileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _audioController = appDelegate.audioController;
    
    isHasCutFile = NO;
    
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    recordPath = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.m4a"];
    
    NSError *error = nil;
    _player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:recordPath] error:&error];
    
    if ( !_player ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    recordFileSize = (NSInteger)_player.duration;
    recordFileTime = _player.duration;
    
    [self setupUI];
    
    AEAudioRenderCallback rc = _player.renderCallback;
    
}

- (void)setupUI
{
    afSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-110, 60)];
    [self.view addSubview:afSlider];
    afSlider.value = 1;
    [afSlider addTarget:self action:@selector(onChangeAfSliderValue:) forControlEvents:UIControlEventValueChanged];
    
    afValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(afSlider.frame.size.width + 30, 110, 60, 40)];
    [self.view addSubview:afValueLabel];
    afValueLabel.textAlignment = NSTextAlignmentCenter;
    NSString * timeFormat = [self onChangeTimeFormat:afSlider.value * recordFileTime];
    afValueLabel.text = timeFormat;// [NSString stringWithFormat:@"%.0f",afSlider.value * recordFileSize];
    
    UIButton * cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(20, 200, 80, 50);
    [cutBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:cutBtn];
    [cutBtn addTarget:self action:@selector(onCutAudio) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * playerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playerBtn.frame = CGRectMake(120, 200, 80, 50);
    [playerBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:playerBtn];
    [playerBtn addTarget:self action:@selector(onPlayRecordAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(220, 200, 80, 50);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteCutFile) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(320, 200, 80, 50);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveFile) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onChangeAfSliderValue:(UISlider *)sender
{
    NSString * timeFormat = [self onChangeTimeFormat:sender.value * recordFileTime];
    afValueLabel.text = timeFormat;// [NSString stringWithFormat:@"%.0f",sender.value * recordFileSize];
}

- (void)onCutAudio
{
    NSInteger startValue = (NSInteger)(0);
    CMTime startTime = CMTimeMake(startValue, 1);
    NSInteger endValue = (NSInteger)(afSlider.value * recordFileSize);
    CMTime endTime = CMTimeMake(endValue, 1);
    
    [self audioCrop:[NSURL fileURLWithPath:recordPath] startTime:startTime endTime:endTime];
}

- (void)audioCrop:(NSURL *)url startTime:(CMTime)startTime endTime:(CMTime)endTime {
    
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:recordPath] ) return;
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * outFilePath = [documentsFolders[0] stringByAppendingPathComponent:@"Recording3.m4a"];
    
    NSURL *audioFileOutput = [NSURL fileURLWithPath:outFilePath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@" FlyElephant \n %@", audioFileOutput);
            isHasCutFile = YES;
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            NSLog(@"FlyElephant error: %@", exportSession.error.localizedDescription);
        }
    }];
}


- (void)onPlayRecordAudio:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    if (isHasCutFile == NO) {
        
        _player.removeUponFinish = YES;
        
        NSLog(@"文件的时长为%f",_player.duration);
        
        _player.completionBlock = ^{
            [weakSelf.audioController removeChannels:@[weakSelf.player]];
        };
        
        [_audioController addChannels:@[_player]];
        
    }
    else
    {
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording3.m4a"];
        
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
        
        NSError *error = nil;
        _cutFilePlayer = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
        
        if ( !_cutFilePlayer ) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil] show];
            return;
        }
        
        _cutFilePlayer.removeUponFinish = YES;
        
        NSLog(@"文件的时长为%f",_cutFilePlayer.duration);
        
        _cutFilePlayer.completionBlock = ^{
            [weakSelf.audioController removeChannels:@[weakSelf.cutFilePlayer]];
        };
        
        [_audioController addChannels:@[_cutFilePlayer]];
    }
    
}
- (void)saveFile
{
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.m4a"];
    
    NSString *path2 = [documentsFolders[0] stringByAppendingPathComponent:@"Recording3.m4a"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    NSError * err;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
    
    if (err) {
        NSLog(@"删除失败...");
    }
    else
    {
        NSLog(@"删除成功...");
        NSError * copyErr;
        [[NSFileManager defaultManager] copyItemAtPath:path2 toPath:path error:&copyErr];
        
        if (err) {
            NSLog(@"复制失败...");
        }
        else
        {
            NSLog(@"复制成功...");
            NSError * deleteOhterErr;
            [[NSFileManager defaultManager] removeItemAtPath:path2 error:&deleteOhterErr];
            if (!err) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)deleteCutFile
{
    if (isHasCutFile == NO) {
        [_audioController removeChannels:@[_player]];
    }
    else
    {
        [_audioController removeChannels:@[_cutFilePlayer]];
    }
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording3.m4a"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    NSError * err;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
    
    if (err) {
        NSLog(@"删除失败...");
    }
    else
    {
        NSLog(@"删除成功...");
        isHasCutFile = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
