//
//  myGitHubTestVC.m
//  MyAudioDome
//
//  Created by jiangshiping on 2018/4/13.
//  Copyright © 2018年 qiding. All rights reserved.
//

#import "myGitHubTestVC.h"

@interface myGitHubTestVC ()

@end

@implementation myGitHubTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    [self createUI];
}

- (void)createUI
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    NSLog(@"this is test...");
    NSLog(@"this is test2...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
