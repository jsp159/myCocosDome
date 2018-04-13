//
//  TBCycleView.m
//  TBCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "TBCycleView.h"
@interface TBCycleView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation TBCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radiusWidth = frame.size.width;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGRect rect = {0,0,_radiusWidth-1, _radiusWidth-1};
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor blueColor].CGColor;
    self.progressLayer.lineWidth = 2;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.path = path.CGPath;
    [self.layer addSublayer:self.progressLayer];
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

- (void)drawProgress:(CGFloat )progress
{
    self.progressLayer.strokeEnd =  progress;
}



@end
