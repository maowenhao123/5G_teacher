//
//  MineViewController.m
//  5G_teacher
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MineViewController.h"
#import "AuthViewController.h"
#import "ShowViewController.h"
#import "BankCardViewController.h"
#import "SettingViewController.h"
#import "MineHeaderView.h"
#import "CourseDetailViewController.h"
#import "AddPublishPeriodViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineHeaderView * mineHeaderView;
@property (strong, nonatomic) UserModel *userModel;

@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self getUserData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"UpdateUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"WithdrawSuccess" object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 请求数据
- (void)getUserData
{
    NSDictionary *parameters = @{
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/audit/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];
        if (SUCCESS) {
            self.userModel = [UserModel mj_objectWithKeyValues:json[@"data"]];
            self.mineHeaderView.userModel = self.userModel;
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
    [self.view addSubview:self.tableView];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.mineHeaderView;
        
        __weak typeof(self) wself = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself getUserData];
        }];
    }
    return _tableView;
}

- (MineHeaderView *)mineHeaderView
{
    if (_mineHeaderView == nil) {
        _mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MStatusBarH + 160 + 9 + 110)];
    }
    return _mineHeaderView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }else if (section == 1)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MineTableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = MBlackTextColor;
        cell.imageView.backgroundColor = MPlaceholderColor;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"展示自我";
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"资格认证";
        }else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"我的银行卡";
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"客服";
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"设置";
        }
    }
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 9)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MCellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ShowViewController * showVC = [[ShowViewController alloc] init];
            showVC.userModel = self.userModel;
            [self.navigationController pushViewController:showVC animated:YES];
        }else if (indexPath.row == 1)
        {
            AuthViewController * authVC = [[AuthViewController alloc] init];
            authVC.userModel = self.userModel;
            [self.navigationController pushViewController:authVC animated:YES];
        }else if (indexPath.row == 2)
        {
            BankCardViewController * bankCardVC = [[BankCardViewController alloc] init];
            [self.navigationController pushViewController:bankCardVC animated:YES];
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            AddPublishPeriodViewController * showVC = [[AddPublishPeriodViewController alloc] init];
            [self.navigationController pushViewController:showVC animated:YES];
        }else if (indexPath.row == 1)
        {
            SettingViewController * settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }
}

@end
