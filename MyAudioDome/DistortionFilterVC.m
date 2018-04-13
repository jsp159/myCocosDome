//
//  DistortionFilterVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "DistortionFilterVC.h"
#import "TheAmazingAudioEngine.h"
#import "AEDistortionFilter.h"

@interface DistortionFilterVC ()
{
    NSTimeInterval bgMCurrentTime;
}

@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AEDistortionFilter * dtFilter;

@end

@implementation DistortionFilterVC

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
    
    _dtFilter = [[AEDistortionFilter alloc] init];
    _dtFilter.delay = [_oneValueLabel.text floatValue];
    _dtFilter.decay = [_twoValueLabel.text floatValue];
    _dtFilter.delayMix = [_threeValueLabel.text floatValue];
    _dtFilter.decimation = [_fourValueLabel.text floatValue];
    _dtFilter.rounding = [_fiveValueLabel.text floatValue];
    _dtFilter.decimationMix = [_sixValueLabel.text floatValue];
    _dtFilter.linearTerm = [_sevenValueLabel.text floatValue];
    _dtFilter.squaredTerm = [_eightValueLabel.text floatValue];
    _dtFilter.cubicTerm = [_nineValueLabel.text floatValue];
    _dtFilter.polynomialMix = [_tenValueLabel.text floatValue];
    _dtFilter.ringModFreq1 = [_elevenValueLabel.text floatValue];
    _dtFilter.ringModFreq2 = [_twelenValueLabel.text floatValue];
    _dtFilter.ringModBalance = [_thirteenValueLabel.text floatValue];
    _dtFilter.ringModMix = [_fourValueLabel.text floatValue];
    _dtFilter.softClipGain = [_fifteenValueLabel.text floatValue];
    _dtFilter.finalMix = [_sixValueLabel.text floatValue];
}

- (IBAction)onChangeOneValue:(UISlider *)sender {
    _oneValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _dtFilter.delay = [_oneValueLabel.text floatValue];
}

- (IBAction)onChangeTwoValue:(UISlider *)sender {
    _twoValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _dtFilter.delayMix = [_twoValueLabel.text floatValue];
}

- (IBAction)onChangeThreeValue:(UISlider *)sender {
    _threeValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dtFilter.delay = [_threeValueLabel.text floatValue];
}

- (IBAction)onChangeFourValue:(UISlider *)sender {
    _fourValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.decimation = [_fourValueLabel.text floatValue];
}

- (IBAction)onChangeFiveValue:(UISlider *)sender {
    _fiveValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.rounding = [_fiveValueLabel.text floatValue];
}

- (IBAction)onChangeSixValue:(UISlider *)sender {
    _sixValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.decimationMix = [_sixValueLabel.text floatValue];
}

- (IBAction)onChangeSevenValue:(UISlider *)sender {
    _sevenValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _dtFilter.linearTerm = [_sevenValueLabel.text floatValue];
}

- (IBAction)onChangeEgithValue:(UISlider *)sender {
    _eightValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dtFilter.squaredTerm = [_eightValueLabel.text floatValue];
}

- (IBAction)onChangeNineValue:(UISlider *)sender {
    _nineValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dtFilter.cubicTerm = [_nineValueLabel.text floatValue];
}

- (IBAction)onChangeTenValue:(UISlider *)sender {
    _tenValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.polynomialMix = [_tenValueLabel.text floatValue];
}

- (IBAction)onChangeEvelenValue:(UISlider *)sender {
    _elevenValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _dtFilter.ringModFreq1 = [_elevenValueLabel.text floatValue];
}

- (IBAction)onChangeTwelveValue:(UISlider *)sender {
    _twelenValueLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    _dtFilter.ringModFreq2 = [_twelenValueLabel.text floatValue];
}

- (IBAction)onChangeThirteenValue:(UISlider *)sender {
    _thirteenValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.ringModBalance = [_thirteenValueLabel.text floatValue];
}

- (IBAction)onChangeFourteenValue:(UISlider *)sender {
    _fourteenValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.ringModMix = [_fourteenValueLabel.text floatValue];
}

- (IBAction)onChangeFifteenValue:(UISlider *)sender {
    _fifteenValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _dtFilter.softClipGain = [_fifteenValueLabel.text floatValue];
}

- (IBAction)onChangeSixteenValue:(UISlider *)sender {
    _sixteenValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value*100];
    _dtFilter.finalMix = [_sixteenValueLabel.text floatValue];
}

- (IBAction)onPlay:(UIButton *)sender {
    _player.channelIsMuted = NO;
    
    [_audioController addChannels:[NSArray arrayWithObject:_player]];
    [_audioController addFilter:_dtFilter];
    [_player playAtTime:bgMCurrentTime];
}

- (IBAction)onPause:(UIButton *)sender {
    _player.channelIsMuted = YES;
    
    bgMCurrentTime = _player.currentTime;
    [_audioController removeChannels:[NSArray arrayWithObject:_player]];
    [_audioController removeFilter:_dtFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
