//
//  AddPublishPeriodViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/16.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "AddPublishPeriodViewController.h"
#import "PGDatePickManager.h"

@interface AddPublishPeriodViewController ()<UITextFieldDelegate, PGDatePickerDelegate>

@property (nonatomic, weak) UITextField * titleTF;
@property (nonatomic, weak) UITextField * dateTF;
@property (nonatomic, weak) UITextField * startTimeTF;
@property (nonatomic, weak) UITextField * endTimeTF;

@end

@implementation AddPublishPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"添加课时";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, MScreenWidth, MCellH * 3)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, 100, MCellH)];
    titleLabel.text = @"标题";
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:titleLabel];
    
    UITextField * titleTF = [[UITextField alloc] initWithFrame:CGRectMake(MMargin + 100, 0, MScreenWidth - MMargin * 2 - 100, MCellH)];
    self.titleTF = titleTF;
    titleTF.placeholder = @"请输入课时标题";
    titleTF.textColor = MBlackTextColor;
    titleTF.font = [UIFont systemFontOfSize:16];
    titleTF.tintColor = MDefaultColor;
    titleTF.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:titleTF];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), MScreenWidth, 1)];
    line1.backgroundColor = MWhiteLineColor;
    [contentView addSubview:line1];
    
    //日期
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(titleLabel.frame), 100, MCellH)];
    dateLabel.text = @"日期";
    dateLabel.textColor = MBlackTextColor;
    dateLabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:dateLabel];
    
    UITextField * dateTF = [[UITextField alloc] initWithFrame:CGRectMake(MMargin + 100, CGRectGetMaxY(titleLabel.frame), MScreenWidth - MMargin * 2 - 100, MCellH)];
    self.dateTF = dateTF;
    dateTF.placeholder = @"请选择";
    dateTF.textColor = MBlackTextColor;
    dateTF.font = [UIFont systemFontOfSize:16];
    dateTF.tintColor = MDefaultColor;
    dateTF.textAlignment = NSTextAlignmentRight;
    dateTF.delegate = self;
    [contentView addSubview:dateTF];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dateLabel.frame), MScreenWidth, 1)];
    line2.backgroundColor = MWhiteLineColor;
    [contentView addSubview:line2];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(dateLabel.frame), 100, MCellH)];
    timeLabel.text = @"时间";
    timeLabel.textColor = MBlackTextColor;
    timeLabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:timeLabel];
    
    CGFloat timeTFW = 100;
    CGFloat zhiLabelW = 40;
    for (int i = 0; i < 2; i++) {
        UITextField * timeTF = [[UITextField alloc] initWithFrame:CGRectMake(MScreenWidth - MMargin - timeTFW - (timeTFW + zhiLabelW) * i, CGRectGetMaxY(dateLabel.frame) + 10, timeTFW, 30)];
        if (i == 0) {
            self.endTimeTF = timeTF;
            timeTF.placeholder = @"结束时间";
        }else if (i == 1)
        {
            self.startTimeTF = timeTF;
            timeTF.placeholder = @"开始时间";
        }
        timeTF.borderStyle = UITextBorderStyleRoundedRect;
        timeTF.textColor = MBlackTextColor;
        timeTF.font = [UIFont systemFontOfSize:16];
        timeTF.tintColor = MDefaultColor;
        timeTF.textAlignment = NSTextAlignmentCenter;
        timeTF.delegate = self;
        [contentView addSubview:timeTF];
    }
    UILabel * zhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(MScreenWidth - MMargin - timeTFW - zhiLabelW, CGRectGetMaxY(dateLabel.frame), zhiLabelW, MCellH)];
    zhiLabel.text = @"至";
    zhiLabel.textColor = MBlackTextColor;
    zhiLabel.font = [UIFont systemFontOfSize:16];
    zhiLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:zhiLabel];
    
    //确定
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(15, CGRectGetMaxY(contentView.frame) + 20, MScreenWidth - 2 * 15, 40);
    confirmButton.backgroundColor = MDefaultColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.layer.cornerRadius = confirmButton.height / 2;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    if (!MObjectIsEmpty(self.periodModel)) {
        self.titleTF.text = self.periodModel.periodName;
        self.dateTF.text = self.periodModel.periodLive.date;
        NSArray * startTimeArray = [self.periodModel.periodLive.startTime componentsSeparatedByString:@" "];
        self.startTimeTF.text = [NSString stringWithFormat:@"%@", startTimeArray.lastObject];
        NSArray * endTimeArray = [self.periodModel.periodLive.endTime componentsSeparatedByString:@" "];
        self.endTimeTF.text = [NSString stringWithFormat:@"%@", endTimeArray.lastObject];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.dateTF) {
        [self.view endEditing:YES];
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc] init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.tag = 101;
        datePicker.datePickerType = PGPickerViewType2;
        datePicker.datePickerMode = PGDatePickerModeDate;
        datePicker.delegate = self;
        [self presentViewController:datePickManager animated:false completion:nil];
        return NO;
    }else if (textField == self.startTimeTF)
    {
        [self.view endEditing:YES];
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc] init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.tag = 102;
        datePicker.datePickerType = PGPickerViewType2;
        datePicker.datePickerMode = PGDatePickerModeTime;
        datePicker.delegate = self;
        [self presentViewController:datePickManager animated:false completion:nil];
        return NO;
    }else if (textField == self.endTimeTF)
    {
        [self.view endEditing:YES];
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc] init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.tag = 103;
        datePicker.datePickerType = PGPickerViewType2;
        datePicker.datePickerMode = PGDatePickerModeTime;
        datePicker.delegate = self;
        [self presentViewController:datePickManager animated:false completion:nil];
        return NO;
    }
    return YES;
}

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    if (datePicker.tag == 101) {
        self.dateTF.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", dateComponents.year, dateComponents.month, dateComponents.day];
    }else if (datePicker.tag == 102)
    {
        self.startTimeTF.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", dateComponents.hour, dateComponents.minute, dateComponents.second];
    }else if (datePicker.tag == 103)
    {
        self.endTimeTF.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", dateComponents.hour, dateComponents.minute, dateComponents.second];
    }
}

#pragma mark - 提交课时
- (void)confirmButtonDidClick
{
    [self.view endEditing:YES];
    
    if (MStringIsEmpty(self.titleTF.text)) {
        [MBProgressHUD showError:@"请输入课时标题"];
        return;
    }
    if (MStringIsEmpty(self.dateTF.text)) {
        [MBProgressHUD showError:@"请选择日期"];
        return;
    }
    if (MStringIsEmpty(self.startTimeTF.text)) {
        [MBProgressHUD showError:@"请选择开始时间"];
        return;
    }
    if (MStringIsEmpty(self.endTimeTF.text)) {
        [MBProgressHUD showError:@"请选择结束时间"];
        return;
    }
    NSDictionary *parameters = @{
        @"courseId": self.courseId,
        @"periodName": self.titleTF.text,
        @"date": self.dateTF.text,
        @"startTime": self.startTimeTF.text,
        @"endTime": self.endTimeTF.text,
    };
    NSMutableDictionary *parameters_mu = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString * url = @"/course/auth/course/chapter/period/audit/save";
    if (!MObjectIsEmpty(self.periodModel)) {
        [parameters_mu setObject:self.periodModel.id forKey:@"id"];
        url = @"/course/auth/course/chapter/period/audit/update";
    }
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters_mu url:url success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            if (!MObjectIsEmpty(self.periodModel)) {
                [MBProgressHUD showSuccess:@"修改成功"];
            }else
            {
                [MBProgressHUD showSuccess:@"添加成功"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePeriodList" object:nil];
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

@end
