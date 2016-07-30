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
//这个月总共多少天
-(NSInteger)lenth:(NSDate * )date{
    
    //    NSDateComponents * compoents = [[NSCalendar currentCalendar]components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay) fromDate:date];
    
    //获取每个月的天数范围
    NSRange daysInLastMonth = [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSInteger days = daysInLastMonth.length;
    
    
    return days;
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


//这个月的第一天是周几
- (NSInteger)firstWeekDayInThisMonth:(NSDate *)date{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;

    
    
}


//今天是哪一天
-(NSInteger)day:(NSDate * )date{
    
    NSDateComponents * compoents = [[NSCalendar currentCalendar]components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay) fromDate:date];
    
    return [compoents day];
}


//上个月的的时间
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下一个月的时间
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    
    
    
}

@end
