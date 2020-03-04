//
//  NSString+Category.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/11.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (MM)

- (CGSize)sizeWithLabelFont:(UIFont *)font
{
    return [self sizeWithFont:font maxSize:CGSizeMake(MScreenWidth, MScreenHeight)];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    return size;
}


@end
