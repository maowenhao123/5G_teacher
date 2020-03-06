//
//  CourseHeaderFooterView.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/24.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseHeaderFooterView.h"

@interface CourseHeaderFooterView ()

@end

@implementation CourseHeaderFooterView

+ (CourseHeaderFooterView *)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"CourseHeaderFooterViewId";
    CourseHeaderFooterView *headerView = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(headerView == nil)
    {
        headerView = [[CourseHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

//初始化子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, MScreenWidth - 2 * MMargin, 45)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = MBlackTextColor;
    [self.contentView addSubview:titleLabel];
}

@end
