//
//  WithdrawViewController.m
//  5G_teacher
//
//  Created by dahe on 2020/3/5.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "WithdrawViewController.h"
#import "BankCardViewController.h"
#import "BankCardModel.h"

@interface WithdrawViewController ()

@property (nonatomic, weak) UITextField * moneyTF;
@property (nonatomic, weak) UITextField * bankCardTF;
@property (nonatomic, strong) BankCardModel * bankCardModel;

@end

@implementation WithdrawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"提现";
    [self setupUI];
    [self getBankCardData];
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
            if (!MStringIsEmpty(self.bankCardModel.bankCardNo)) {
                self.bankCardTF.text = self.bankCardModel.bankCardNo;
            }
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
    //提现金额
    UIView * moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, MScreenWidth, MCellH)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:moneyView];
    
    UILabel *moneyLabel = [self getTitleLabelWithText:@"提现金额"];
    [moneyView addSubview:moneyLabel];
    
    UITextField * moneyTF = [self getTextFieldWithPlaceholder:@"请输入"];
    self.moneyTF = moneyTF;
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    [moneyView addSubview:moneyTF];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyView.frame), MScreenWidth, 1)];
    line1.backgroundColor = MWhiteLineColor;
    [self.view addSubview:line1];
    
    //提现银行卡
    UIView * bankCardView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), MScreenWidth, MCellH)];
    bankCardView.backgroundColor = [UIColor whiteColor];
    [bankCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBankCard)]];
    [self.view addSubview:bankCardView];
    
    UILabel *bankCardLabel = [self getTitleLabelWithText:@"提现银行卡"];
    [bankCardView addSubview:bankCardLabel];
    
    UITextField * bankCardTF = [self getTextFieldWithPlaceholder:@"请选择"];
    self.bankCardTF = bankCardTF;
    bankCardTF.userInteractionEnabled = NO;
    [bankCardView addSubview:bankCardTF];
}

- (UILabel *)getTitleLabelWithText:(NSString *)text
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, 100, MCellH)];
    titleLabel.text = text;
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    return titleLabel;
}

- (UITextField *)getTextFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(MMargin + 100, 0, MScreenWidth - MMargin * 2 - 100, MCellH)];
    textField.placeholder = placeholder;
    textField.textColor = MBlackTextColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textAlignment = NSTextAlignmentRight;
    textField.tintColor = MDefaultColor;
    return textField;
}

#pragma mark - 选择银行卡
- (void)chooseBankCard
{
    BankCardViewController * bankCardVC = [[BankCardViewController alloc] init];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

@end
