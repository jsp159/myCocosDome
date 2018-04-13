//
//  BandpassFilterVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "BandpassFilterVC.h"
#import "TheAmazingAudioEngine.h"
#import "AEBandpassFilter.h"

@interface BandpassFilterVC ()
{
    NSTimeInterval bgMCurrentTime;
}

@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) AEBandpassFilter * bpFilter;

@end

@implementation BandpassFilterVC

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
    
    _bpFilter = [[AEBandpassFilter alloc] init];
    _bpFilter.centerFrequency = [_oneValueLabel.text floatValue];
    _bpFilter.bandwidth = [_twoValueLabel.text floatValue];
}


- (IBAction)onChangeOne:(UISlider *)sender {
    _oneValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _bpFilter.centerFrequency = [_oneValueLabel.text floatValue];
}

- (IBAction)onChangeTwo:(UISlider *)sender {
    _twoValueLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    _bpFilter.bandwidth = [_twoValueLabel.text floatValue];
}

- (IBAction)onPause:(UIButton *)sender {
    
    _player.channelIsMuted = YES;
    
    bgMCurrentTime = _player.currentTime;
    [_audioController removeChannels:[NSArray arrayWithObject:_player]];
    [_audioController removeFilter:_bpFilter];
}

- (IBAction)onPlay:(UIButton *)sender {
    
    _player.channelIsMuted = NO;
    
    [_audioController addChannels:[NSArray arrayWithObject:_player]];
    [_audioController addFilter:_bpFilter];
    [_player playAtTime:bgMCurrentTime];
   
}
@end
