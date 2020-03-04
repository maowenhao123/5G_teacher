//
//  UserModel.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserExtModel : NSObject

@property (nonatomic, copy) NSString * bankBranchName;
@property (nonatomic, copy) NSString * bankCardNo;
@property (nonatomic, copy) NSString * bankIdCardNo;
@property (nonatomic, copy) NSString * bankName;
@property (nonatomic, copy) NSString * bankUserName;
@property (nonatomic, assign) NSInteger courseCount;
@property (nonatomic, assign) NSInteger enableBalances;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger freezeBalances;
@property (nonatomic, copy) NSString * gmtCreate;
@property (nonatomic, copy) NSString * gmtModified;
@property (nonatomic, assign) NSInteger historyMoney;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * lecturerUserNo;
@property (nonatomic, copy) NSString * sign;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger statusId;
@property (nonatomic, assign) NSInteger totalIncome;

@end

@interface UserModel : NSObject

@property (nonatomic, copy) NSString * auditOpinion;
@property (nonatomic, assign) NSInteger auditStatus;//0 审核中  1 审核通过  2 驳回
@property (nonatomic, copy) NSString * gmtCreate;
@property (nonatomic, copy) NSString * graduateCertImage;
@property (nonatomic, copy) NSString * graduateSchoolName;
@property (nonatomic, copy) NSString * headImgUrl;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * idCardBackImage;
@property (nonatomic, copy) NSString * idCardFrontImage;
@property (nonatomic, copy) NSString * idCardHandImage;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * lecturerEmail;
@property (nonatomic, copy) NSString * lecturerMobile;
@property (nonatomic, copy) NSString * lecturerName;
@property (nonatomic, copy) NSString * lecturerUserNo;
@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * specialCertImage;
@property (nonatomic, assign) NSInteger statusId;
@property (nonatomic, copy) NSString * teacherCertImage;
@property (nonatomic, assign) NSInteger tearcherAge;
@property (nonatomic, strong) UserExtModel * userExtModel;

@end

NS_ASSUME_NONNULL_END
