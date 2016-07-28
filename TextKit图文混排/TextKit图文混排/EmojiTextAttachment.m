//
//  EmojiTextAttachment.m
//  TextKitDemo
//
//  Created by JayWon on 15/10/26.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment


- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, lineFrag.size.height, lineFrag.size.height);
}

@end
