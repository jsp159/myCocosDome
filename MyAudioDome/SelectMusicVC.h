//
//  SelectMusicVC.h
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/8.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SelectMusicVC : UIViewController

/**
 *  选择歌曲
 */
@property (nonatomic,strong)void(^onSelectMusicName)(NSString *musicName);

@end
