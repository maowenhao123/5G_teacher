//
//  MineHeaderView.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MineHeaderView.h"
#import "UserInfoViewController.h"
#import "WithdrawViewController.h"
#import "BalanceDetailViewController.h"
#import "MyCourseViewController.h"
#import "ChooseCourseTypeViewController.h"

@interface MineHeaderView ()

@property (nonatomic, weak) UIImageView * avatarImageView;
@property (nonatomic, weak) UILabel * nickNameLabel;
@property (nonatomic, weak) UILabel * infoLabel;
@property (nonatomic, weak) UILabel * moneyLabel;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupUI
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MStatusBarH + 100)];
    bgView.backgroundColor = MDefaultColor;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoDidTap)]];
    [self addSubview:bgView];
    
    //头像
    CGFloat avatarImageViewWH = 60;
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, MStatusBarH + (100 - avatarImageViewWH) * 0.4, avatarImageViewWH, avatarImageViewWH)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_placeholder"];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    [bgView addSubview:avatarImageView];
    
    //昵称
    CGFloat nickNameLabelX = CGRectGetMaxX(avatarImageView.frame) + 5;
    CGFloat nickNameLabelW = MScreenWidth - nickNameLabelX - 10;
    UILabel * nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickNameLabelX, avatarImageView.y + 10, nickNameLabelW, 20)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.font = [UIFont systemFontOfSize:16];
    nickNameLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:nickNameLabel];
    
    //信息
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickNameLabelX, CGRectGetMaxY(nickNameLabel.frame) + 5, nickNameLabelW, 20)];
    self.infoLabel = infoLabel;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:infoLabel];
    
    //余额
    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bgView.frame), MScreenWidth - 15 - 140, 60)];
    self.moneyLabel = moneyLabel;
    [self addSubview:moneyLabel];
    
    //按钮
    CGFloat buttonW = 72;
    CGFloat buttonH = 32;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(MScreenWidth - 5 - (buttonW + 10) * (i + 1), CGRectGetMaxY(bgView.frame) + (60 - buttonH) / 2, buttonW, buttonH);
        if (i == 0) {
            [button setTitle:@"明细" forState:UIControlStateNormal];
        }else
        {
            [button setTitle:@"提现" forState:UIControlStateNormal];
        }
        [button setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = buttonH / 2;
        button.layer.borderColor = MGrayLineColor.CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(fundsButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + 60, MScreenWidth, 9)];
    lineView.backgroundColor = MBackgroundColor;
    [self addSubview:lineView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(lineView.frame) + 13, MScreenWidth - 2 * MMargin, 20)];
    titleLabel.text = @"我的课程";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = MBlackTextColor;
    [self addSubview:titleLabel];
    
    CGFloat courseViewH = 70;
    CGFloat courseViewW = (MScreenWidth -  5 * MMargin) / 4;
    CGFloat imageViewWH = 35;
    for (int i = 0; i < 4; i++) {
        UIView *courseView = [[UIView alloc] initWithFrame:CGRectMake(MMargin + (courseViewW + MMargin) * i, CGRectGetMaxY(titleLabel.frame) + 3, courseViewW, courseViewH)];
        courseView.tag = 101 + i;
        [courseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(courseDidTap:)]];
        [self addSubview:courseView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((courseViewW - imageViewWH) / 2, 5, imageViewWH, imageViewWH)];
        imageView.backgroundColor = MPlaceholderColor;
        [courseView addSubview:imageView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, courseViewW, 20)];
        if (i == 0) {
            label.text = @"视频课";
            label.textColor = MBlackTextColor;
        }else if (i == 1)
        {
            label.text = @"公开课";
            label.textColor = MBlackTextColor;
        }else if (i == 2)
        {
            label.text = @"一对一";
            label.textColor = MBlackTextColor;
        }else if (i == 3)
        {
            label.text = @"发布课程";
            label.textColor = MDefaultColor;
        }
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [courseView addSubview:label];
    }
}

#pragma mark - 点击事件
- (void)userInfoDidTap
{
    [self.viewController.navigationController pushViewController:[UserInfoViewController new] animated:YES];
}

- (void)fundsButtonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        [self.viewController.navigationController pushViewController:[BalanceDetailViewController new] animated:YES];
    }else if (button.tag == 1)
    {
        [self.viewController.navigationController pushViewController:[WithdrawViewController new] animated:YES];
    }
}

- (void)courseDidTap:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag;
    if (tag == 104) {
        ChooseCourseTypeViewController * chooseCourseTypeVC = [[ChooseCourseTypeViewController alloc] init];
        [self.viewController.navigationController pushViewController:chooseCourseTypeVC animated:YES];
    }else
    {
        MyCourseViewController * myCourseVC = [[MyCourseViewController alloc] init];
        myCourseVC.index = tag - 101;
        [self.viewController.navigationController pushViewController:myCourseVC animated:YES];
    }
}

#pragma mark - Setting
- (void)setUserModel:(UserModel *)userModel
{
    _userModel = userModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    if (!MStringIsEmpty(_userModel.lecturerName)) {
        self.nickNameLabel.text = _userModel.lecturerName;
    }else
    {
        self.nickNameLabel.text = _userModel.lecturerMobile;
    }
    self.infoLabel.text = [NSString stringWithFormat:@"人气%ld 课程%ld", _userModel.ext.fansCount, _userModel.ext.courseCount];
    
    NSString *moneyText = [NSString stringWithFormat:@"%ld", _userModel.ext.account.balance];
    NSMutableAttributedString *moneyAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"余额 %@ 元", moneyText]];
    [moneyAttStr addAttribute:NSForegroundColorAttributeName value:MBlackTextColor range:NSMakeRange(0, moneyAttStr.length)];
    [moneyAttStr addAttribute:NSForegroundColorAttributeName value:MDefaultColor range:[moneyAttStr.string rangeOfString:moneyText]];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, moneyAttStr.length)];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:[moneyAttStr.string rangeOfString:moneyText]];
    self.moneyLabel.attributedText = moneyAttStr;
}

@end
