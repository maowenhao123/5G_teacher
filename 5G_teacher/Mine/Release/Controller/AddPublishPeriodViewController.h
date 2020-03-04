//
//  AddPublishPeriodViewController.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/16.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"
#import "PeriodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddPublishPeriodViewController : BaseViewController

@property (nonatomic, strong) PeriodModel *periodModel;
@property (nonatomic, assign) CourseType courseType;
@property (nonatomic, copy) NSString *courseId;

@end

NS_ASSUME_NONNULL_END
