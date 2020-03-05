//
//  Tool.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject

+ (UIImage *)getVideoPreViewImage:(NSURL *)path;
+ (NSAttributedString *)getAttributedTextWithTag:(NSString *)tag contentText:(NSString *)contentText;
+ (UIImage *)imageWithUIView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
