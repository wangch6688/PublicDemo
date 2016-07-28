//
//  WXPhotoView.m
//
//  Created by liuwei on 15/9/15.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WXPhotoScrollView.h"
#import "WXPhoto.h"
#import "UIImageView+WebCache.h"
#import "WXCircleProgressView.h"


@interface WXPhotoScrollView ()
{
    UIImageView *_imageView;
    WXCircleProgressView *_progressView;
}
@end

@implementation WXPhotoScrollView
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
		[self addSubview:_imageView];
        
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        
        //单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self addGestureRecognizer:singleTap];
        
        //双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImgView)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];

    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(WXPhoto *)photo {
    _photo = photo;
    
    //显示图片
    [self showImage];
}

#pragma mark 显示大图
- (void)showImage
{
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewWillZoomIn:)]) {
        
        [self.photoViewDelegate photoViewWillZoomIn:self];
    }
    //清空原图
    _photo.srcImageView.image = nil;
    
    //转换坐标
    _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
    _imageView.image = _photo.placeholder; // 占位图片

    //调整frame参数
    CGRect imageFrame = [self adjustFrameWithImageSize:_photo.placeholder.size];
    
    //如果是被点击的图片才有放大的动画
    CGFloat duration = _photo.isSelectImg ? .3 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.backgroundColor = kBackgroundColor;
        _imageView.frame = imageFrame;
        
    } completion:^(BOOL finished) {
        
        //通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidZoomIn:)] && _photo.isSelectImg) {
            [self.photoViewDelegate photoViewDidZoomIn:self];
        }
        //下载大图
        [self loadLargeImage];
        
    }];

}
- (void)loadLargeImage{

    _photo.isSelectImg = NO;
    
    // 设置原图
    _photo.srcImageView.image = _photo.placeholder;
    
    //如果图片没有下载过,显示进度条
    if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_photo.url.absoluteString]) {
        //进度视图
        _progressView = [WXCircleProgressView circleViewShowInView:_imageView];
    }
    
    [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        _progressView.progress = (double)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //隐藏进度条
        [_progressView hide];
    }];
}

#pragma mark 调整frame
- (CGRect)adjustFrameWithImageSize:(CGSize)imgSize;
{
	if (_imageView.image == nil) return CGRectZero;
    UIImage *image = self.photo.placeholder;
    CGFloat height = kScreenWidth / image.size.width * image.size.height;
    
    CGFloat y = (kScreenHeight - height)/2;
    //判断图片高度是否大于屏幕.
    if (height >= kScreenHeight) {
        y = 0;
    }
    self.contentSize = CGSizeMake(kScreenWidth, height);
    CGRect imageFrame = (CGRect){0,y,kScreenWidth,height};
    return imageFrame;
 
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}
//以中心点缩放
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - 单击手势
- (void)singleTap {
    [self hide];
}
- (void)hide
{
    // 通知代理
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewWillZoomOut:)]) {
        [self.photoViewDelegate photoViewWillZoomOut:self];
    }
    //隐藏进度条
    [_progressView hide];
    
    /*
    CGFloat duration = 0.15;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([_photo.srcImageView clipsToBounds]) {
            _imageView.image = _photo.capture;
        }
    });
    */
    self.zoomScale = 1;
    [UIView animateWithDuration:0.2 animations:^{
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        self.backgroundColor = [UIColor clearColor];

    } completion:^(BOOL finished) {
        // 设置底部的小图片
        _photo.srcImageView.image = _photo.placeholder;
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector( photoViewDidZoomOut:)]) {
            [self.photoViewDelegate photoViewDidZoomOut:self];
        }
    }];
}

#pragma mark 双击手势
-(void)scaleImgView
{
    float scale = self.zoomScale > 1 ? 1.0 : 3.0;
    [self setZoomScale:scale animated:YES];
}

#pragma mark 长按手势
- (void)longPress:(UILongPressGestureRecognizer *)longPress{

    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActivityViewController *ctrl = [[UIActivityViewController alloc] initWithActivityItems:@[_imageView.image] applicationActivities:nil];
        [self.viewController presentViewController:ctrl animated:YES completion:NULL];

        //回调
        ctrl.completionHandler = ^(NSString *activityType, BOOL completed) {
            if ([activityType isEqualToString:UIActivityTypeSaveToCameraRoll] && completed) {
                NSLog(@"保存图片成功");
            }
        };
    }
}

@end