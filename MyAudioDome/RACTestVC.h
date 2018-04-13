//
//  RACTestVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACTestVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *inputTF;
- (IBAction)onSend:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *otherTF;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)onOther:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *other;
@property (strong, nonatomic) IBOutlet UILabel *oneLabel;

@end
