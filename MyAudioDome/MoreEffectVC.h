//
//  MoreEffectVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface MoreEffectVC : UIViewController

@property(nonatomic,strong)NSString * soundName;

@property(nonatomic, strong)RACSubject *subject;

@end
