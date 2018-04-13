//
//  DelayFilterVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayFilterVC : UIViewController
- (IBAction)onChangeOneValue:(UISlider *)sender;
- (IBAction)onChangeTwoValue:(UISlider *)sender;
- (IBAction)onChangeThreeValue:(UISlider *)sender;
- (IBAction)onChangeFourValue:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *oneValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourValueLabel;
- (IBAction)onPlay:(UIButton *)sender;
- (IBAction)onPause:(UIButton *)sender;

@end
