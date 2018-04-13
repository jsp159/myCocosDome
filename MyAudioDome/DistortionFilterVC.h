//
//  DistortionFilterVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistortionFilterVC : UIViewController
- (IBAction)onChangeOneValue:(UISlider *)sender;
- (IBAction)onChangeTwoValue:(UISlider *)sender;
- (IBAction)onChangeThreeValue:(UISlider *)sender;
- (IBAction)onChangeFourValue:(UISlider *)sender;
- (IBAction)onChangeFiveValue:(UISlider *)sender;
- (IBAction)onChangeSixValue:(UISlider *)sender;
- (IBAction)onChangeSevenValue:(UISlider *)sender;
- (IBAction)onChangeEgithValue:(UISlider *)sender;
- (IBAction)onChangeNineValue:(UISlider *)sender;
- (IBAction)onChangeTenValue:(UISlider *)sender;
- (IBAction)onChangeEvelenValue:(UISlider *)sender;
- (IBAction)onChangeTwelveValue:(UISlider *)sender;
- (IBAction)onChangeThirteenValue:(UISlider *)sender;
- (IBAction)onChangeFourteenValue:(UISlider *)sender;
- (IBAction)onChangeFifteenValue:(UISlider *)sender;
- (IBAction)onChangeSixteenValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UILabel *oneValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *fiveValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *sixValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *sevenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *eightValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *nineValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *tenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *elevenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *twelenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirteenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourteenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *fifteenValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *sixteenValueLabel;


- (IBAction)onPlay:(UIButton *)sender;
- (IBAction)onPause:(UIButton *)sender;

@end
