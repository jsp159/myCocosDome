//
//  RACOtherVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/12.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACOtherVC : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *otherSwitch;
- (IBAction)onChange:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *subBtn;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;

@end
