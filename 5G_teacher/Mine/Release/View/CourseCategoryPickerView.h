//
//  CourseCategoryPickerView.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CourseCategoryPickerViewBlock)(NSDictionary * categoryDic, NSDictionary * subjectDic);

@interface CourseCategoryPickerView : UIView

@property (copy, nonatomic) CourseCategoryPickerViewBlock block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
