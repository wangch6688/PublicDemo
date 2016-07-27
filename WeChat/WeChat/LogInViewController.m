//
//  LogInViewController.m
//  WeChat
//
//  Created by zhangzh on 16/7/23.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "LogInViewController.h"
#import "XMPPManager.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
//跳转到好友界面
- (IBAction)logInAction:(id)sender {
    
    
    [[XMPPManager shareManager]logInWithUserName:@"lw123" passWord:@"123" success:^{
        
        //取出导航控制器
        
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb001"];
        //改变根视图控制器
        self.view.window.rootViewController = nav;
        
        //添加一个反转动画
        
        [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:.3 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:NULL];

    } faile:^{
        NSLog(@"失败");
    }];
    
    //请求好友列表的数据(链接服务器)
    
 
    
    
    
    
    
   
   
    
    
    
    
    
    
}



@end
