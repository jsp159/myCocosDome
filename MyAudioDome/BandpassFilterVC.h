//
//  BandpassFilterVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BandpassFilterVC : UIViewController
@property (strong, nonatomic) IBOutlet UISlider *oneSlider;
@property (strong, nonatomic) IBOutlet UILabel *oneValueLabel;
@property (strong, nonatomic) IBOutlet UISlider *twoSlider;
@property (strong, nonatomic) IBOutlet UILabel *twoValueLabel;
- (IBAction)onChangeOne:(UISlider *)sender;
- (IBAction)onChangeTwo:(UISlider *)sender;
- (IBAction)onPause:(UIButton *)sender;

- (IBAction)onPlay:(UIButton *)sender;
@end
