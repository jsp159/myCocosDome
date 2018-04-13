//
//  SecondVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/1.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import "SecondVC.h"
#import "AppDelegate.h"
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "AEPlaythroughChannel.h"
#import "AEVarispeedFilter.h"
#import "AEHighPassFilter.h"
#import "AELowPassFilter.h"
#import "AEExpanderFilter.h"
#import "AEReverbFilter.h"
#import "AEDistortionFilter.h"
#import "AEParametricEqFilter.h"

#import "SelectMusicVC.h"

#import "WaveVC.h"

@interface SecondVC ()
{
    BOOL rFlag;
    
    BOOL bgMFlag;
    
    NSString * currentMusicName;
}

@property (nonatomic, strong) AEAudioFilePlayer *bgSound;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (nonatomic, strong) AEPlaythroughChannel *playthrough;

@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AERecorder *bgRecorder;

@property (nonatomic, strong) id<AEAudioReceiver> receiver;

@property (nonatomic, strong) AEAudioFileWriter *bgWriter;

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    rFlag = YES;
    bgMFlag = YES;
    currentMusicName = @"胡杏儿-感激遇到你";
    
    [self audioConfing];
    
    NSArray * arr = [_audioController inputReceivers];
    NSLog(@"input receivers ==== %@",arr);
}


- (void)audioConfing
{
//    _audioController = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleavedFloatStereo inputEnabled:YES];
//    _audioController.preferredBufferDuration = 0.005;
//    _audioController.useMeasurementMode = YES;
//    [_audioController start:NULL];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _audioController = appDelegate.audioController;
    
    _audioController.inputChannelSelection = [NSArray arrayWithObjects:
                                              [NSNumber numberWithInt:2],
                                              [NSNumber numberWithInt:3],
                                              nil];
    
    _bgSound = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:currentMusicName withExtension:@"mp3"] error:NULL];
    _bgSound.volume = 1.0;
    _bgSound.channelIsMuted = bgMFlag;
    _bgSound.loop = YES;
    
    [_audioController addChannels:[NSArray arrayWithObject:_bgSound]];
    
//    self.playthrough = [[AEPlaythroughChannel alloc] init];
//    [_audioController addInputReceiver:_playthrough];
//    [_audioController addChannels:@[_playthrough]];
    
    _bgWriter = [[AEAudioFileWriter alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo];
}

- (IBAction)openAndCloseBgSound:(UIButton *)sender {
    
    bgMFlag = sender.isSelected;
    
    _bgSound.channelIsMuted = bgMFlag;
    
    sender.selected = !bgMFlag;
}

- (IBAction)onRecord:(UIButton *)sender {
    
    NSLog(@"开始录音...");
    self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
    self.bgRecorder = [[AERecorder alloc] initWithAudioController:_audioController];
    
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    
    NSString *path = [documentsFolder stringByAppendingPathComponent:@"Recording.wav"];
    NSError *error = nil;
    if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileWAVEType bitDepth:16 channels:0 error:&error] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        self.recorder = nil;
        return;
    }
    
    NSString *path2 = [documentsFolder stringByAppendingPathComponent:@"bgRecording.wav"];
    NSError *error2 = nil;
    
    if ( ![_bgRecorder beginRecordingToFileAtPath:path2 fileType:kAudioFileWAVEType bitDepth:16 channels:1 error:&error2] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error2"
                                    message:[NSString stringWithFormat:@"Couldn't start recording2: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        self.bgRecorder = nil;
        return;
    }
    
    AEParametricEqFilter * eqFilter = [[AEParametricEqFilter alloc] init];
    eqFilter.centerFrequency = 10000;
    eqFilter.qFactor         = 1.0;
    eqFilter.gain            = 10;

    [_audioController addFilter:eqFilter];
    
    [_audioController addOutputReceiver:_bgRecorder];
    [_audioController addInputReceiver:_recorder];
    
    
    
    NSArray * arr = [_audioController inputReceivers];
    NSLog(@"input receivers ==== %@",arr);
}

/*
- (IBAction)onRecord:(UIButton *)sender {
    
    NSLog(@"开始录音...");
//    self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
    
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    NSString *filePath = [documentsFolder stringByAppendingPathComponent:@"Recording.wav"];
    
    _receiver = [AEBlockAudioReceiver audioReceiverWithBlock:^(void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
        
        
        OSStatus status = AEAudioFileWriterAddAudio(_bgWriter, audio, frames);
        if ( status != noErr ) {
            NSLog(@"_bgWriter err....");
        }
        
    }];
    
    [_audioController addInputReceiver:_receiver forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
    
    
    NSError *error = nil;
    [_bgWriter beginWritingToFileAtPath:filePath fileType:kAudioFileWAVEType bitDepth:16 channels:0 error:&error];

    
    AEVarispeedFilter * speedFilter = [[AEVarispeedFilter alloc] init];
    speedFilter.playbackRate = 0.8;
    speedFilter.playbackCents = 500;

//    [_audioController addInputFilter:speedFilter forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
//
//    [_audioController addInputFilter:speedFilter];
    
    AEBlockFilter *filter = [AEBlockFilter filterWithBlock:
                             ^(AEAudioFilterProducer     producer,
                               void                     *producerToken,
                               const AudioTimeStamp     *time,
                               UInt32                    frames,
                               AudioBufferList          *audio) {
                                 
                                 // Pull audio
                                 OSStatus status = producer(producerToken, audio, &frames);
                                 if ( status != noErr ) return;
                                 
                                 // Now filter audio in 'audio'
                                 
                             }];
//
//    [_audioController addInputFilter:filter forChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
}
*/

