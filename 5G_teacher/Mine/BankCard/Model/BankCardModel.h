//
//  BankCardModel.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardModel : NSObject

@property (nonatomic, copy) NSString * lecturerUserNo;
@property (nonatomic, copy) NSNumber * totalIncome;
@property (nonatomic, copy) NSNumber * enableBalances;
@property (nonatomic, copy) NSString * lecturerName;
@property (nonatomic, copy) NSString * headImgUrl;
@property (nonatomic, copy) NSString * bankCardNo;
@property (nonatomic, copy) NSString * bankBranchName;
@property (nonatomic, copy) NSString * bankUserName;
@property (nonatomic, copy) NSString * bankName;

@end

NS_ASSUME_NONNULL_END
