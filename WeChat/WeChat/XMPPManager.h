//
//  XMPPManager.h
//  WeChat
//
//  Created by zhangzh on 16/7/23.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef void(^RegisterSuccessBlock)();
typedef void(^RegisterFailBlock)();

typedef void(^LogInSuccessBlock)();
typedef void(^LogInFailBlock)();

typedef void(^FriendsBlock)(NSMutableDictionary *dic);

@interface XMPPManager : NSObject<XMPPStreamDelegate>
{
    
    NSString *_userName;
    NSString *_passWord;
    
}
@property(nonatomic,strong)XMPPStream *stream;

+ (instancetype)shareManager;
//注册
- (void)registerWithUserName:(NSString *)uName passWord:(NSString*)pwd success:(RegisterSuccessBlock)sBlock faile:(RegisterFailBlock)fBlock;


//登陆
- (void)logInWithUserName:(NSString *)uName passWord:(NSString *)pwd success:(LogInSuccessBlock)sBlock faile:(LogInFailBlock)fBlock;
//注销
//发消息
- (void)sendMessage:(NSString *)msg toUser:(NSString *)jid;

//接收消息
//获取好友列表
- (void)fetchFriendsList:(FriendsBlock)friendsBlock;













@end
