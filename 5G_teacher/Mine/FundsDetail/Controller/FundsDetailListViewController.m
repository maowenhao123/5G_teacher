//
//  FundsDetailListViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "FundsDetailListViewController.h"

@interface FundsDetailListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageCurrent;

@end

@implementation FundsDetailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    waitingView
    self.pageCurrent = 1;
    [self getFundsDetailData];
}

#pragma mark - 请求数据
- (void)getFundsDetailData
{
    NSInteger courseType = 0;
    NSDictionary *parameters = @{
        @"courseType": @(courseType),
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/audit/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
//           NSArray * dataArray = [CourseModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
//            if ([self.tableView.mj_header isRefreshing]) {
//                [self.courseArray removeAllObjects];
//            }
//            [self.courseArray addObjectsFromArray:dataArray];
//            [self.tableView.mj_header endRefreshing];
//            if (dataArray.count == 0) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }else
//            {
//                [self.tableView.mj_footer endRefreshing];
//            }
//           [self.tableView reloadData];
        }else
        {
            ShowErrorView
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
