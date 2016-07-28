//
// WXPhotoView.h
//
//  Created by liuwei on 15/9/15.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPhotoImageEdgeSize  40
#define kBackgroundColor [UIColor blackColor]

@interface UIView (viewController)
- (UIViewController *)viewController;
@end

@implementation UIView (viewController)

- (UIViewController *)viewController {
    
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}
@end

@class WXPhotoBrowser, WXPhoto, WXPhotoScrollView;

@protocol PhotoViewDelegate <NSObject>
@optional
- (void)photoViewWillZoomIn:(WXPhotoScrollView *)photoView;
- (void)photoViewDidZoomIn:(WXPhotoScrollView *)photoView;
- (void)photoViewWillZoomOut:(WXPhotoScrollView *)photoView;
- (void)photoViewDidZoomOut:(WXPhotoScrollView *)photoView;

@end

@interface WXPhotoScrollView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) WXPhoto *photo;
// 代理
@property (nonatomic, weak) id<PhotoViewDelegate> photoViewDelegate;
@end