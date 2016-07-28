//
//  CircleView.m
//  02 CircleProgress
//
//  Created by liuwei on 15/9/15.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WXCircleProgressView.h"
#define kWidth 40
#define kHeight 40

@implementation WXCircleProgressView

+ (instancetype)circleViewShowInView:(UIView *)view {
    
    CGFloat width = CGRectGetWidth(view.frame);
    CGFloat height = CGRectGetHeight(view.frame);
    CGFloat x = (width - kWidth ) /  2;
    CGFloat y = (height - kHeight ) /  2;
    if (height > kScreenHeight) {
        y = (kScreenHeight - kHeight) / 2;
    }
    WXCircleProgressView *circle = [[self alloc] initWithFrame:CGRectMake(x, y, kWidth, kHeight)];
    circle.backgroundColor = [UIColor clearColor];
    [view addSubview:circle];
    
    return circle;
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)hide {
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)setProgress:(CGFloat)progress{//0.5

    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    _circleBackgroundColor = _circleBackgroundColor ? : [UIColor colorWithWhite:0 alpha:.6];
    _circleLineColor = _circleLineColor ? : [UIColor whiteColor];
    //黑色背景
    CGFloat minWidth = rect.size.width < rect.size.height ?: rect.size.height;
    CGPoint center = CGPointMake(minWidth / 2,minWidth / 2 );
    CGFloat startAngle = -M_PI_2;
    UIBezierPath *backgroundCircle = [UIBezierPath bezierPathWithArcCenter:center radius:minWidth / 2 startAngle:startAngle endAngle:M_PI * 2 + startAngle clockwise:YES];
    [_circleBackgroundColor setFill];
    [backgroundCircle fill];
    
    //圆形进度条
    CGFloat endAngle = _progress * M_PI * 2 + startAngle;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:minWidth / 2 - 7 startAngle:startAngle endAngle:endAngle clockwise:YES];
    path.lineWidth = 3;
    path.lineCapStyle = kCGLineCapRound;
    [_circleLineColor setStroke];
    [path stroke];
}

@end
