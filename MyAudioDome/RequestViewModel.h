//
//  RequestViewModel.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RequestViewModel : NSObject

@property(nonatomic,strong,readonly)RACCommand * requestCommand;

@end
