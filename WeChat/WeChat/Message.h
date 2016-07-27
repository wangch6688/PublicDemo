//
//  Message.h
//  WeChat
//
//  Created by liuwei on 15/8/24.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>

//model:实体,存储数据  属性  方法
@interface Message : NSObject

@property (nonatomic,copy)NSString *content;//消息内容
@property (nonatomic,copy)NSString *icon; //用户头像

@property (nonatomic,assign)BOOL isSelf;  //是否是自己发送

@end
