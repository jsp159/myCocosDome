//
//  RequestModel.h
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject

@property(nonatomic,strong)NSString * isbn13;

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *image;

@property(nonatomic,strong)NSString *alt;

@property(nonatomic,strong)NSString *isbn10;

@end
