//
//  CircleView.h
//  02 CircleProgress
//
//  Created by liuwei on 15/9/15.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXCircleProgressView : UIView

//背景颜色
@property (nonatomic,strong)UIColor *circleBackgroundColor;

//进度条颜色
@property (nonatomic,strong)UIColor *circleLineColor;

//进度
@property (nonatomic,assign)CGFloat progress;

+ (instancetype)circleViewShowInView:(UIView *)view;

- (void)hide;

@end
