//
//  BgMusicButton.m
//  MyAudioDome
//
//  Created by jiangshiping on 18/1/27.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "BgMusicButton.h"

@implementation BgMusicButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        value = 0;
    }
    return self;
}


- (void)setupUI
{
    _bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_bgImage];
    _bgImage.backgroundColor = [UIColor redColor];
    _bgImage.image = [UIImage imageNamed:@"head1.jpg"];
    _bgImage.layer.cornerRadius = self.frame.size.width/2;
    _bgImage.layer.masksToBounds = YES;
    
    _cycleView = [[TBCycleView alloc] initWithFrame:self.bounds];
    [self addSubview:_cycleView];
    [_cycleView drawProgress:0];
    
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_playBtn];
    _playBtn.frame =  CGRectMake(9, 9, 25, 25);
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playBgMusic:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)playBgMusic:(UIButton *)sender
{
    if (!sender.selected) {
        _playBtn.selected = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    else
    {
        _playBtn.selected = NO;
        [_timer invalidate];
    }
}

- (void)timerAction:(id)timer
{
    value++;
    
    if (value >= 100) {
        value = 0;
    }
    
    [_cycleView drawProgress:value/100.0];
}


@end
