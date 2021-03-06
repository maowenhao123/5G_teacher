//
//  CourseListViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseListViewController.h"
#import "CourseDetailViewController.h"
#import "CourseHeaderFooterView.h"
#import "CourseTableViewCell.h"
#import "UITableView+NoData.h"

@interface CourseListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *courseArray;
@property (nonatomic, assign) NSInteger pageCurrent;

@end

@implementation CourseListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    waitingView
    self.pageCurrent = 1;
    [self getCourseData];
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"date": self.date,
        @"pageCurrent": @(self.pageCurrent),
        @"pageSize": MPageSize
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/lecturer/period/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
           NSArray * dataArray = [CourseModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.courseArray removeAllObjects];
            }
            [self.courseArray addObjectsFromArray:dataArray];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH - 44 - MTabBarH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 80;
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            wself.pageCurrent = 1;
            [wself getCourseData];
        }];
        _tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            wself.pageCurrent ++;
            [wself getCourseData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)courseArray
{
    if (!_courseArray) {
        _courseArray = [NSMutableArray array];
    }
    return _courseArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView showNoDataWithRowCount:self.courseArray.count];
    return 5;
//    return self.courseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
    if (cell == nil) {
        cell = [[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    }
//    cell.courseModel = self.courseArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CourseHeaderFooterView * headerView = [CourseHeaderFooterView headerViewWithTableView:tableView];
    headerView.backgroundColor = MBackgroundColor;
    if (section == 0) {
        headerView.titleLabel.text = @"正在上课";
    }else if (section == 1)
    {
        headerView.titleLabel.text = @"即将开课";
    }else if (section == 2)
    {
        headerView.titleLabel.text = @"已完课";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    CourseDetailViewController * courseDetailVC = [[CourseDetailViewController alloc] init];
//    CourseModel *courseModel = self.courseArray[indexPath.row];
//    courseDetailVC.courseId = courseModel.id;
//    [self.navigationController pushViewController:courseDetailVC animated:YES];
//}



@end
