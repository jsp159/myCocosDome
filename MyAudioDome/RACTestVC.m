//
//  RACTestVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/9.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "RACTestVC.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>

#import "RequestViewModel.h"
#import "RequestModel.h"

#import "RACOtherVC.h"

@interface RACTestVC ()<UITextFieldDelegate>
{
    RACCommand * command;
    
}

// 请求视图模型
@property(nonatomic, strong)RequestViewModel *requestVM;

@property(nonatomic,strong)NSString * myName;

@end

@implementation RACTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myName = [NSString stringWithFormat:@"jiang"];
    
//    [self racTestCode];
    
//    [self racTestCode2];
    
//    [self racTestCode3];
    
    _inputTF.delegate = self;
    
//    [self racTestCode4];
    
//    [self racTestCode5];
    
    [self racTestCode6];
    
    [self racTestCode7];
}

- (void)racTestCode7
{
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@11111];
        return nil;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@22222];
        return nil;
    }];
    
//    RACSignal * mSignal = [signalA merge:signalB];
    RACSignal * mSignal = [signalA zipWith:signalB];
    
    [mSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"merge =============== %@",x);
    }];

}

- (void)racTestCode6
{
//    [[_otherTF.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
//        
//        return [RACSignal return:[NSString stringWithFormat:@"hi,%@",value]];
//        
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"out =============== %@",x);
//    }];
//    
//    [[_inputTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return [NSString stringWithFormat:@"hi2,%@",value];
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"out2 =============== %@",x);
//    }];
//    
//    [RACObserve(self, myName) subscribeNext:^(id  _Nullable x) {
//        NSLog(@"myName =============== %@",x);
//    }];
    
    RAC(self.sendBtn,enabled) = [RACSignal combineLatest:@[self.inputTF.rac_textSignal,self.otherTF.rac_textSignal] reduce:^(NSString *username, NSString *password){

        return @(username.length > 0 && password.length >= 6);
    }];
    
    RAC(self.other,enabled) = [RACSignal combineLatest:@[self.otherTF.rac_textSignal] reduce:^(NSString *password){
        return @(password.length >= 6);
    }];
    
    RAC(self.other,backgroundColor) = [RACSignal combineLatest:@[self.otherTF.rac_textSignal] reduce:^(NSString *password){
        if (password.length >= 6) {
            return [UIColor redColor];
        }
        else
        {
            return [UIColor clearColor];
        }
    }];
    
    
    
    
    command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:[NSString stringWithFormat:@"发送登录的数据%@",input]];
            [subscriber sendCompleted]; // 一定要记得写
            return nil;
        }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"out ============ %@", x);
    }];
    
    // 监听命令执行过程
    [[command.executing skip:1] subscribeNext:^(id x) { // 跳过第一步（没有执行这步）
        if ([x boolValue] == YES) {
            NSLog(@"--正在执行");
            // 显示蒙版
        }else { //执行完成
            NSLog(@"执行完成");
            // 取消蒙版
        }
    }];
    
    // 监听登录按钮点击
    [[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"btn ============ %@", x);
        NSLog(@"点击登录按钮");
        UIButton * tmpBtn = x;
        NSInteger tag = tmpBtn.tag - 100;
        // 处理登录事件
        [command execute:@(tag)];
        
    }];
    
     [[self.other rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
         UIButton * tmpBtn = x;
         NSInteger tag = tmpBtn.tag - 100;
         // 处理登录事件
         [command execute:@(tag)];
     }];
}

- (void)racTestCode5
{
//    _requestVM = [[RequestViewModel alloc] init];
//    
//    // 发送请求
//    RACSignal *signal = [self.requestVM.requestCommand execute:nil];
//    [signal subscribeNext:^(id x) {
////        NSLog(@"%@",x);
//        for (RequestModel * model in x) {
//            NSLog(@"isbn10 ============= %@",model.isbn10);
//            NSLog(@"isbn13 ============= %@",model.isbn13);
//            NSLog(@"title ============= %@",model.title);
//            NSLog(@"image ============ %@",model.image);
//            NSLog(@"alt =========== %@",model.alt);
//        }
//    }];
    
    RAC(self.sendBtn,enabled) = [RACSignal combineLatest:@[self.inputTF.rac_textSignal,self.otherTF.rac_textSignal] reduce:^(NSString *username, NSString *password){
//        NSLog(@"username ====== %@",username);
//        NSLog(@"password ====== %@",password);
        return @(username.length > 0 && password.length >= 6);
//        return @([self checkTel:username] && password.length >= 6);
    }];
    
    [[self.otherTF.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal*(id value,BOOL *stop){
            // 做好处理，通过信号返回出去.
            // 需要引入头文件 #import <ReactiveObjC/RACReturnSignal.h>
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:[NSString stringWithFormat:@"hello: %@",value]];
                return nil;
            }];
            
//            return [RACSignal return:[NSString stringWithFormat:@"hello: %@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"out =============== %@",x);
    }];
    
    command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal return:[NSString stringWithFormat:@"hello"]];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"output2 =============== %@",x);
    }];
    
    [command execute:@5555555];
    
    RACSignal * loginSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //进入操作code
        
        return nil;
    }];
    
    [loginSignal subscribeNext:^(id  _Nullable x) {
        
    }];
}

