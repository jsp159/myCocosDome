//
//  SoundSlider.m
//  MyAudioDome
//
//  Created by jiangshiping on 18/1/27.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "SoundSlider.h"

@implementation SoundSlider

- (id)initWithSoundSlider:(CGFloat)height
{
    self = [super init];
    if (self) {
        _height = height;
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.transform =  CGAffineTransformMakeRotation( - M_PI * 0.5 );
    
//    UIImage* trackImg = [UIImage imageNamed: @"形状4"];
//    
//    [self setMinimumTrackImage:trackImg forState: UIControlStateNormal];
//    [self setMaximumTrackImage:trackImg forState: UIControlStateNormal];
    
    UIImage* thumbImg = [UIImage imageNamed: @"形状4"];
    
    [self setThumbImage:thumbImg forState: UIControlStateHighlighted];
    [self setThumbImage:thumbImg forState: UIControlStateNormal];
}

//- (CGRect)trackRectForBounds:(CGRect)bounds
//{
//    bounds = [super trackRectForBounds:bounds]; // 必须通过调用父类的trackRectForBounds 获取一个 bounds 值，否则 Autolayout 会失效，UISlider 的位置会跑偏。
//    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, _height); // 这里面的h即为你想要设置的高度。
//}
//
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value]; // 这次如果不调用的父类的方法 Autolayout 倒是不会有问题，但是滑块根本就不动~
//    return CGRectMake(bounds.origin.x, bounds.origin.y, 20, 20); // w 和 h 是滑块可触摸范围的大小，跟通过图片改变的滑块大小应当一致。
//}
//
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
//{
//    bounds = [super minimumValueImageRectForBounds:bounds];
//    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
//}
//
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
//{
//    bounds = [super maximumValueImageRectForBounds:bounds];
//    return bounds;
//}

@end
