//
//  BgMusicItem.m
//  MyAudioDome
//
//  Created by jiangshiping on 18/1/3.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "BgMusicItem.h"
#import "BgMusicItemModel.h"
#import "AudioButton.h"

#import "MCDownloader.h"

#import "UIImageView+WebCache.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define px (SCREEN_HEIGHT / (2*667.0))

@implementation BgMusicItem

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, 70)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    
    _soundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [_bgView addSubview:_soundImageView];
    _soundImageView.image = [UIImage imageNamed:@"head1.jpg"];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(_soundImageView.frame.origin.x + 10, _soundImageView.frame.origin.y +  10, 50, 50);
    [_bgView addSubview:_playButton];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    
    _soundNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_soundImageView.frame.origin.x + 85, 5, SCREEN_WIDTH - 100, 20)];
    [_bgView addSubview:_soundNameLabel];
    _soundNameLabel.font = [UIFont systemFontOfSize:30*px];
    
    _soundAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_soundImageView.frame.origin.x + 85, _soundNameLabel.frame.origin.y +20 , SCREEN_WIDTH - 100, 20)];
    [_bgView addSubview:_soundAuthorLabel];
    _soundAuthorLabel.font = [UIFont systemFontOfSize:26*px];
    
    _soundTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_soundImageView.frame.origin.x + 85, _soundAuthorLabel.frame.origin.y +20, SCREEN_WIDTH - 100, 20)];
    [_bgView addSubview:_soundTimeLabel];
    _soundTimeLabel.font = [UIFont systemFontOfSize:26*px];
    
    _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_useBtn];
    _useBtn.frame = CGRectMake(40*px, 165*px, SCREEN_WIDTH-80*px, 80*px);
    [_useBtn setTitle:@"下载" forState:UIControlStateNormal];
    [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _useBtn.backgroundColor = [UIColor colorWithRed:90/255.0 green:87/255.0 blue:251/255.0 alpha:1.0];
    _useBtn.layer.cornerRadius = 6;
    [_useBtn setImage:[UIImage imageNamed:@"光盘"] forState:UIControlStateNormal];
    _useBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    _useBtn.hidden = YES;
    
}


- (void)setModel:(BgMusicItemModel *)model
{
    _model = model;
    
    BOOL flag = model.isSelected;
    
    BOOL isDown = model.isDownloaded;
    
    if (flag == YES) {
        _bgView.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, 150-10);
        _useBtn.hidden = NO;
        _playButton.selected = YES;
    }
    else
    {
        _bgView.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, 70);
        _useBtn.hidden = YES;
        _playButton.selected = NO;
    }
    
    if (isDown) {
        [self.useBtn setTitle:@"确认使用" forState:UIControlStateNormal];
    }else {
        [self.useBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
    
    [_soundImageView sd_setImageWithURL:[NSURL URLWithString:model.soundImageUrl] placeholderImage:[UIImage imageNamed:@"head1.jpg"]];
    
    _soundNameLabel.text = model.soundName;
    _soundAuthorLabel.text = model.soundAuthor;
    _soundTimeLabel.text  = model.soundTime;
}

- (void)setUrl:(NSString *)url andSongName:(NSString *)songName {
    
    NSLog(@"music Url ======  %@",url);
    if (url == nil) {
        return;
    }
    
    _url = url;
    
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
    
    receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        NSString *cacheFolderPath = [cacheDir stringByAppendingPathComponent:@"localMusic"];
        NSString * tmpSongName = [NSString stringWithFormat:@"%@.mp3",songName];
        return [cacheFolderPath stringByAppendingPathComponent:tmpSongName];
    };
    
    //    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:receipt.filePath]];
    
//    if (receipt.state == MCDownloadStateCompleted) {
//        [self.useBtn setTitle:@"确认使用" forState:UIControlStateNormal];
//    }else {
//        [self.useBtn setTitle:@"下载" forState:UIControlStateNormal];
//    }
    
    receipt.downloaderCompletedBlock = ^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
        if (error) {
            [self.useBtn setTitle:@"下载" forState:UIControlStateNormal];
        }else {
            [self.useBtn setTitle:@"确认使用" forState:UIControlStateNormal];
            _model.isDownloaded = YES;
        }
        
    };
}

@end
