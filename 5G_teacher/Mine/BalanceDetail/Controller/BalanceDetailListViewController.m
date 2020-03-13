//
//  BalanceDetailListViewController.m
//  5G_teacher
//
//  Created by dahe on 2020/3/12.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BalanceDetailListViewController.h"
#import "BalanceDetailTableViewCell.h"
#import "UserModel.h"
#import "UITableView+NoData.h"

@interface BalanceDetailListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageCurrent;
@property (strong, nonatomic) NSMutableArray *balanceArray;

@end

@implementation BalanceDetailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    waitingView
    self.pageCurrent = 1;
    [self getBalanceDetailData];
}

#pragma mark - 请求数据
- (void)getBalanceDetailData
{
    NSDictionary *parameters = @{
        @"type": @(0),
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/profit/log/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
           NSArray * dataArray = [BalanceDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.balanceArray removeAllObjects];
            }
            [self.balanceArray addObjectsFromArray:dataArray];
            [self.tableView.mj_header endRefreshing];
            if (dataArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [self.tableView.mj_footer endRefreshing];
            }
           [self.tableView reloadData];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.pageCurrent = 1;
            [wself getBalanceDetailData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            wself.pageCurrent ++;
            [wself getBalanceDetailData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)balanceArray
{
    if (!_balanceArray) {
        _balanceArray = [NSMutableArray array];
    }
    return _balanceArray;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView showNoDataWithRowCount:self.balanceArray.count];
    return self.balanceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceDetailTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"BalanceDetailTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
    cell.balanceDetailModel = self.balanceArray[indexPath.row];
    return cell;
}

@end
