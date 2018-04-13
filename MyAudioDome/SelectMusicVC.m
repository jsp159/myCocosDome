//
//  SelectMusicVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/8.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import "SelectMusicVC.h"
#import "BgMusicItem.h"
#import "BgMusicItemModel.h"
#import "MBProgressHUD+Add.h"
#import "HttpTool.h"
#import "AudioPlayer.h"
#import "AudioButton.h"

#import "MCDownloader.h"

#import "UIImageView+WebCache.h"

#import "DOUAudioStreamer.h"
#import "Track.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define px (SCREEN_HEIGHT / (2*667.0))

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface SelectMusicVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTable;
    
    NSArray * musicArr;
    
    NSMutableArray * myLocalMusicArr;
    
    NSMutableArray * myMusicArr;
    
    NSInteger lastTouchCellIndex;
    NSInteger currentCellIndex;
    
    NSString * songUrl;
    
    NSDictionary * songDic;
    
}

@property(nonatomic,strong)AudioPlayer * audioPlayer;

@property (nonatomic, strong) DOUAudioStreamer *streamer;

@end

@implementation SelectMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    myLocalMusicArr = [[NSMutableArray alloc] init];
    myMusicArr = [[NSMutableArray alloc] init];
    lastTouchCellIndex = -1;
    currentCellIndex = -1;
    
    [self getLocalMusic];
    
    [self createUI];
    
//    [self initData];
    [self onGetSongData];
    

}

#pragma mark - 获取本地下载的音乐
- (void)getLocalMusic
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *musicInfoPath = [path stringByAppendingPathComponent:@"localMusicInfo"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:musicInfoPath error:nil]];
    for (int i = 0; i < tempFileList.count; i++) {
        NSString * fileName = [tempFileList objectAtIndex:i];
        NSString * filePath = [musicInfoPath stringByAppendingPathComponent:fileName];
        NSLog(@"file path ====== %@",filePath);
        NSDictionary * fileDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        [myLocalMusicArr addObject:fileDic];
    }
    
    NSLog(@"myLocalMusicArr count ==== %lu",(unsigned long)myLocalMusicArr.count);
}

