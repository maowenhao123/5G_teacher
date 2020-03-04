//
//  CourseModel.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseModel : NSObject

@property (nonatomic, assign) NSInteger auditStatus;
@property (nonatomic, copy) NSString *courseDiscount;
@property (nonatomic, copy) NSString *courseLogo;
@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, copy) NSString *courseOriginal;
@property (nonatomic, assign) NSInteger courseType;
@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) NSInteger isDelete;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) NSInteger isPutaway;
@property (nonatomic, assign) NSInteger statusId;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *categoryId1;
@property (nonatomic, copy) NSString *categoryId2;
@property (nonatomic, copy) NSString *categoryId3;

@end

NS_ASSUME_NONNULL_END
