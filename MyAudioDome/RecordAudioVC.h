//
//  RecordAudioVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/26.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEAudioController;

@interface RecordAudioVC : UIViewController

@property (nonatomic, strong) AEAudioController *audioController;

- (IBAction)onPlayRecordAudio:(UIButton *)sender;
- (IBAction)onCloseMic:(UIButton *)sender;
- (IBAction)onOpenMic:(UIButton *)sender;
- (IBAction)onColseBgMusic:(UIButton *)sender;
- (IBAction)onOpenBgMusic:(UIButton *)sender;
- (IBAction)onSelectMusic:(UIButton *)sender;
- (IBAction)onEnterCutAudio:(UIButton *)sender;
- (IBAction)onChangeToMp3:(UIButton *)sender;
- (IBAction)onPlayMp3:(UIButton *)sender;
- (IBAction)testSignalGCD:(UIButton *)sender;
- (IBAction)onCloseFilter:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UITextField *parametricTF;

@property (strong, nonatomic) IBOutlet UILabel *gainLabel;
- (IBAction)onChangeGianValue:(UISlider *)sender;
@end
