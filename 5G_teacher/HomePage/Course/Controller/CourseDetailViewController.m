//
//  CourseDetailViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "ReleaseCourseViewController.h"
#import "CourseHeaderFooterView.h"
#import "CourseInfoTableViewCell.h"
#import "CouresPeriodTableViewCell.h"
#import "CourseModel.h"

@interface CourseDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CourseModel *courseModel;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    [self getCourseData];
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"id": self.courseId
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/audit/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.courseModel = [CourseModel mj_objectWithKeyValues:json[@"data"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    
    CGFloat bottomButonH = 50;
    CGFloat bottomViewH = 60;
    if (IsBangIPhone) {
        bottomViewH = 50 + MSafeBottomMargin;
    }
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), MScreenWidth, bottomViewH)];
    [self.view addSubview:bottomView];
    for (int i = 0; i < 2; i++) {
        UIButton *bottomButon = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButon.tag = i;
        bottomButon.frame = CGRectMake(MScreenWidth * 0.5 * i, 0, MScreenWidth * 0.5, bottomButonH);
        if (i == 0) {
            [bottomButon setTitle:@"编辑" forState:UIControlStateNormal];
        }else
        {
            [bottomButon setTitle:@"删除" forState:UIControlStateNormal];
        }
        [bottomButon setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        bottomButon.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomButon addTarget:self action:@selector(bottomButonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButon];
    }
    
    UIView * bottomLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 1)];
    bottomLine1.backgroundColor = MWhiteLineColor;
    [bottomView addSubview:bottomLine1];
    
    UIView * bottomLine2 = [[UIView alloc] initWithFrame:CGRectMake(MScreenWidth / 2, (bottomButonH - 25) / 2, 1, 25)];
    bottomLine2.backgroundColor = MWhiteLineColor;
    [bottomView addSubview:bottomLine2];
    
    //返回
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(MMargin, MStatusBarH + 6, 32, 32);
    [backButton setImage:[UIImage imageNamed:@"gray_background_back_bar"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - 点击事件
- (void)backButtonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bottomButonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        ReleaseCourseViewController * releaseCourseVC = [[ReleaseCourseViewController alloc] init];
        if (self.courseModel.courseType == 1) {
            releaseCourseVC.courseType = VideoCourse;
        }else if (self.courseModel.courseType == 2)
        {
            releaseCourseVC.courseType = PublicCourse;
        }else if (self.courseModel.courseType == 3)
        {
            releaseCourseVC.courseType = OnetooneCourse;
        }
        releaseCourseVC.courseId = self.courseId;
        [self.navigationController pushViewController:releaseCourseVC animated:YES];
    }else if (button.tag == 1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除该课程吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction1];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *parameters = @{
                @"id": self.courseId
            };
            waitingView
            [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/audit/delete" success:^(id json) {
                [MBProgressHUD hideHUDForView:self.view];
                if (SUCCESS) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else
                {
                    ShowErrorView
                }
            } failure:^(NSError *error) {
                MLog(@"error:%@",error);
                [MBProgressHUD hideHUDForView:self.view];
            }];
        }];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat bottomViewH = 60;
        if (IsBangIPhone) {
            bottomViewH = 50 + MSafeBottomMargin;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - bottomViewH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
//        return self.courseModel.periodList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CourseInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseInfoTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CourseInfoTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        return cell;
    }else
    {
        CouresPeriodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouresPeriodTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CouresPeriodTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.index = indexPath.row;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        CourseHeaderFooterView * headerView = [CourseHeaderFooterView headerViewWithTableView:tableView];
        headerView.titleLabel.text = [NSString stringWithFormat:@"课程大纲·共%d讲", 5];
        return headerView;
    }else
    {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 9)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 305;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}


@end
