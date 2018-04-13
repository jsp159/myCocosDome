//
//  BgMusicItem.h
//  MyAudioDome
//
//  Created by jiangshiping on 18/1/3.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BgMusicItemModel;
@class AudioButton;

@interface BgMusicItem : UITableViewCell

//背景
@property(nonatomic,retain) UIView * bgView;
//图片
@property(nonatomic,retain) UIImageView *soundImageView;
//音乐名字
@property(nonatomic,retain) UILabel *soundNameLabel;
//作者
@property(nonatomic,retain) UILabel *soundAuthorLabel;
//音乐时间
@property(nonatomic,retain) UILabel *soundTimeLabel;
//音乐描述
@property(nonatomic,retain) UILabel *soundDesLabel;

////音乐播放按钮
//@property(nonatomic,retain) AudioButton * audioButton;
//音乐播放按钮
@property(nonatomic,retain) UIButton * playButton;

//
@property(nonatomic,retain) UIButton * useBtn;

//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;


@property (nonatomic,strong) BgMusicItemModel * model;

- (void)setUrl:(NSString *)url andSongName:(NSString *)songName;

@property (nonatomic,copy)NSString *url;

@end
