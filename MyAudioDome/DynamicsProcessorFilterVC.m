//
//  DynamicsProcessorFilterVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "DynamicsProcessorFilterVC.h"
#import "TheAmazingAudioEngine.h"
#import "AEDynamicsProcessorFilter.h"

@interface DynamicsProcessorFilterVC ()
{
    NSTimeInterval bgMCurrentTime;
}

@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AEDynamicsProcessorFilter * dpFilter;

@end

@implementation DynamicsProcessorFilterVC

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
    
    _dpFilter = [[AEDynamicsProcessorFilter alloc] init];
    _dpFilter.threshold = [_oneValueLabel.text floatValue];
    _dpFilter.headRoom = [_twoValueLabel.text floatValue];
    _dpFilter.expansionRatio = [_threeValueLabel.text floatValue];
    _dpFilter.attackTime = [_fiveValueLabel.text floatValue];
    _dpFilter.releaseTime = [_sixValueLabel.text floatValue];
    _dpFilter.masterGain = [_sevenValueLabel.text floatValue];
}

- (IBAction)onChangeOneValue:(UISlider *)sender {
    _oneValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dpFilter.threshold = [_oneValueLabel.text floatValue];
}

- (IBAction)onChangeTwoValue:(UISlider *)sender {
    _twoValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _dpFilter.headRoom = [_twoValueLabel.text floatValue];
}

- (IBAction)onChangeThreeValue:(UISlider *)sender {
    _threeValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dpFilter.expansionRatio = [_threeValueLabel.text floatValue];
}

- (IBAction)onChangeFiveValue:(UISlider *)sender {
    _fiveValueLabel.text = [NSString stringWithFormat:@"%.4f",sender.value];
    _dpFilter.attackTime = [_fiveValueLabel.text floatValue];
}

- (IBAction)onChangeSixValue:(UISlider *)sender {
    _sixValueLabel.text = [NSString stringWithFormat:@"%.3f",sender.value];
    _dpFilter.releaseTime = [_sixValueLabel.text floatValue];
}

- (IBAction)onChangeSevenValue:(UISlider *)sender {
    _sevenValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dpFilter.masterGain = [_sevenValueLabel.text floatValue];
}
- (IBAction)onPlay:(UIButton *)sender {
    _player.channelIsMuted = NO;
    
    [_audioController addChannels:[NSArray arrayWithObject:_player]];
    [_audioController addFilter:_dpFilter];
    [_player playAtTime:bgMCurrentTime];
}

- (IBAction)onPause:(UIButton *)sender {
    _player.channelIsMuted = YES;
    
    bgMCurrentTime = _player.currentTime;
    [_audioController removeChannels:[NSArray arrayWithObject:_player]];
    [_audioController removeFilter:_dpFilter];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
