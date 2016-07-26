//
//  ViewController.m
//  InBlockUseSelf
//
//  Created by wxhl on 16/7/26.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "ViewController.h"
#import "MTDataService.h"


@interface ViewController ()

@property (nonatomic ,copy)NSString * urlStr;
@property (nonatomic ,strong)NSArray * producrList;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //在block中调用对象时，block中会自动给对象进行一次retain，进行一次持有，这样会导致对象无法销毁，造成neicunxielu
    
    __weak __typeof(self)weakSelf = self;
    
    [MTDataService POSTWithURLString:self.urlStr params:nil headrFields:nil bodyData:nil complectionBlock:^(id data) {
        NSDictionary * dic = data[@"data"];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.producrList = dic[@"productList"];
        
    }];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