- (void)racTestCode4
{
//    RAC(self.otherTF,text) = self.inputTF.rac_textSignal;
//    RAC(self.inputTF,text) = self.otherTF.rac_textSignal;
    
//    RAC(self.sendBtn,enabled) = self.inputTF.rac_textSignal;
    
//    [_inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSString * str = x;
//        if (str.length >= 6) {
//            self.sendBtn.enabled = YES;
//        }
//        else
//        {
//            self.sendBtn.enabled = NO;
//        }
//    }];
    
//    RAC(self.inputTF, text) = self.otherTF.rac_textSignal;
//    [RACObserve(self.inputTF, text) subscribeNext:^(id x) {
//        NSLog(@"====label的文字变了======= %@",x);
//    }];
    
    
    [[self.otherTF.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 6;
    }] subscribeNext:^(NSString * _Nullable x) {
        self.sendBtn.enabled = YES;
    }];
    
}

- (void)racTestCode3
{
    command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"input ====== %@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
    
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"recivce data ========== %@",x);
    }];
    
}

//- (void)racTestCode2
//{
////    RACSubject * signalofsignals = [RACSubject subject];
////    
////    [signalofsignals subscribeNext:^(id  _Nullable x) {
////        NSLog(@"receive data =======  %@",x);
////    }];
////    
////    [signalofsignals sendNext:@333333];
//    
//    RACSubject * signalofsignals = [RACSubject subject];
//    RACSubject * signalA         = [RACSubject subject];
//    RACSubject * signalB         = [RACSubject subject];
//
//    [signalofsignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"receive data =======  %@",x);
//    }];
//
//    [signalofsignals sendNext:signalA];
//    [signalA sendNext:@"22222"];
//    
//    [signalofsignals sendNext:signalB];
//    [signalB sendNext:@333333];
//    
//}

- (void)racTestCode
{
    // 一般做法
    // 1.创建命令
    command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"input ====== %@",input); // input 为执行命令传进来的参数
        NSString * outputStr = nil;
        if ([input integerValue] == 1) {
            outputStr = @"产出的数据为1.";
        }
        else if ([input integerValue] == 2)
        {
            outputStr = @"产出的数据为2.";
        }
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //把处理的结果发送出去
            NSLog(@"把处理的结果发送出去");
            [subscriber sendNext:outputStr];
            return nil;
        }];
    }];
    
    // 方式二：
    // 订阅信号
    // 注意：这里必须是先订阅才能发送命令
    // executionSignals：信号源，信号中信号，signalofsignals:信号，发送数据就是信号
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"xxx =====  %@", x);
        }];
        //        NSLog(@"%@", x);
    }];
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"xxxxx2222 ====== %@",x);
        }];
    }];

    //高级做法，信号中信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"xxxxx3333 ====== %@",x);
    }];
    
    // 2.执行命令
    //[command execute:@1];
}

- (IBAction)onSend:(UIButton *)sender {
    
//    [command execute:_inputTF.text];
    _myName = @"jiangshiping";
}


#pragma mark - textfiled delegate
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


#pragma mark -- 检测手机号码的正确性
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^1[3|4|9|5|7|8][0-9]\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
        
        return NO;
        
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onOther:(UIButton *)sender {
    
    RACOtherVC * racOtherVC = [[RACOtherVC alloc] init];
    [self.navigationController pushViewController:racOtherVC animated:YES];
    
    [[racOtherVC rac_signalForSelector:@selector(onChange:)] subscribeNext:^(RACTuple * _Nullable x) {
        UISwitch * sw = (UISwitch *)x[0];
        _oneLabel.text = sw.on ? @"ON" : @"OFF";
    }];
}
@end
