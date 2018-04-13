//
//  BgMusicButton.h
//  MyAudioDome
//
//  Created by jiangshiping on 18/1/27.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCycleView.h"

@interface BgMusicButton : UIView
{
    NSTimer *_timer;
    NSInteger value;
}

@property(nonatomic,strong)UIImageView * bgImage;

@property (strong, nonatomic)TBCycleView *cycleView;

@property (strong, nonatomic)CAShapeLayer *progressLayer;

@property(nonatomic,strong)UIButton * playBtn;


@end
