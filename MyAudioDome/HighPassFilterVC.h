//
//  HighPassFilterVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighPassFilterVC : UIViewController
- (IBAction)onChangeOneValue:(UISlider *)sender;
- (IBAction)onChangeTwoValue:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UILabel *oneValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoValueLabel;

- (IBAction)onPlay:(UIButton *)sender;
- (IBAction)onPause:(UIButton *)sender;


@end
