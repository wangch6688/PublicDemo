//
//  WXPhotoBrowser.h
//  02 CircleProgress
//
//  Created by liuwei on 15/9/15.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WXPhoto.h"
#import "WXPhotoCell.h"
#import "WXPhotoScrollView.h"
#import <UIKit/UIKit.h>

@protocol PhotoBrowerDelegate <NSObject>

//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser;

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser
             photoAtIndex:(NSUInteger)index;

@end

@interface WXPhotoBrowser
    : UIView <UIScrollViewDelegate, PhotoViewDelegate,
              UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// 所有的图片对象
@property(nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property(nonatomic, assign) NSUInteger currentPhotoIndex;

@property(nonatomic, assign) id<PhotoBrowerDelegate> delegate;

//显示
+ (void)showImageInView:(UIView *)view
       selectImageIndex:(NSInteger)index
               delegate:(id<PhotoBrowerDelegate>)delegate;
@end