//
//  BgMusicItemModel.h
//  MyAudioDome
//
//  Created by jiangshiping on 18/1/3.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BgMusicItemModel : NSObject

@property (nonatomic, strong) NSString * soundImageUrl;
@property (nonatomic, strong) NSString * soundName;
@property (nonatomic, strong) NSString * soundAuthor;
@property (nonatomic, strong) NSString * soundTime;
@property (nonatomic, strong) NSString * soundDes;

@property (nonatomic, strong) NSString * soundId;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isDownloaded; //是否已经下载

@end
