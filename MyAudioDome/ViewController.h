//
//  ViewController.h
//  MyAudioDome
//
//  Created by jiangshiping on 17/11/16.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <EZAudio/EZAudio.h>
@class AEAudioController;

@interface ViewController : UIViewController<EZMicrophoneDelegate>

@property (nonatomic, strong) AEAudioController *audioPlayer;
@property (nonatomic, strong) AEAudioController *audioBgPlayer;
//@property (nonatomic, strong) AEAudioController *audioSoundPlayer;

@property (nonatomic, strong) EZMicrophone *microphone;

- (IBAction)playAudio:(UIButton *)sender;
- (IBAction)stopAudio:(UIButton *)sender;
- (IBAction)startRecord:(UIButton *)sender;
- (IBAction)stopRecord:(UIButton *)sender;
- (IBAction)onPlayRecord:(UIButton *)sender;
- (IBAction)onPlayRecord2:(UIButton *)sender;
- (IBAction)onPlayRecord3:(UIButton *)sender;
- (IBAction)onRecord2:(UIButton *)sender;
- (IBAction)onStopRecord2:(UIButton *)sender;
- (IBAction)onStartRecord3:(UIButton *)sender;
- (IBAction)onStopRecord3:(UIButton *)sender;
- (IBAction)onPlayRecord4:(UIButton *)sender;

@end

