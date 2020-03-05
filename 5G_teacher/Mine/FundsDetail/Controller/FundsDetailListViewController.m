//
//  FundsDetailListViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "FundsDetailListViewController.h"
#import "FundsDetailTableViewCell.h"

@interface FundsDetailListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageCurrent;

@end

@implementation FundsDetailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
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

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundsDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FundsDetailTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"FundsDetailTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    return cell;
}


@end
