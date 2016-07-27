//
//  Manger.m
//  DelegateDemo
//
//  Created by wxhl on 16/7/23.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "Manger.h"



@implementation Manger


//GCD创建一个单例
static  Manger * instance = nil;

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        //    instance=[[self alloc]init];不需要复写allocWithZone时创建对象的方法
        
        instance=[[super allocWithZone:nil] init];//复写
    });
    
    
    return instance;
    
   
}










//如果使用初始化方法,让他成为一个单例
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    
    
    return  [self shareManager];
    
}







@end
