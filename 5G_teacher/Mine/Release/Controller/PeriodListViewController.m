//
//  PeriodListViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/15.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "PeriodListViewController.h"
#import "AddVideoPeriodViewController.h"
#import "AddPublishPeriodViewController.h"
#import "PeriodTableViewCell.h"
#import "UITableView+NoData.h"

@interface PeriodListViewController ()<UITableViewDelegate, UITableViewDataSource, PeriodTableViewCellDelegate>

@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *classArray;

@end

@implementation PeriodListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    if (self.courseType == VideoCourse) {
        self.title = @"视频课课时";
    }else if (self.courseType == PublicCourse)
    {
        self.title = @"公开课课时";
    }else if (self.courseType == OnetooneCourse)
    {
        self.title = @"一对一课时";
    }
    [self setupUI];
    [self getClassData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassData) name:@"UpdatePeriodList" object:nil];
}

#pragma mark - 请求数据
- (void)getClassData
{
    NSDictionary *parameters = @{
        @"courseId": @(self.courseId)
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/chapter/period/audit/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        if (SUCCESS) {
            self.classArray = [PeriodModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            [self classDidChange];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.noDataView];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.hidden = YES;
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself getClassData];
        }];
        
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 70)];
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(MMargin, 20, MScreenWidth - 2 * MMargin, 40);
        addBtn.backgroundColor = [UIColor whiteColor];
        [addBtn setTitle:@"+ 添加课时" forState:UIControlStateNormal];
        [addBtn setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBtn addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        addBtn.layer.cornerRadius = addBtn.height / 2;
        [footerView addSubview:addBtn];
        _tableView.tableFooterView = footerView;
        
    }
    return _tableView;
}

- (UIView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH)];
        
        UILabel * noDataLabel = [[UILabel alloc] init];
        NSMutableAttributedString * noDataAttStr = [[NSMutableAttributedString alloc] initWithString:@"您还没有添加课时"];
        [noDataAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, noDataAttStr.length)];
        [noDataAttStr addAttribute:NSForegroundColorAttributeName value:MBlackTextColor range:NSMakeRange(0, noDataAttStr.length)];
        noDataLabel.attributedText = noDataAttStr;
        CGSize noDataLabelSize = [noDataLabel.attributedText boundingRectWithSize:CGSizeMake(MScreenWidth - MMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        noDataLabel.frame = CGRectMake(0, _noDataView.height * 0.25, MScreenWidth, noDataLabelSize.height);
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:noDataLabel];
        
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(MScreenWidth * 0.2, CGRectGetMaxY(noDataLabel.frame) + 20, MScreenWidth * 0.6, 40);
        [addBtn setTitle:@"+ 添加课时" forState:UIControlStateNormal];
        [addBtn setTitleColor:MDefaultColor forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addBtn addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        addBtn.layer.cornerRadius = addBtn.height / 2;
        addBtn.layer.borderColor = MDefaultColor.CGColor;
        addBtn.layer.borderWidth = 1;
        [_noDataView addSubview:addBtn];
    }
    return _noDataView;
}

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (void)addButtonDidClick
{
    if (self.courseType == VideoCourse) {
        AddVideoPeriodViewController * addClassVC = [[AddVideoPeriodViewController alloc] init];
        addClassVC.courseId = self.courseId;
        addClassVC.courseType = self.courseType;
        [self.navigationController pushViewController:addClassVC animated:YES];
    }else
    {
        AddPublishPeriodViewController * addClassVC = [[AddPublishPeriodViewController alloc] init];
        addClassVC.courseId = self.courseId;
        addClassVC.courseType = self.courseType;
        [self.navigationController pushViewController:addClassVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView showNoDataWithRowCount:self.classArray.count];
    return self.classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeriodTableViewCell * cell = [PeriodTableViewCell cellWithTableView:tableView];
    cell.courseType = self.courseType;
    cell.periodModel = self.classArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.courseType == VideoCourse) {
        return 9 + MCellH * 2 + 110;
    }else
    {
        return 9 + MCellH * 3;
    }
}

- (void)classDidChange
{
    for (PeriodModel * periodModel in self.classArray) {
        periodModel.index = [self.classArray indexOfObject:periodModel];
    }
    if (self.classArray.count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    }else
    {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
}

#pragma mark - PeriodTableViewCellDelegate
- (void)periodTableViewCell:(UITableViewCell *)cell buttonDidClick:(UIButton *)button
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    PeriodModel * periodModel = self.classArray[indexPath.row];
    if ([button.currentTitle isEqualToString:@"删除"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除该课时吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction1];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *parameters = @{
                @"id": @(periodModel.id)
            };
            waitingView
            [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/chapter/period/audit/delete" success:^(id json) {
                [MBProgressHUD hideHUDForView:self.view];
                if (SUCCESS) {
                    [self.classArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self classDidChange];
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
    }else if ([button.currentTitle isEqualToString:@"编辑"])
    {
        if (self.courseType == VideoCourse) {
            AddVideoPeriodViewController * addClassVC = [[AddVideoPeriodViewController alloc] init];
            addClassVC.courseId = self.courseId;
            addClassVC.courseType = self.courseType;
            addClassVC.periodModel = periodModel;
            [self.navigationController pushViewController:addClassVC animated:YES];
        }else
        {
            AddPublishPeriodViewController * addClassVC = [[AddPublishPeriodViewController alloc] init];
            addClassVC.courseId = self.courseId;
            addClassVC.courseType = self.courseType;
            addClassVC.periodModel = periodModel;
            [self.navigationController pushViewController:addClassVC animated:YES];
        }
    }
}

@end
