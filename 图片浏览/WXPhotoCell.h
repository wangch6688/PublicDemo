//
//  PhotoCell.h
//  WXWeibo
//
//  Created by liuwei on 15/11/24.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPhoto.h"
#import "WXPhotoScrollView.h"

@interface WXPhotoCell : UICollectionViewCell

@property (nonatomic,strong)WXPhotoScrollView *photoView;

@property(nonatomic,strong)WXPhoto *photo;
@end
