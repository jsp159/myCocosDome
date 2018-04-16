//
//  RACOtherVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/12.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "RACOtherVC.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>

@interface RACOtherVC ()


@property(nonatomic,strong)NSString * currentNum;

@end

@implementation RACOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _currentNum = [NSString stringWithFormat:@"1"];
    
    RAC(self.numLabel,text) = RACObserve(self, currentNum);
    
    [[_addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSInteger num = [_currentNum integerValue] + 1;
        NSLog(@"current num ======= %li",(long)num);
        _currentNum = [NSString stringWithFormat:@"%ld",(long)num];
        _numLabel.text = _currentNum;
    }];

    [[_subBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSInteger num = [_currentNum integerValue] - 1;
        NSLog(@"current num ======= %li",(long)num);
        _currentNum = [NSString stringWithFormat:@"%ld",(long)num];
        _numLabel.text = _currentNum;
    }];
    
    RACSubject * subject = [RACSubject subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onChange:(UISwitch *)sender {
    
    NSLog(@"change");
}

- (IBAction)onAddNum:(UIButton *)sender {
}
@end
