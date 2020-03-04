//
//  CourseDetailViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "ReleaseCourseViewController.h"
#import "CourseModel.h"

@interface CourseDetailViewController ()

@property (nonatomic, strong) CourseModel *courseModel;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self getCourseData];
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
    CGFloat bottomButonH = 40;
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MScreenHeight - MStatusBarH - MNavBarH - MSafeBottomMargin - bottomButonH, MScreenWidth, MSafeBottomMargin + bottomButonH)];
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
        bottomButon.titleLabel.font = [UIFont systemFontOfSize:15];
        [bottomButon addTarget:self action:@selector(bottomButonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButon];
    }
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

@end
