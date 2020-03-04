//
//  BankCardTableViewCell.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankCardTableViewCell : UITableViewCell

+ (BankCardTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BankCardModel *model;

@end

NS_ASSUME_NONNULL_END
