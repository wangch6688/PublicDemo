//
//  PhotoCell.m
//  WXWeibo
//
//  Created by liuwei on 15/11/24.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import "WXPhotoCell.h"

@implementation WXPhotoCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _photoView = [[WXPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - kPhotoImageEdgeSize, CGRectGetHeight(self.frame))];
        [self.contentView addSubview:_photoView];
    }
    return self;
}

- (void)setPhoto:(WXPhoto *)photo{
    _photo = photo;
    _photoView.photo = _photo;
}
@end
