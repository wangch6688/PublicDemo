//
//  DCViewController.m
//  父子控制器
//
//  Created by 戴川 on 16/6/3.
//  Copyright © 2016年 戴川. All rights reserved.
//  总控制器


#define DCScreenW    [UIScreen mainScreen].bounds.size.width
#define DCScreenH    [UIScreen mainScreen].bounds.size.height


#import "DCViewController.h"
#import "DCNavTabBarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
@implementation DCViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    OneViewController *one = [[OneViewController alloc]init];
    one.title = @"我";
    TwoViewController *two = [[TwoViewController alloc]init];
    two.title = @"爱";
    ThreeViewController *three = [[ThreeViewController alloc]init];
    three.title = @"60";
    FourViewController *four = [[FourViewController alloc]init];
    four.title = @"期";
    FiveViewController *five = [[FiveViewController alloc]init];
    five.title = @"的";
    SixViewController *six = [[SixViewController alloc]init];
    six.title = @"你们";
    
    NSArray *subViewControllers = @[one,two,three,four,five,six];
    
    //调用被复写的 init 方法
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    
    tabBarVC.view.frame = CGRectMake(0, 64, DCScreenW, DCScreenH - 64);

    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
    
    self.title = @"总控制器";


}

@end
