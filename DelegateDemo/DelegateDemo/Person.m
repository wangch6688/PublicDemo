//
//  Person.m
//  DelegateDemo
//
//  Created by wxhl on 16/7/27.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "Person.h"

@implementation Person

static Person * instance = nil;

+(instancetype)sharePerson{
    
    if (instance == nil) {
    
        instance = [[self allocWithZone:NULL]init];
    }
    
    return instance;
    
}






@end
