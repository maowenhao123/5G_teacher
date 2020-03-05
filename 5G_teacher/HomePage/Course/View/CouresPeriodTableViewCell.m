//
//  CouresPeriodTableViewCell.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CouresPeriodTableViewCell.h"

@interface CouresPeriodTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CouresPeriodTableViewCell

#pragma mark - Setting
- (void)setPeriodModel:(PeriodModel *)periodModel
{
    _periodModel = periodModel;
    
}

@end
