//
//  Tool.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "Tool.h"
#import <AVKit/AVKit.h>

@implementation Tool

#pragma mark - 获取视频第一帧
+ (UIImage *)getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - 获取带标签的富文本
+ (NSAttributedString *)getAttributedTextWithTag:(NSString *)tag contentText:(NSString *)contentText
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:contentText];
    if (!MStringIsEmpty(tag)) {
        int scale = 3;
        UILabel * tagLabel = [UILabel new];
        tagLabel.text = tag;
        tagLabel.font = [UIFont boldSystemFontOfSize:12 * scale];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.backgroundColor = MDefaultColor;
        tagLabel.clipsToBounds = YES;
        tagLabel.layer.cornerRadius = 9 * scale;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        CGSize tagLabelSize = [tagLabel sizeThatFits:CGSizeMake(MScreenWidth, MScreenHeight)];
        tagLabel.frame = CGRectMake(0, 0, tagLabelSize.width + 10 * scale, 18 * scale);
        UIImage *image = [self imageWithUIView:tagLabel];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, tagLabelSize.width / 3 + 10, 18);
        attach.image = image;
        NSAttributedString * imageAttStr = [NSAttributedString attributedStringWithAttachment:attach];
        [attStr insertAttributedString:imageAttStr atIndex:0];
    }
    return attStr;
}

#pragma mark - view转成image
+ (UIImage *)imageWithUIView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


@end
