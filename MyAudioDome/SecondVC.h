//
//  SecondVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/1.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEAudioController;

@interface SecondVC : UIViewController

@property (nonatomic, strong) AEAudioController *audioController;
- (IBAction)openAndCloseBgSound:(UIButton *)sender;
- (IBAction)onRecord:(UIButton *)sender;
- (IBAction)onPlayRecord:(UIButton *)sender;
- (IBAction)onStopRecord:(UIButton *)sender;
- (IBAction)onClose:(UISwitch *)sender;
- (IBAction)onSelectMusic:(UIButton *)sender;
- (IBAction)onPush:(UIButton *)sender;


@end
