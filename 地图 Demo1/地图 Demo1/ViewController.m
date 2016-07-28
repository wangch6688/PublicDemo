//
//  ViewController.m
//  地图 Demo1
//
//  Created by wxhl on 16/7/6.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager * manager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     iOS8.0之后想要访问定位服务,必须用户给定权限
     1.如果想要设置地图使用的权限: 一直访问(always) 试用期间访问(wheninUse) 不允许访问(默认是这个,不需要添加), 必须在 info.Plist 文件中进行设置
     NSLocationAlwaysUseDescription  一直访问
     NSLocationWhenInUseDescription  试用期间
     */
    
    
    //申请定位服务 : 需要引入一个框架
    //在这里防止 manager 被释放,所以将其设置为全局的
    
    
    //判断定位服务有没有打开
    if ([CLLocationManager locationServicesEnabled]) {
        
        NSLog(@"定位服务打开了");
    }else{
        
        NSLog(@"定位服务打开了");
    }
    
    
    
    //1.申请授权
    manager = [[CLLocationManager alloc]init];
    /*
     kCLAuthorizationStatusNotDetermined = 0,  用户没有作出判断是否决定定位
     
 
     kCLAuthorizationStatusRestricted,   系统拒绝定位
     
     
     kCLAuthorizationStatusDenied,   用户拒绝定位
     
     
     kCLAuthorizationStatusAuthorizedAlways  始终使用定位服务
     
    
     kCLAuthorizationStatusAuthorizedWhenInUse   使用期间
     */
    //先进行判断,在进行服务请求
    if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        //请求
        // [manager requestAlwaysAuthorization];//always
        [manager requestWhenInUseAuthorization]; //whenInUse

    }
    
       
    //2.发送定位的请求,开始定位
    [manager startUpdatingLocation];
    
    
    //3.设置代理,监听位置变化
    manager.delegate = self;
    
    
    
    
}

#pragma mark - 地图定位的代理实现
//实时更新当前的位置,一直调用
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{

//    NSLog(@"%@",locations);
    CLLocation *location=[locations lastObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"---------经度:%lf",coordinate.longitude);
    NSLog(@"纬度:%lf",coordinate.latitude);
    NSLog(@"海拔:%lf",location.altitude);
    NSLog(@"速度:%lf",location.speed);
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
