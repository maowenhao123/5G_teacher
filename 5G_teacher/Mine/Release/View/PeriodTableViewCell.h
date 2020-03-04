//
//  PeriodTableViewCell.h
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/14.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeriodModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PeriodTableViewCellDelegate <NSObject>

- (void)periodTableViewCell:(UITableViewCell *)cell buttonDidClick:(UIButton *)button;

@end

@interface PeriodTableViewCell : UITableViewCell

+ (PeriodTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) CourseType courseType;
@property (nonatomic, strong) PeriodModel *periodModel;
@property (nonatomic, weak) id delegate;

@end

NS_ASSUME_NONNULL_END
