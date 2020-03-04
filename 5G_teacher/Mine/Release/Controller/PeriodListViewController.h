//
//  PeriodListViewController.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/15.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeriodListViewController : BaseViewController

@property (nonatomic, assign) CourseType courseType;
@property (nonatomic, copy) NSString *courseId;

@end

NS_ASSUME_NONNULL_END
