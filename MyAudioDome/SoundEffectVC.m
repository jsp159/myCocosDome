//
//  SoundEffectVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "SoundEffectVC.h"
#import "MoreEffectVC.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define px (SCREEN_HEIGHT / (2*667.0))

@interface SoundEffectVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTable;
    
    NSArray * musicArr;
    
    NSMutableArray * myLocalMusicArr;
    
    NSMutableArray * myMusicArr;
}


@end

@implementation SoundEffectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    myLocalMusicArr = [[NSMutableArray alloc] init];
    myMusicArr = [[NSMutableArray alloc] init];
    
    [self initData];
    
    [self createUI];

    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSArray * arr = @[@1,@2,@3,@4];
//        [subscriber sendNext:@"wsx"];
        [subscriber sendNext:arr];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    
    RACDisposable * disposable = [signal subscribeNext:^(id  _Nullable x) {
        // block的调用时刻：只要信号内部发出数据就会调用这个block
        NSLog(@"======%@", x);
    }];
    
    [disposable dispose];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions.plist" ofType:nil];
//    NSArray * emArr = [NSArray arrayWithContentsOfFile:path];
//    [emArr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"%@", x);
//        
//    } error:^(NSError * _Nullable error) {
//        
//        NSLog(@"===error===");
//        
//    } completed:^{
//        NSLog(@"ok---完毕");
//    }];
    
//    for (NSString * str in emArr) {
//        NSLog(@"%@", str);
//    }
    
//    for (int i = 0; i < emArr.count; i++) {
//        NSLog(@"%@",emArr[i]);
//        if (i == emArr.count - 1) {
//            NSLog(@"ok---完毕");
//        }
//    }
    
    [self racCode];
}

- (void)racCode
{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求啦");
        [subscriber sendNext:@"jiang"];
        
        return nil;
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//
//        NSLog(@"XXXXXX === %@",x);
//    }];
//    
//    [signal subscribeNext:^(id  _Nullable x) {
//
//        NSLog(@"YYYYYYYY === %@",x);
//    }];
//    
//    [signal subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"ZZZZZZZ === %@",x);
//    }];
    
    RACMulticastConnection * connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"XXXXXX === %@",x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"YYYYYYYY === %@",x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"ZZZZZZZ === %@",x);
    }];
    
    [connection connect];
}

//- (void)racCode
//{
//    NSDictionary *dict = @{@"key":@[@"hello",@"world"], @"key2":@[@"shi",@"ping"]};
//    [dict.rac_sequence.signal subscribeNext:^(id x) {
////        NSLog(@"------11111 = %@", x);
////        NSString *key = x[0];
////        NSString *value = x[1];
//        // RACTupleUnpack宏：专门用来解析元组
//        // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
//        // 元组里面有几个值，宏的参数就必须填几个
//        RACTupleUnpack(NSString *key, id value) = x;
////        NSLog(@"%@ %@", key, value);
//        NSLog(@"key ====  %@", key);
//        
//        NSArray * tmpArr = value;
//        [tmpArr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//    
//            NSLog(@"%@", x);
//    
//        } error:^(NSError * _Nullable error) {
//    
//            NSLog(@"===error===");
//            
//        } completed:^{
//            NSLog(@"ok---完毕");
//        }];
//        
//    } error:^(NSError *error) {
//        NSLog(@"===error");
//    } completed:^{
//        NSLog(@"-----ok---完毕");
//    }];
//}

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
    musicArr = [NSArray arrayWithObjects:@"录音01",@"录音02",@"录音03",@"录音04",@"录音05",@"录音06", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return musicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier = @"cellItem";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * musicName = [musicArr objectAtIndex:indexPath.row];
    cell.textLabel.text = musicName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * musicName = [musicArr objectAtIndex:indexPath.row];
    MoreEffectVC * moreEffectVC = [[MoreEffectVC alloc] init];
    moreEffectVC.soundName = musicName;
    
    moreEffectVC.subject = [RACSubject subject];
    [moreEffectVC.subject subscribeNext:^(id x) {  // 这里的x便是sendNext发送过来的信号
        NSLog(@"%@", x);
    }];
    
    [self.navigationController pushViewController:moreEffectVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
