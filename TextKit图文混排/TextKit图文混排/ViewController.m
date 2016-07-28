//
//  ViewController.m
//  TextKit图文混排
//
//  Created by wxhl on 16/7/5.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "ViewController.h"
#import "EmojiTextAttachment.h"


#define cellId @"sadsadasd"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString * context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    
    
    
    _context = @"置顶阿里巴巴集团宣布，阿里旗下天猫将与湖南卫视联手\r\n于11月10日晚推出『天猫2015双11狂欢夜』[吃惊]。4小时全球互动直播，著名导演冯小刚将坐镇此次晚会的总导演。用晚会的形式过双11，无论对天猫和湖南卫视而言尚属首次。从目前对外透露的情况来看，这场“双11春晚”将融合综艺内容、明星游戏、移动购物于一体，消费者可以通过电视、网络、手机等平台，实现边看边玩边买";
    //实现图文混排 富文本 1.TextKit(OC)  2.CoreText (C函数)实现很复杂;

    
    //注册单元格
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
}


#pragma mark - UiTbaleViewDataScource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     //NSAttributedString.h 中文本属性key的说明
     /*
                        设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
            设置字体颜色，取值为 UIColor对象，默认值为黑色
     NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
     NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
     NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
     NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
     NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
     NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
     NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
     NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
     NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
     NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
     NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
     NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
     NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
     NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
     NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
     NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
     NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
     NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
     NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
     */
    
   
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.textLabel.numberOfLines = 0;
    
   /*
    //设置自动换行
    cell.textLabel.numberOfLines = 0;
    
    //创建 textView
    UITextView * textView = [[UITextView alloc]initWithFrame:cell.bounds];
    
    [cell.contentView addSubview:textView];
    
   
    //是否可被编辑
    textView.editable = NO;
    textView.selectable = YES;
    
    */
    if (indexPath.row == 0) {//1.设置颜色字体
        
      //创建属性文本,用来显示文字
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:_context];
        
        
        //设置属性文本的属性字典
        //颜色
        
        //大小

        
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 2)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(6, 10)];
        
        
        cell.textLabel.attributedText = attributeStr;
        
        
        
    }else if (indexPath.row == 1){//2.设置超链接
        
        //创建文本视图
        UITextView * textView = [[UITextView alloc]initWithFrame:cell.contentView.bounds];
        
        [cell.contentView addSubview:textView];
        
        //设置可编辑
        textView.editable = NO;
        //设置可选中
        textView.selectable = YES;
        
        textView.delegate = self;
        
        //1.设置属性文本
        NSMutableAttributedString * attri = [[NSMutableAttributedString alloc]initWithString:_context];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, _context.length)];
        
        //2.设置要跳转的超链接
        [attri addAttribute:NSLinkAttributeName value:@"https://www.baidu.com/" range:NSMakeRange(5, 5)];
        
        textView.attributedText = attri;
        
    
    }else if (indexPath.row == 2){//3.设置图片
        
        //1.创建文本属性
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:_context];
        
        //2.设置图片附件
        NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
        //设置附带的图片
        attachment.image = [UIImage imageNamed:@"007.png"];
        
        
        //3.根据副本文件,生成新的属性文本
        NSAttributedString * str = [NSAttributedString attributedStringWithAttachment:attachment];
        
        
        
        //4.将副本文件插入到属性文件中
//        [att insertAttributedString:str atIndex:5];
        //用副本文件添加属性文件中的字符
//        att addAttribute:<#(nonnull NSString *)#> value:<#(nonnull id)#> range:<#(NSRange)#>
        //用副本文件替换属性文件中的字符
        [att replaceCharactersInRange:NSMakeRange(2, 2) withAttributedString:str];
        
        
        //5.显示
        cell.textLabel.attributedText = att;
        
        
    }else if (indexPath.row == 3){
        
        
    }
    
    return cell;
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 150;
}

#pragma mark - UiTextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    NSLog(@"登录了%@",URL);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
