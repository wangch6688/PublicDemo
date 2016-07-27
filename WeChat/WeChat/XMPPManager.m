//
//  XMPPManager.m
//  WeChat
//
//  Created by zhangzh on 16/7/23.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "XMPPManager.h"
#import "UserModel.h"

//服务器的地址
#define kHostName @""

@interface XMPPManager  ()

{
    BOOL isRegister;
}
@property(nonatomic,copy)RegisterSuccessBlock registersBlock;
@property(nonatomic,copy)RegisterFailBlock registerfBlock;
@property(nonatomic,copy)LogInSuccessBlock logsBlock;
@property(nonatomic,copy)LogInFailBlock logfBlock;
@property(nonatomic,copy)FriendsBlock friendsBlock;
@end

@implementation XMPPManager



+ (instancetype)shareManager{
    
    static XMPPManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        instance = [[XMPPManager alloc]init];
        
        //调用配置xmpp的代码
        [instance setUpXMPP];
        
    });
    return instance;
    
}
//配置xmpp
- (void)setUpXMPP{
    
    
    _stream = [[XMPPStream alloc]init];
    //2.配置服务器
    //(1)服务器IP地址
    [_stream setHostName:kHostName];
    //(2)配置服务器端口
    [_stream setHostPort:5222];
    
    
    //设置代理,用于监听服务器的一系列事件
    
    [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    
}

//链接服务器
- (void)connect{
    
    //设置账户//
    NSString *account = [NSString stringWithFormat:@"%@@wxhl",_userName];
    //1.使用XMPPStream  用于连接服务器
    
    XMPPJID *jid = [XMPPJID jidWithString:account];
    
    [_stream setMyJID:jid];
    
    
    
    //重点此行代码必须写到最后面链接服务器
    [_stream connectWithTimeout:-1 error:nil];
    
    
}
//链接服务器(注册)
- (void)registerWithUserName:(NSString *)uName passWord:(NSString*)pwd success:(RegisterSuccessBlock)sBlock faile:(RegisterFailBlock)fBlock{
    
    
    isRegister = YES;
    //存储传递过来的账号和密码
    _userName = uName;
    _passWord = pwd;
    
    _registersBlock = sBlock;
    _registerfBlock = fBlock;
    
  
    
    
    //链接服务器
    [self connect];

    
    
    
}
//链接服务器(登陆)
- (void)logInWithUserName:(NSString *)uName passWord:(NSString *)pwd success:(LogInSuccessBlock)sBlock faile:(LogInFailBlock)fBlock{
    isRegister = NO;
    //存储传递过来的账号和密码
    _userName = uName;
    _passWord = pwd;

    //存储一下block
    _logsBlock = sBlock;
    _logfBlock = fBlock;
    
    
    //链接服务器
    [self connect];
}

//链接成功的代理方法里面注册
#pragma mark ------------_streamDelagate

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSLog(@"链接成功");
    
    if (isRegister) {
        
        //注册
        [_stream registerWithPassword:_passWord error:nil];
        
    }else{
        //登陆
        [_stream authenticateWithPassword:_passWord error:nil];
        
    }
    
    //获取好友列表(xml)
  
}


//注册成功调用的代理方法
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    
    NSLog(@"注册成功");
    
    //如果注册成功需要断开链接
    [_stream disconnect];
    
    //回调成功的block
    
    _registersBlock();
    
    
}
//注册失败调用的方法
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
    
    
    [_stream disconnect];
    
    //回调失败的block
    _registerfBlock();
    
    
}


//登陆成功调用的代理方法

//登陆成功后调用的代理方法

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    
    NSLog(@"登陆成功");
    
    self.logsBlock();
    
    //告诉服务器登陆成功了 (向服务器发送状态)
    XMPPPresence *presence = [[XMPPPresence alloc]initWithType:@"available"];
    //元素
    [_stream sendElement:presence];
    
    //关闭和服务器的链接
//    [_stream disconnect];

}

//登陆失败调用的代理方法


- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    
    //回调登陆失败的blcok
    self.logfBlock();
    
    //关闭和服务器的链接
    [_stream disconnect];
    
}
/*
 XML格式：
 <iq from='tom@wxhl' type='get' id='123456'>
 
      <query xmlns='jabber:iq:roster'/>
 
 </iq>
 
 type 属性，说明了该 iq 的类型为 get，与 HTTP 类似，向服务器端请求信息
 from 属性，消息来源，这里是你的 JID
 to 属性，消息目标，这里是服务器域名
 id 属性，标记该请求 ID，当服务器处理完毕请求 get 类型的 iq 后，响应的 result 类型 iq 的 ID 与 请求 iq 的 ID 相同
 <query xmlns="jabber:iq:roster"/> 子标签，说明了客户端需要查询 roster
 */
//获取好友列表
- (void)fetchFriendsList:(FriendsBlock)friendsBlock{
    //1.向服务器请求好友列表
    
    DDXMLElement *iq = [DDXMLElement elementWithName:@"iq"];
    
    //添加属性
    [iq addAttributeWithName:@"from" stringValue:_stream.myJID.description];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    
    [iq addAttributeWithName:@"id" stringValue:@"123456"];
    
    DDXMLElement *query = [DDXMLElement elementWithName:@"query"];
    
    [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:roster"];
    
    [iq addChild:query];
    
    //发送给服务器
    
    [_stream sendElement:iq];
    
    
    _friendsBlock = friendsBlock;
    

    
    
    
}

//服务器返好友列表调用的方法
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    
    NSLog(@"%@",iq);
    //包装成字典
    
    //需要将服务器的数据整理到以下格式
    /*
     @"联系人列表1(456)"
       zzh123
     ::haha
       zzh456
     @联系人列表2(123)
       zzh111
       zzh222
    
    */
    /*
    <iq xmlns="jabber:client" type="result" id="123456" to="lw123@wxhl/63u0lfrtlf">
     <query xmlns="jabber:iq:roster">
     <item jid="zzh158512012@218.241.181.202" name="" ask="subscribe" subscription="none">
           <group>456</group>
     </item>
     <item jid="zhangzh158@218.241.181.202" name="" ask="subscribe" subscription="none">
        <group>456</group>
     </item>
     <item jid="zzh158512@218.241.181.202" name="" ask="subscribe" subscription="none">
         <group>456</group>
     </item>
     </query>
   
     </iq>
    
    */
    
    
    //创建一个存储好友列表的字典
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    //取出query标签
     DDXMLElement *query= iq.childElement;
    
    
    for (NSXMLElement *item in query.children) {
        //根据属性的名字取出属性值
         NSString *jid = [item attributeStringValueForName:@"jid"];
        //好友昵称
         NSString *name = [item attributeStringValueForName:@"name"];
        
        //保存好友的信息
        UserModel *user = [[UserModel alloc]init];
        
        user.name = name;
        user.jid = jid;
        
        for (DDXMLElement *group in item.children) {
            
            //取得分组名
             NSString *groupName= group.stringValue;
            //构造字典的value(因为一个分组可能会有多个好友,所以需要数组包装)
             NSMutableArray *users = [mdic objectForKey:group];
            
            if (users ==nil) {
                
                users = [NSMutableArray array];
                
                //设置mdic
                [mdic setObject:users forKey:groupName];
            }
            
            //将好友添加到数组里面
            [users addObject:user];
            
           
            
            
        }
       
    }
    
    //传递mdic调用block
    _friendsBlock(mdic);
    
   
    
    
    return YES;
}

//发消息

//发消息
/*
 <message to='huangrong@wxhl' from='guojing@wxhl' type='chat' xml:lang='en'>
       <body>蛋定</body>
 </message>
 */
- (void)sendMessage:(NSString *)msg toUser:(NSString *)jid{
    
    
    DDXMLElement *message = [DDXMLElement elementWithName:@"message"];
    
    [message addAttributeWithName:@"to" stringValue:jid];
    
    [message addAttributeWithName:@"from" stringValue:_stream.myJID.description];
    
    [message addAttributeWithName:@"type"stringValue:@"chat"];
    
    [message addAttributeWithName:@"xml:lang" stringValue:@"en"];
    
    DDXMLElement *body = [DDXMLElement elementWithName:@"body" stringValue:msg];
    
    [message addChild:body];
    
    //告诉服务器发送消息
    
    [_stream sendElement:message];
    
    
    
}





@end
