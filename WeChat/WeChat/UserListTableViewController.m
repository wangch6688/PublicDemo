//
//  UserListTableViewController.m
//  WeChat
//
//  Created by zhangzh on 16/7/23.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "UserListTableViewController.h"
#import "XMPPManager.h"
#import "UserModel.h"
#import "ViewController.h"

@interface UserListTableViewController ()
@property(nonatomic,strong)NSMutableDictionary *friendsDic;
@end

@implementation UserListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取好友列表数据
    [[XMPPManager shareManager]fetchFriendsList:^(NSMutableDictionary *dic) {
        
        NSLog(@"%@",dic);
        //存储数据,下方数据源方法会用到字典
        _friendsDic = dic;
        
        
        [self.tableView reloadData];
        
    }];




}



//点击注销调用的方法
- (IBAction)logOut:(id)sender {
    //反转到logIn界面
    UIViewController *VC=  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    //改变根视图控制器
    self.view.window.rootViewController = VC;
    
    //添加一个反转动画
    
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:NULL];
    
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.friendsDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   //取出所有的key
     NSArray *groups = [self.friendsDic allKeys];
    
     NSString *groupName= groups[section];
    
     NSArray *users= self.friendsDic[groupName];
    
    
    
    return users.count;
}

//创建单元格调用的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell01" forIndexPath:indexPath];
    //取得所有的key
     NSArray *groups = [self.friendsDic allKeys];
    
    //取出分组名
    NSString *group = groups[indexPath.section];
    
    //取出对应的数组
    NSArray *users = self.friendsDic[group];
    
     UserModel *model= users[indexPath.row];
    
    
    
    
    //titel 和subtitle赋值
    
    cell.textLabel.text = model.jid;
    
    cell.detailTextLabel.text = model.name;
    
    cell.imageView.image = [UIImage imageNamed:@"icon02.jpg"];
    
   
    
    return cell;
}
//选中单元格.push到下一个界面,将jid传递过去
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //获取好友的jid传递过去
     NSArray *groups = [self.friendsDic allKeys];
    //取得分组名
     NSString *groupName = groups[indexPath.section];
    
    NSArray *users = self.friendsDic[groupName];

    UserModel *user =  users[indexPath.row];
    
    
     ViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vc007"];
    
     VC.jid = user.jid;
   
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
}

@end
