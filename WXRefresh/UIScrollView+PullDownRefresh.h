//
//  UIScrollView+PullDownRefresh.h
//  PullRefresh
//
//  Created by Zheng on 14/10/20.
//  Copyright © 2014年 Qingwu Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AvailabilityMacros.h>

@class PullDownRefreshView;

@interface UIScrollView (PullDownRefresh)
typedef NS_ENUM(NSUInteger, PullDownRefreshPosition) {
  PullDownRefreshPositionTop = 0,
  PullDownRefreshPositionBottom,
};

- (void)addPullDownRefreshBlock:(void (^)(void))actionHandler;
- (void)addPullDownRefreshBlock:(void (^)(void))actionHandler
                                 position:(PullDownRefreshPosition)position;
- (void)triggerPullToRefresh;

@property(nonatomic, strong, readonly) PullDownRefreshView *pullToRefreshView;
@property(nonatomic, assign) BOOL showsPullToRefresh;

@end

typedef NS_ENUM(NSUInteger, PullDownRefreshState) {
  PullDownRefreshStateStopped = 0,
  PullDownRefreshStateTriggered,
  PullDownRefreshStateLoading,
  PullDownRefreshStateAll = 10
};

@interface PullDownRefreshView : UIView

@property(nonatomic, strong) UIColor *arrowColor;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong, readonly) UILabel *subtitleLabel;
@property(nonatomic, strong, readwrite)
    UIColor *activityIndicatorViewColor NS_AVAILABLE_IOS(5_0);
@property(nonatomic, readwrite)
    UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property(nonatomic, readonly) PullDownRefreshState state;
@property(nonatomic, readonly) PullDownRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(PullDownRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(PullDownRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(PullDownRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use setSubtitle:forState: instead
@property(nonatomic, strong, readonly) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property(nonatomic, strong) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property(nonatomic, strong)
    NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end