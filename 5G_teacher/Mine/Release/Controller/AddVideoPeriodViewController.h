//
//  AddVideoPeriodViewController.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseViewController.h"
#import "PeriodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddVideoPeriodViewController : BaseViewController

@property (nonatomic, strong) PeriodModel *periodModel;
@property (nonatomic, assign) CourseType courseType;
@property (nonatomic, assign) NSInteger courseId;

@end

NS_ASSUME_NONNULL_END