#pragma mark - 获取歌曲数据
-(void)onGetSongData{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *parameters = @{@"method":@"baidu.ting.billboard.billList",@"type":@"2",@"size":@"20",@"offset":@"0"};
    
    NSString *createURLString = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting"];
    
    
    //网络请求
    [HttpTool GET:createURLString parameters:parameters andJsessionid:nil success:^(id responseObject) {
        
        NSLog(@"--Success: %@", responseObject);
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger status = [responseObject[@"error_code"]  integerValue];
        if (status == 22000) {
            NSArray * songList = [responseObject objectForKey:@"song_list"];
            for (NSDictionary * tmpSongDic in songList) {
                BgMusicItemModel * bgiModel = [[BgMusicItemModel alloc] init];
                bgiModel.soundImageUrl = [tmpSongDic objectForKey:@"pic_small"];
                bgiModel.soundName = [tmpSongDic objectForKey:@"title"];
                bgiModel.soundAuthor = [tmpSongDic objectForKey:@"author"];
                bgiModel.soundDes = [tmpSongDic objectForKey:@"style"];
                bgiModel.soundTime = [self timeIntervalToMMSSFormat:[tmpSongDic objectForKey:@"file_duration"]];
                bgiModel.soundId = [tmpSongDic objectForKey:@"song_id"];
                bgiModel.isSelected = NO;
                bgiModel.isDownloaded = NO;
                
                [myMusicArr addObject:bgiModel];
            }
            
            for (int i = 0; i < myLocalMusicArr.count; i++) {
                
                NSDictionary * fileDic = [myLocalMusicArr objectAtIndex:i];
                NSString * songId = [[fileDic objectForKey:@"songinfo"] objectForKey:@"song_id"];
                
                for (int j = 0; j < myMusicArr.count; j++) {
                    
                    BgMusicItemModel * bgiModel = [myMusicArr objectAtIndex:j];
                    if ([bgiModel.soundId isEqualToString:songId]) {
                        bgiModel.isDownloaded = YES;
                    }
                }
            }
            
            [myTable reloadData];
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"err is %@",error.description);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

- (void)createUI
{
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:myTable];
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initData
{
    musicArr = [NSArray arrayWithObjects:@"7 AND 5-Remember",@"Approaching Nirvana-Quixote",@"胡杏儿-感激遇到你",@"陈奕迅-富士山下",@"谢安琪-喜帖街",@"SNH48-天使与恶魔", nil];
    
    for (int i = 0; i < musicArr.count; i++) {
        BgMusicItemModel * bgiModel = [[BgMusicItemModel alloc] init];
        bgiModel.soundImageUrl = @"";
        bgiModel.soundName = [musicArr objectAtIndex:i];
        bgiModel.soundAuthor = @"未知";
        bgiModel.soundDes = @"This is a sound...";
        bgiModel.soundTime = @"04:22";
        bgiModel.isSelected = NO;
        
        [myMusicArr addObject:bgiModel];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myMusicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * cellIndentifier = @"cellItem";
//    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    NSString * musicName = [musicArr objectAtIndex:indexPath.row];
//    cell.textLabel.text = musicName;
//    
//    return cell;
    
    static NSString *cellIndentifier = @"BgMusicItem";
    
    BgMusicItem *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if ( cell == nil ) {
        
        cell = [[BgMusicItem alloc] initWithReuseIdentifier:cellIndentifier];
        
    }
    
    BgMusicItemModel * model = [myMusicArr objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    cell.useBtn.tag = indexPath.row;
    [cell.useBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (lastTouchCellIndex == -1) {
        currentCellIndex = indexPath.row;
//        lastTouchCellIndex = currentCellIndex;
    }
    else
    {
        lastTouchCellIndex = currentCellIndex;
        currentCellIndex = indexPath.row;
    }
    
    
    for (BgMusicItemModel * bmiModel in myMusicArr) {
        bmiModel.isSelected = NO;
    }
    
    if (lastTouchCellIndex != indexPath.row) {
        lastTouchCellIndex = currentCellIndex;
        BgMusicItemModel * bmiModel = [myMusicArr objectAtIndex:indexPath.row];
        bmiModel.isSelected = YES;
        
        [self getSoundInfo:indexPath.row];
    }
    else
    {
        lastTouchCellIndex = -1;
        [self stopAudio];
    }
    
    [tableView reloadData];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentCellIndex == indexPath.row) {
        
        if (lastTouchCellIndex != indexPath.row) {
            return 80;
        }
        else
        {
            return 150;
        }
        
    }
    else
    {
        return 80;
    }
}

- (void)getSoundInfo:(NSInteger)num
{
    NSInteger index = num;
    BgMusicItemModel * bmiModel = [myMusicArr objectAtIndex:index];
    NSString * songId = bmiModel.soundId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *parameters = @{@"method":@"baidu.ting.song.play",@"songid":songId};
    
    NSString *createURLString = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting"];
    
    //网络请求
    [HttpTool GET:createURLString parameters:parameters andJsessionid:nil success:^(id responseObject) {
        
        NSLog(@"--Success: %@", responseObject);
        songDic = (NSDictionary *)responseObject;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger status = [responseObject[@"error_code"]  integerValue];
        if (status == 22000) {
            NSDictionary * subSongDic = [responseObject objectForKey:@"bitrate"];
            songUrl = [subSongDic objectForKey:@"show_link"];
            [self playAudio];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num inSection:0];
            BgMusicItem * bmCell = (BgMusicItem *)[myTable cellForRowAtIndexPath:indexPath];
            [bmCell setUrl:songUrl andSongName:songId];
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"err is %@",error.description);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)playAudio
{
//    if (_audioPlayer == nil) {
//        _audioPlayer = [[AudioPlayer alloc] init];
//    }
//    
//    if ([_audioPlayer isProcessing]) {
//        [self stopAudio];
//    }
//    
//    _audioPlayer.url = [NSURL URLWithString:songUrl];
//    
//    [_audioPlayer play];
    
    [self resetStreamer];
}


- (void)cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
//        [_streamer removeObserver:self forKeyPath:@"status"];
//        [_streamer removeObserver:self forKeyPath:@"duration"];
//        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)resetStreamer
{
    [self cancelStreamer];
    
    Track *track = [[Track alloc] init];
    track.audioFileURL = [NSURL URLWithString:songUrl];
    
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
//    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
//    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
//    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    
    [_streamer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
       
    }
    else if (context == kDurationKVOKey) {
        
    }
    else if (context == kBufferingRatioKVOKey) {
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)stopAudio
{
//    [_audioPlayer stop];
    [self cancelStreamer];
}


- (void)buttonAction:(UIButton *)sender {
    
    NSString * title = sender.currentTitle;
    
    NSInteger num = sender.tag;
    BgMusicItemModel * bmiModel = [myMusicArr objectAtIndex:num];
    NSString * songId = bmiModel.soundId;
    
    if ([title isEqualToString:@"下载"]) {
        MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:songUrl];
        if (receipt.state == MCDownloadStateNone) {
            
            [self download:songId];
            
        }
    }
    else if ([title isEqualToString:@"确认使用"])
    {
        [self stopAudio];
        self.onSelectMusicName(songId);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)download:(NSString *)songId
{
    [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:songUrl] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        
    } completed:^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
        NSLog(@"==%@", error.description);
        [self saveMusicInfo:songId];
    }];
    
    
}

- (void)saveMusicInfo:(NSString *)songId
{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *cacheFolderPath = [cacheDir stringByAppendingPathComponent:@"localMusicInfo"];
    NSString * tmpSongName = [NSString stringWithFormat:@"%@.plist",songId];
    cacheFolderPath = [cacheFolderPath stringByAppendingPathComponent:tmpSongName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:cacheFolderPath])
    {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"localMusicInfo"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString * tmpSongName = [NSString stringWithFormat:@"%@.plist",songId];
        NSString *filePath = [directryPath stringByAppendingPathComponent:tmpSongName];
        NSLog(@"%@",filePath);
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSDictionary* dic = songDic; //写入数据
    BOOL flag = [dic writeToFile:cacheFolderPath atomically:YES];
    if (flag) {
        NSLog(@"写入成功");
    }
    else
    {
        NSLog(@"写入失败");
    }
}


-(NSString*)timeIntervalToMMSSFormat:(NSString *)interval{
    NSInteger ti =[interval integerValue];
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600) % 60;
    if (hours>=1) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
