//
//  MoreEffectVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/2/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "MoreEffectVC.h"
#import "AudioUnitFilterVC.h"
#import "BandpassFilterVC.h"
#import "DelayFilterVC.h"
#import "ReverbFilterVC.h"
#import "LimiterFilterVC.h"
#import "ExpanderFilterVC.h"
#import "VarispeedFilterVC.h"
#import "DistortionFilterVC.h"
#import "LowPassFilterVC.h"
#import "HighPassFilterVC.h"
#import "HighShelfFilterVC.h"
#import "LowShelfFilterVC.h"
#import "NewTimePitchFilterVC.h"
#import "ParametricEqFilterVC.h"
#import "PeakLimiterFilterVC.h"
#import "DynamicsProcessorFilterVC.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define px (SCREEN_HEIGHT / (2*667.0))

@interface MoreEffectVC ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTable;
    
    NSArray * musicArr;

    NSArray * effectArr;
}

@end

@implementation MoreEffectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    [self createUI];
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
    musicArr = [NSArray arrayWithObjects:@"01音效(AudioUnit)",@"02音效(Bandpass)",@"03音效(Delay)",@"04音效(Distortion)",@"05音效(DynamicsProcessor)",@"06音效(Expander)",@"07音效(HighPass)",@"08音效(HighShelf)",@"09音效(Limiter)",@"10音效(LowPass)",@"11音效(LowShelf)",@"12音效(NewTimePitch)",@"13音效(ParametricEq)",@"14音效(PeakLimiter)",@"15音效(Reverb)",@"16音效(Varispeed)", nil];
    
     effectArr = [NSArray arrayWithObjects:@"AudioUnitFilter",@"BandpassFilter",@"DelayFilter",@"DistortionFilter",@"DynamicsProcessorFilter",@"ExpanderFilter",@"HighPassFilter",@"HighShelfFilter",@"LimiterFilter",@"LowPassFilter",@"LowShelfFilter",@"NewTimePitchFilter",@"ParametricEqFilter",@"PeakLimiterFilter",@"ReverbFilter",@"VarispeedFilter", nil];
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
    
    NSString * musicName = [NSString stringWithFormat:@"%@ - %@",_soundName,[musicArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = musicName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger num = indexPath.row;
//    [self enterEffectVC:num];
    
    [self.subject sendNext:[NSString stringWithFormat:@"%li",(long)num]];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)enterEffectVC:(NSInteger )num
{
    if (num == 0) {
        self.hidesBottomBarWhenPushed = YES;
        AudioUnitFilterVC * aufVC = [[AudioUnitFilterVC alloc] init];
        aufVC.title = @"AudioUnit";
        [self.navigationController pushViewController:aufVC animated:YES];
    }
    else if (num == 1)
    {
        self.hidesBottomBarWhenPushed = YES;
        BandpassFilterVC * apfVC = [[BandpassFilterVC alloc] init];
        apfVC.title = @"Bandpass";
        [self.navigationController pushViewController:apfVC animated:YES];
    }
    else if (num == 2)
    {
        self.hidesBottomBarWhenPushed = YES;
        DelayFilterVC * dlfVC = [[DelayFilterVC alloc] init];
        dlfVC.title = @"Delay";
        [self.navigationController pushViewController:dlfVC animated:YES];
    }
    else if (num == 3)
    {
        self.hidesBottomBarWhenPushed = YES;
        DistortionFilterVC * dtfVC = [[DistortionFilterVC alloc] init];
        dtfVC.title = @"Distortion";
        [self.navigationController pushViewController:dtfVC animated:YES];
    }
    else if (num == 4)
    {
        self.hidesBottomBarWhenPushed = YES;
        DynamicsProcessorFilterVC * dpfVC = [[DynamicsProcessorFilterVC alloc] init];
        dpfVC.title = @"DynamicsProcessor";
        [self.navigationController pushViewController:dpfVC animated:YES];
    }
    else if (num == 5)
    {
        self.hidesBottomBarWhenPushed = YES;
        ExpanderFilterVC * edfVC = [[ExpanderFilterVC alloc] init];
        edfVC.title = @"Expander";
        [self.navigationController pushViewController:edfVC animated:YES];
    }
    else if (num == 6)
    {
        self.hidesBottomBarWhenPushed = YES;
        HighPassFilterVC * hpfVC = [[HighPassFilterVC alloc] init];
        hpfVC.title = @"HighPass";
        [self.navigationController pushViewController:hpfVC animated:YES];
    }
    else if (num == 7)
    {
        self.hidesBottomBarWhenPushed = YES;
        HighShelfFilterVC * hsfVC = [[HighShelfFilterVC alloc] init];
        hsfVC.title = @"HighShelf";
        [self.navigationController pushViewController:hsfVC animated:YES];
    }
    else if (num == 8)
    {
        self.hidesBottomBarWhenPushed = YES;
        LimiterFilterVC * ltfVC = [[LimiterFilterVC alloc] init];
        ltfVC.title = @"Limiter";
        [self.navigationController pushViewController:ltfVC animated:YES];
    }
    else if (num == 9)
    {
        self.hidesBottomBarWhenPushed = YES;
        LowPassFilterVC * lpfVC = [[LowPassFilterVC alloc] init];
        lpfVC.title = @"LowPass";
        [self.navigationController pushViewController:lpfVC animated:YES];
    }
    else if (num == 10)
    {
        self.hidesBottomBarWhenPushed = YES;
        LowShelfFilterVC * lsfVC = [[LowShelfFilterVC alloc] init];
        lsfVC.title = @"LowShelf";
        [self.navigationController pushViewController:lsfVC animated:YES];
    }
    else if (num == 11)
    {
        self.hidesBottomBarWhenPushed = YES;
        NewTimePitchFilterVC * ntfVC = [[NewTimePitchFilterVC alloc] init];
        ntfVC.title = @"NewTimePitch";
        [self.navigationController pushViewController:ntfVC animated:YES];
    }
    else if (num == 12)
    {
        self.hidesBottomBarWhenPushed = YES;
        ParametricEqFilterVC * ptfVC = [[ParametricEqFilterVC alloc] init];
        ptfVC.title = @"ParametricEq";
        [self.navigationController pushViewController:ptfVC animated:YES];
    }
    else if (num == 13)
    {
        self.hidesBottomBarWhenPushed = YES;
        PeakLimiterFilterVC * plfVC = [[PeakLimiterFilterVC alloc] init];
        plfVC.title = @"PeakLimiter";
        [self.navigationController pushViewController:plfVC animated:YES];
    }
    else if (num == 14)
    {
        self.hidesBottomBarWhenPushed = YES;
        ReverbFilterVC * refVC = [[ReverbFilterVC alloc] init];
        refVC.title = @"Reverb";
        [self.navigationController pushViewController:refVC animated:YES];
    }
    else if (num == 15)
    {
        self.hidesBottomBarWhenPushed = YES;
        VarispeedFilterVC * vsfVC = [[VarispeedFilterVC alloc] init];
        vsfVC.title = @"Varispeed";
        [self.navigationController pushViewController:vsfVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
