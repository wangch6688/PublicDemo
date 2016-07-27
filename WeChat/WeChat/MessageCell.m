//
//  MessageCell.m
//  WeChat
//
//  Created by liuwei on 15/8/24.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *userImgView;
@property(nonatomic,strong)UIImageView *bgImgView;

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //创建子视图

        //1.消息label
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
        
        //2.头像视图
        _userImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        //3.气泡视图
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        //此时还没数据
        /* 错误
        NSLog(@"%@",_message);
        contentLabel.text = _message.content;
        */
        [self.contentView addSubview:_userImgView];
        [self.contentView addSubview:_bgImgView];
        [self.contentView addSubview:_contentLabel];
        
    }

    return self;

}


//重写set方法,监听数据的传入
- (void)setMessage:(Message *)message{

    _message = message;
    
//    [self layoutSubviews]; 错误,不要直接调用
    
//    [self setNeedsLayout]; //告诉系统抽空调用layoutSubviews
}


//布局子视图
/**
 *  1.布局子视图
    2.填充数据
 
    此方法,不要直接调用,系统会自动调用
    当视图被添加时会被调用

 */
- (void)layoutSubviews{
    
    
    [super layoutSubviews];//一定要调用父类的方法
    
    //1.聊天信息lable
    //根据聊天内容计算文本需要的高度
    NSString *content = _message.content;
    
    CGSize size =[content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(160, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    _contentLabel.frame = CGRectMake(70, 20, size.width, size.height);
    _contentLabel.text = content;
    
    //自己
    UIImage *img1 = [UIImage imageNamed:@"chatto_bg_normal.png"];
    //别人
    UIImage *img2 = [UIImage imageNamed:@"chatfrom_bg_normal.png"];

    //2.聊天气泡
    UIImage *bgImg = _message.isSelf ? img1 : img2;
    
    //拉伸气泡图片
    bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width * .5 topCapHeight:bgImg.size.height * .7];
    _bgImgView.image = bgImg;
    _bgImgView.frame = CGRectMake(50, 10, 200, size.height + 20);
    
    //3.用户头像
    if (_message.isSelf) { //是自己发的
        
        _userImgView.frame = CGRectMake(320 - 50, 0, 50, 50);
        
    }else{
        _userImgView.frame = CGRectMake(0, 0, 50, 50);
    }
    
    _userImgView.image = [UIImage imageNamed:_message.icon];

}

@end
