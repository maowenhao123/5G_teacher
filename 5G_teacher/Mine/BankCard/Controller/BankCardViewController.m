//
//  BankCardViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BankCardViewController.h"
#import "AddBankCardViewController.h"
#import "BankCardTableViewCell.h"
#import "BankCardModel.h"

@interface BankCardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BankCardModel * bankCardModel;

@end

@implementation BankCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"我的银行卡";
    [self setupUI];
    [self getBankCardData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankCardData) name:@"updateBankCard" object:nil];
}

#pragma mark - 请求数据
- (void)getBankCardData
{
    NSDictionary *parameters = @{
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/ext/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.bankCardModel = [BankCardModel mj_objectWithKeyValues:json[@"data"]];
            if (MStringIsEmpty(self.bankCardModel.bankCardNo)) {
                self.tableView.hidden = YES;
                self.noDataView.hidden = NO;
            }else
            {
                self.tableView.hidden = NO;
                self.noDataView.hidden = YES;
            }
            [self.tableView reloadData];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"换卡" style:UIBarButtonItemStyleDone target:self action:@selector(addButtonDidClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    
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
    }
    return _tableView;
}

- (UIView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH)];
        
        UILabel * noDataLabel = [[UILabel alloc] init];
        NSMutableAttributedString * noDataAttStr = [[NSMutableAttributedString alloc] initWithString:@"您还没有绑定银行卡"];
        [noDataAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, noDataAttStr.length)];
        [noDataAttStr addAttribute:NSForegroundColorAttributeName value:MBlackTextColor range:NSMakeRange(0, noDataAttStr.length)];
        noDataLabel.attributedText = noDataAttStr;
        CGSize noDataLabelSize = [noDataLabel.attributedText boundingRectWithSize:CGSizeMake(MScreenWidth - MMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        noDataLabel.frame = CGRectMake(0, _noDataView.height * 0.25, MScreenWidth, noDataLabelSize.height);
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:noDataLabel];
        
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(MScreenWidth * 0.2, CGRectGetMaxY(noDataLabel.frame) + 20, MScreenWidth * 0.6, 40);
        [addBtn setTitle:@"+ 绑定银行卡" forState:UIControlStateNormal];
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

- (void)addButtonDidClick
{
    AddBankCardViewController * addBankCardVC = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardTableViewCell * cell = [BankCardTableViewCell cellWithTableView:tableView];
    cell.model = self.bankCardModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


@end
