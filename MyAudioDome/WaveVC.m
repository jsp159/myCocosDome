//
//  WaveVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 17/12/28.
//  Copyright © 2017年 qiding. All rights reserved.
//

#import "WaveVC.h"
#import <AVFoundation/AVFoundation.h>
#import "HWDrawView.h"

#import "JX_GCDTimerManager.h"

static NSString * const dbValueTimer = @"RecordFileimer";

static NSString * const playRecordTimer = @"PlayRecordTimer";

@interface WaveVC ()
{
    AVAudioRecorder * recorderValue;
    NSTimer * levelTimer;
    NSInteger index;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NSMutableArray *pointArray2;
@property (nonatomic, strong) HWDrawView *drawView;
@property (nonatomic, strong) HWDrawView *drawView2;
@property (nonatomic, weak) UIView *proView;
@property (nonatomic, weak) UIButton *startButton;

@property (nonatomic, strong) NSMutableArray *pointArray3;
@property (nonatomic, strong) NSMutableArray *pointArray4;

@end

@implementation WaveVC

- (NSMutableArray *)pointArray
{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (NSMutableArray *)pointArray2
{
    if (_pointArray2 == nil) {
        _pointArray2 = [NSMutableArray array];
    }
    return _pointArray2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    index = 0;
    
    //创建控件
    [self creatControl];
    
    _pointArray3 = [[NSMutableArray alloc] init];
    _pointArray4 = [[NSMutableArray alloc] init];
    
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0  */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [self getAudioInfo];
}

- (void)getAudioInfo
{
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [documentsFolders[0] stringByAppendingPathComponent:@"Recording0.m4a"];
    
    //取得音频数据
    NSURL *fileURL=[NSURL fileURLWithPath:filePath];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    
    NSLog(@"mp3Asset == %@",mp3Asset.description);
}


- (void)creatControl
{
    //动画视图
    HWDrawView *view = [[HWDrawView alloc] initWithFrame:CGRectMake(30, 150, [UIScreen mainScreen].bounds.size.width - 60, 80)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    self.drawView = view;
//    self.drawView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    HWDrawView *view2 = [[HWDrawView alloc] initWithFrame:CGRectMake(30, 230, [UIScreen mainScreen].bounds.size.width - 60, 80)];
    view2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view2];
    self.drawView2 = view2;
    self.drawView2.transform = CGAffineTransformMakeScale(1.0, -1.0);
//    self.drawView2.transform = CGAffineTransformMakeScale(-1.0, -1.0);
    
    UIView * view2Bg = [[UIView alloc] initWithFrame:view2.bounds];
    view2Bg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [view2 addSubview:view2Bg];
    
    //提示视图
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(30, 360, 20, 20)];
    proView.backgroundColor = [UIColor greenColor];
    proView.hidden = YES;
    proView.layer.cornerRadius = 10;
    proView.clipsToBounds = YES;
    [self.view addSubview:proView];
    self.proView = proView;
    
    //开始按钮
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60) * 0.5 - 60, 400, 60, 60)];
    startBtn.backgroundColor = [UIColor redColor];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    self.startButton = startBtn;
    
    //停止按钮
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60) * 0.5 + 60, 400, 60, 60)];
    stopBtn.backgroundColor = [UIColor redColor];
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    //停止按钮
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60) * 0.5 + 60 + 100, 400, 60, 60)];
    playBtn.backgroundColor = [UIColor redColor];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}

//- (void)startBtnOnClick
//{
//    self.startButton.enabled = NO;
//    self.proView.hidden = NO;
//    
//    for (int i = 0; i < 300; i++) {
//        CGPoint point = CGPointMake(self.drawView.bounds.size.height, arc4random_uniform(40) + 20);
//        //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
//        [self.pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
//        [self.pointArray2 insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
//    }
//    
//    
//    self.drawView.lineWidth = self.drawView.bounds.size.width/480;
//    self.drawView.pointArray = self.pointArray;
//    
//    //传值，重绘视图
//    self.drawView2.lineWidth = self.drawView.bounds.size.width/480;
//    self.drawView2.pointArray = self.pointArray2;
//}

- (void)startBtnOnClick
{
    self.startButton.enabled = NO;
    self.proView.hidden = NO;
    
    [self getAudioDbValue];
    
    //添加定时器
//    _timer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(addPoint) userInfo:nil repeats:YES];
//    //分流定时器
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)addPoint
{
    //随机点10～60
    CGPoint point = CGPointMake(self.drawView.bounds.size.height, arc4random_uniform(40) + 10);
    
    //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
    [self.pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
    
    //传值，重绘视图
    self.drawView.pointArray = self.pointArray;
    
    //随机点20～60
    CGPoint point2 = point;// CGPointMake(self.drawView2.bounds.size.height, arc4random_uniform(40) + 20);
    
    //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
    [self.pointArray2 insertObject:[NSValue valueWithCGPoint:point2] atIndex:0];
    
    //传值，重绘视图
    self.drawView2.pointArray = self.pointArray2;
}


- (void)stopBtnOnClick
{
    self.startButton.enabled = YES;
    self.proView.hidden = YES;
    
    //移除定时器
//    [self removeTimer];
    
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:dbValueTimer];
}

- (void)playBtnOnClick
{
    [_pointArray3 removeAllObjects];
    [_pointArray4 removeAllObjects];
    
    self.drawView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.drawView2.transform = CGAffineTransformMakeScale(-1.0, -1.0);
    
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:playRecordTimer
                                                           timeInterval:0.5
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf playTimeCallBack];
                                                                 }];
}

- (void)playTimeCallBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSValue * value = [self.pointArray objectAtIndex:index];
        
        
        //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
        [self.pointArray3 insertObject:value atIndex:0];
        [self.pointArray4 insertObject:value atIndex:0];
        
        self.drawView.pointArray = self.pointArray3;
        
        //传值，重绘视图
        self.drawView2.pointArray = self.pointArray4;
        
        index++;
        
        if (index >= self.pointArray.count) {
            index = 0;
            [self stopPlayBtnOnClick];
        }
    });
}

- (void)stopPlayBtnOnClick
{
    //移除定时器
    
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:playRecordTimer];
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 获取声音分贝
- (void)getAudioDbValue
{
    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    recorderValue = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorderValue)
    {
        [recorderValue prepareToRecord];
        recorderValue.meteringEnabled = YES;
        [recorderValue record];
        
        __weak typeof(self) weakSelf = self;
        [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:dbValueTimer
                                                               timeInterval:0.5
                                                                      queue:nil
                                                                    repeats:YES
                                                               actionOption:AbandonPreviousAction
                                                                     action:^{
                                                                         [weakSelf levelTimerCallback];
                                                                     }];
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
}

- (void)levelTimerCallback {
    [recorderValue updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorderValue averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * valueStr = [NSString stringWithFormat:@"%.0f", level*120];
        NSLog(@"valueStr  =============== %@",valueStr);
        CGPoint point = CGPointMake(self.drawView.bounds.size.height, [valueStr integerValue]);
        //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
        [self.pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
        [self.pointArray2 insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
        
        self.drawView.pointArray = self.pointArray;
    
        //传值，重绘视图
        self.drawView2.pointArray = self.pointArray2;
    });
}

@end
