//
//  ViewController.m
//  CalendarTable
//
//  Created by wxhl on 16/7/29.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self _loadData];
    
    
    
    
}


- (void)_loadData{
    
    
    
    
    
    
}



#pragma mark - 日期的获取
//今天是哪一天
-(NSInteger)day:(NSDate * )date{
    
    NSDateComponents * compoents = [[NSCalendar currentCalendar]components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay) fromDate:date];
    
    return [compoents day];
}

//本月是一年中的第几个月
-(NSInteger)month:(NSDate * )date{
    
    NSDateComponents * compoents = [[NSCalendar currentCalendar]components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay) fromDate:date];
    
    return [compoents month];
}

//今年是什么年份
-(NSInteger)year:(NSDate * )date{
    
    NSDateComponents * compoents = [[NSCalendar currentCalendar]components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay) fromDate:date];
    
    return [compoents year];
}

//这个月总共多少天
-(NSInteger)lenth:(NSDate * )date{
    
//    NSDateComponents * compoents = [[NSCalendar currentCalendar]components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay) fromDate:date];
    
    //获取每个月的天数范围
    NSRange daysInLastMonth = [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSInteger days = daysInLastMonth.length;
    
    
    return days;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    
    
    
}

@end