- (IBAction)onPlayRecord:(UIButton *)sender {
    
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.wav"];
    
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
    
    
    [_audioController addChannels:@[_player]];
    
//    AEVarispeedFilter * speedFilter = [[AEVarispeedFilter alloc] init];
//    speedFilter.playbackRate = 0.8;
//    speedFilter.playbackCents = 0;
//
//    [_audioController addFilter:speedFilter toChannel:_player];

    
//    AEBlockFilter *filter = [AEBlockFilter filterWithBlock:
//                             ^(AEAudioFilterProducer     producer,
//                               void                     *producerToken,
//                               const AudioTimeStamp     *time,
//                               UInt32                    frames,
//                               AudioBufferList          *audio) {
//
//                                 // Pull audio
//                                 OSStatus status = producer(producerToken, audio, &frames);
//                                 if ( status != noErr ) return;
//
//                                 // Now filter audio in 'audio'
//                             }];
//
//    [_audioController addFilter:filter toChannel:_player];
    
//    AEHighPassFilter * highPassFilter = [[AEHighPassFilter alloc] init];
//    highPassFilter.resonance = 10;
//    highPassFilter.cutoffFrequency = 5000;
//    [_audioController addFilter:highPassFilter toChannel:_player];
    
//    AELowPassFilter * lowPassFilter = [[AELowPassFilter alloc] init];
//    lowPassFilter.resonance = 10;
//    lowPassFilter.cutoffFrequency = 5000;
//    [_audioController addFilter:lowPassFilter toChannel:_player];
    
    __weak __typeof__(self) weakSelf = self;
    
    if (rFlag == YES) {
        
//        AEVarispeedFilter * speedFilter = [[AEVarispeedFilter alloc] init];
//        speedFilter.playbackRate = 0.8;
//        speedFilter.playbackCents = 700;
//    
//        [_audioController addFilter:speedFilter];
        
        
//        AEExpanderFilter * expanderFilter = [[AEExpanderFilter alloc] init];
//        [expanderFilter assignPreset:AEExpanderFilterPresetSmooth];
//        
////        [_audioController addFilter:expanderFilter toChannel:_player];
//        [_audioController addFilter:expanderFilter];
        
        
        AEReverbFilter * reverbFilter = [[AEReverbFilter alloc] init];
        reverbFilter.randomizeReflections = 100;
        reverbFilter.dryWetMix = 50;
        reverbFilter.decayTimeAt0Hz = 2;
        reverbFilter.decayTimeAtNyquist = 2;
        
        [_audioController addFilter:reverbFilter toChannel:_player];
//        [_audioController addFilter:reverbFilter];
        
//        AEDistortionFilter * distortionFilter = [[AEDistortionFilter alloc] init];
//        distortionFilter.delay = 10;
//        distortionFilter.decimation = 20;
//        
//        [_audioController addFilter:distortionFilter toChannel:_player];
        
        _player.completionBlock = ^{
            
//            [weakSelf.audioController removeFilter:speedFilter];
//            [weakSelf.audioController removeFilter:expanderFilter];
            [weakSelf.audioController removeFilter:reverbFilter fromChannel:weakSelf.player];
        };
    }
    
    
}

/*
- (IBAction)onStopRecord:(UIButton *)sender {
    NSLog(@"结束录音...");
//    [_recorder finishRecording];
//    [_audioController removeInputReceiver:_recorder];
//    [_audioController removeOutputReceiver:_recorder];
//    [_audioController removeInputReceiver:_recorder fromChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:2]]];
    
    [_audioController removeInputReceiver:_receiver fromChannels:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
    [_bgWriter finishWriting];
}
 */

- (IBAction)onStopRecord:(UIButton *)sender {
    NSLog(@"结束录音...");
    [_recorder finishRecording];
    [_bgRecorder finishRecording];
    [_audioController removeInputReceiver:_recorder];
    [_audioController removeOutputReceiver:_bgRecorder];
    
}

- (IBAction)onClose:(UISwitch *)sender {
    
    rFlag = sender.isOn;
}

- (IBAction)onSelectMusic:(UIButton *)sender {
    
    SelectMusicVC * selectMusicVC = [[SelectMusicVC alloc] init];
    [self.navigationController pushViewController:selectMusicVC animated:YES];
    
    selectMusicVC.onSelectMusicName = ^(NSString *musicName){
        
        currentMusicName = musicName;
        
        [_audioController removeChannels:[NSArray arrayWithObject:_bgSound]];
        _bgSound = nil;
        
        _bgSound = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:currentMusicName withExtension:@"mp3"] error:NULL];
        _bgSound.volume = 1.0;
        _bgSound.channelIsMuted = bgMFlag;
        _bgSound.loop = YES;
        
        [_audioController addChannels:[NSArray arrayWithObject:_bgSound]];
    };
    
}

- (IBAction)onPush:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    WaveVC * waveVC = [[WaveVC alloc] init];
    [self.navigationController pushViewController:waveVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
