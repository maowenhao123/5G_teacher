//
//  AddBankCardViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BottomPickerView.h"

@interface AddBankCardViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *bankNameTF;
@property (nonatomic, weak) UITextField *bankBranchNameTF;
@property (nonatomic, weak) UITextField *bankNumberCardTF;
@property (strong, nonatomic) NSMutableArray *bankNames;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"绑定银行卡";
    [self setupUI];
    [self getBankData];
}

#pragma mark - 请求数据
- (void)getBankData
{
    NSDictionary *parameters = @{
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/system/api/bank/list" success:^(id json) {
        if (SUCCESS) {
            self.bankNames = json[@"data"][@"list"];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
    }];
}


#pragma mark - 布局子视图
- (void)setupUI
{
    NSArray * titles = @[@"持卡人姓名", @"所属银行", @"所属支行", @"银行卡号"];
    NSArray * placeholders = @[@"请输入", @"请选择银行", @"请输入支行名称", @"请输入并仔细确认"];
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 9, MScreenWidth, MCellH * titles.count)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    for (int i = 0; i < titles.count; i++) {
        CGFloat viewY = i * MCellH;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = MBlackTextColor;
        titleLabel.text = titles[i];
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(MMargin, viewY, size.width, MCellH);
        [contentView addSubview:titleLabel];
        
        //textField
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, MScreenWidth - CGRectGetMaxX(titleLabel.frame) - MMargin, MCellH)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = MBlackTextColor;
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = placeholders[i];
        textField.tintColor = MDefaultColor;
        if (i == 0) {
            self.nameTF = textField;
        }else if (i == 1)
        {
            self.bankNameTF = textField;
            textField.delegate = self;
        }else if (i == 2)
        {
            self.bankBranchNameTF = textField;
        }else if (i == 3)
        {
            self.bankNumberCardTF = textField;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [contentView addSubview:textField];
        
        //分割线
        if (i != 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, MCellH * i, MScreenWidth, 1)];
            line.backgroundColor = MWhiteLineColor;
            [contentView addSubview:line];
        }
    }
    
    //提交
    UIButton * submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(15, MScreenHeight - MStatusBarH - MNavBarH - 40 - MSafeBottomMargin - MMargin, MScreenWidth - 2 * 15, 40);
    submitButton.backgroundColor = MDefaultColor;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    submitButton.layer.cornerRadius = submitButton.height / 2;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(submitButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.bankNameTF) {//选择银行
        [self.view endEditing:YES];
        
        if (MArrayIsEmpty(self.bankNames)) {
            [MBProgressHUD showError:@"暂无银行"];
            return NO;
        }
        NSInteger index = 0;
        if (!MStringIsEmpty(self.bankNameTF.text)) {
            index = [self.bankNames indexOfObject:self.bankNameTF.text];
        }
        BottomPickerView * bankChooseView = [[BottomPickerView alloc]initWithArray:self.bankNames index:index];
        __weak typeof(self) wself = self;
        bankChooseView.block = ^(NSInteger selectedIndex){
            wself.bankNameTF.text = [NSString stringWithFormat:@"%@", wself.bankNames[selectedIndex]];
        };
        [bankChooseView show];
        
        return NO;
    }
    return YES;
}

#pragma mark - 提交
- (void)submitButtonDidClick:(UIButton *)button
{
    if (MStringIsEmpty(self.nameTF.text))
    {
        [MBProgressHUD showError:@"您还未输入持卡人姓名"];
        return;
    }
    if (MStringIsEmpty(self.bankNameTF.text))
    {
        [MBProgressHUD showError:@"您还未选择银行卡"];
        return;
    }
    if (MStringIsEmpty(self.nameTF.text))
    {
        [MBProgressHUD showError:@"您还未输入所属支行"];
        return;
    }
    if (MStringIsEmpty(self.nameTF.text))
    {
        [MBProgressHUD showError:@"您还未输入银行卡号"];
        return;
    }
    
    NSDictionary *parameters = @{
        @"bankCardNo": self.bankNumberCardTF.text,
        @"bankName": self.bankNameTF.text,
        @"bankBranchName": self.bankBranchNameTF.text,
        @"bankUserName": self.nameTF.text,
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/ext/update" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"提交成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBankCard" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - Getting
- (NSMutableArray *)bankNames
{
    if (!_bankNames) {
        _bankNames = [NSMutableArray array];
    }
    return _bankNames;
}


@end
