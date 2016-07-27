//
//  ViewController.m
//  WeChat
//
//  Created by liuwei on 15/8/24.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "XMPPManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark ViewController life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //1.创建视图
    [self _createView];
    
    //2.加载数据
    [self _loadMessageData];

    //3.监听键盘弹出的通知
    //通知名定义在UIWindow类中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //滚动到最后一条
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:array.count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma  mark - 创建视图
- (void)_createView{
    
    //1.设置底部视图的背景颜色
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bottom_bar.png"]];
    
    //取消单元格分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //
    _tableView.showsVerticalScrollIndicator = NO;
    
    _textField.returnKeyType = UIReturnKeySend;
    
    _textField.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    

}

#pragma mark -加载数据
- (void)_loadMessageData{

    //读取plist文件
   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
   NSArray *messages = [NSArray arrayWithContentsOfFile:filePath];
    
    //创建可变数组,存储model
    array = [NSMutableArray array];
    
    for (NSDictionary *dic in messages) {
        
        //取出消息内容
        NSString *content = dic[@"content"];
        
        //用户头像
        NSString *icon = dic[@"icon"];
        
        //是否→自己发送
        BOOL isSelf = [dic[@"self"] boolValue];
        
        //将数据取出存储到model中,一个model对象存储一条聊天信息
        Message *m = [[Message alloc] init];
        m.content = content;
        m.isSelf = isSelf;
        m.icon = icon;
        
        [array addObject:m];
        
    }
}

#pragma mark -NSNotification
//键盘弹出时,会接收到通知,此方法会被调用
- (void)showKeyBoard:(NSNotification *)notification{

    NSLog(@"键盘将要显示");
    
    //1.获取键盘高度,键盘的相关信息存在userInfo中
    NSLog(@"%@",notification.userInfo);
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue *value = userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect frame = [value CGRectValue];
    
    CGFloat keyBoardHeight = frame.size.height;
    
    //移动底部黑色视图与表视图
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    _bottomView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight);
    _tableView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight);
    [UIView commitAnimations];
    
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return array.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *indenty = @"cell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    
    if (cell == nil) {
        
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenty];
        //颜色透明
        cell.backgroundColor = [UIColor clearColor];
        //取消单元格的点击效果
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    //取得对应的model
    Message *message = [array objectAtIndex:indexPath.row];
    //把model交给单元格
    cell.message = message;
    
    //当单元格返回时,会被添加到表视图上,系统会自动调用单元格的layoutSubViews方法
    return cell;
}

//单元格高度(动态返回单元格高度)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //计算文本的高度
    Message *m =  array[indexPath.row];
    
    NSString *content = m.content;
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(160, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 40;

}

//单元格被点击时,会调用此方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"单元格被点击了 %ld",indexPath.row);
    
    //收起键盘
    [_textField endEditing:YES];
//    [_textField resignFirstResponder];
    
    //移动底部黑色视图与表视图
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    _bottomView.transform = CGAffineTransformIdentity;
    _tableView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];

}

#pragma mark UITextFieldDelegate
//发送消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //点击return按钮时,相当于输入\n
    if (_textField.text.length == 0) {
        
        return NO;
    }
    //获取用户输入的内容
    NSString *text = _textField.text;
    
    //数组中增加元素
    Message *m = [[Message alloc] init];
    m.content = text;
    m.isSelf = YES;
    m.icon = @"icon01.jpg";
    
    [_tableView beginUpdates];
    
    //1.添加数据
    [array addObject:m];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:array.count - 1 inSection:0];
    
    
    //插入单元格
    
//    [_tableView reloadData];//重新走一遍所有的数据源方法
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    
  
    [_tableView endUpdates];
    
    //滚动到最后一个单元格
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    //用xmpp发送消息
    [[XMPPManager shareManager]sendMessage:text toUser:self.jid];
    

    //清空输入框
    _textField.text = nil;
    

    
    return YES;
}


#pragma mark -UITableView编辑模式
/**
 *
 *1.实现此协议方法后,单元格左滑会自动出现删除按钮
  2.点击删除,插入按钮时,会调用此方法
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //2.刷新,不带动画
//    [tableView reloadData];
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSLog(@"添加");
        
    }else if (editingStyle == UITableViewCellEditingStyleDelete){
   
    [tableView beginUpdates];
    //1.删除对应的数据
    [array removeObjectAtIndex:indexPath.row];
    //2.删除单元格
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
    }
    
}

//返回编辑的样式,默认都是删除按钮
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return UITableViewCellEditingStyleInsert;
    }else{
    
    
        return UITableViewCellEditingStyleDelete;
    }
    



}

//实现此协议方法后单元格可以移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    [array exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];

}


- (IBAction)doneAction:(id)sender {
    [_tableView setEditing:NO animated:YES];

}

- (IBAction)editAction:(id)sender {
    
    //是否支持多选
    //删除和添加按钮会被隐藏
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //进入编辑模式
    [_tableView setEditing:YES animated:YES];
}
@end
