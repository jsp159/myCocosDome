//
//  NewTimePitchFilterVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "NewTimePitchFilterVC.h"
#import "TheAmazingAudioEngine.h"
#import "AENewTimePitchFilter.h"

@interface NewTimePitchFilterVC ()
{
    NSTimeInterval bgMCurrentTime;
}

@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AENewTimePitchFilter * ntFilter;

@end

@implementation NewTimePitchFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self audioConfing];
}

- (void)audioConfing
{
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:NO];
    _audioController.preferredBufferDuration = 0.005;
    _audioController.useMeasurementMode = YES;
    _audioController.inputGain = 0;
    [_audioController start:NULL];
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.mp3"];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path] ) return;
    
    _player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:NULL];
    _player.volume = 1.0;
    _player.channelIsMuted = YES;
    _player.loop = YES;
    
    bgMCurrentTime = _player.currentTime;
    
    _ntFilter = [[AENewTimePitchFilter alloc] init];
    _ntFilter.rate = [_oneValueLabel.text floatValue];
    _ntFilter.pitch = [_twoValueLabel.text floatValue];
    _ntFilter.overlap = [_threeValueLabel.text floatValue];
    _ntFilter.enablePeakLocking = [_fourValueLabel.text floatValue];
}

- (IBAction)onChangeOneValue:(UISlider *)sender {
    _oneValueLabel.text = [NSString stringWithFormat:@"%.2f",sender.value];
    _ntFilter.rate = [_oneValueLabel.text floatValue];
}

- (IBAction)onChangeTwoValue:(UISlider *)sender {
    _twoValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _ntFilter.pitch = [_twoValueLabel.text floatValue];
}

- (IBAction)onChangeThreeValue:(UISlider *)sender {
    _threeValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _ntFilter.overlap = [_threeValueLabel.text floatValue];
}

- (IBAction)onChangeFourValue:(UISlider *)sender {
    _fourValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _ntFilter.enablePeakLocking = [_fourValueLabel.text floatValue];
}

- (IBAction)onPlay:(UIButton *)sender {
    _player.channelIsMuted = NO;
    
    [_audioController addChannels:[NSArray arrayWithObject:_player]];
    [_audioController addFilter:_ntFilter];
    [_player playAtTime:bgMCurrentTime];
}

- (IBAction)onPause:(UIButton *)sender {
    _player.channelIsMuted = YES;
    
    bgMCurrentTime = _player.currentTime;
    [_audioController removeChannels:[NSArray arrayWithObject:_player]];
    [_audioController removeFilter:_ntFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
