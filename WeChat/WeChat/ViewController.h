//
//  ViewController.h
//  WeChat
//
//  Created by liuwei on 15/8/24.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{


    NSMutableArray *array;

}
@property(nonatomic,copy)NSString *jid;
- (IBAction)doneAction:(id)sender;

- (IBAction)editAction:(id)sender;

@end

