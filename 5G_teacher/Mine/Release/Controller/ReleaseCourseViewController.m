//
//  ReleaseCourseViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "ReleaseCourseViewController.h"
#import "PeriodListViewController.h"
#import "IQTextView.h"
#import "CourseCategoryPickerView.h"
#import "HXPhotoPicker.h"
#import "CourseModel.h"
#import "MUserDefaultTool.h"

@interface ReleaseCourseViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField * titleTF;
@property (nonatomic, weak) UITextField * typeTF;
@property (nonatomic, weak) UIImageView * logoImageView;
@property (nonatomic, weak) IQTextView * introTV;
@property (nonatomic, weak) UITextField * priceTF;
@property (nonatomic, weak) CourseCategoryPickerView * categoryPickerView;
@property (nonatomic, strong) NSDictionary * categoryDic;
@property (nonatomic, strong) NSDictionary * subjectDic;
@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (nonatomic, copy) NSString *courseLogo;
@property (nonatomic, strong) CourseModel *courseModel;

@end

@implementation ReleaseCourseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    if (self.courseType == VideoCourse) {
        self.title = @"视频课";
    }else if (self.courseType == PublicCourse)
    {
        self.title = @"公开课";
    }else if (self.courseType == OnetooneCourse)
    {
        self.title = @"一对一";
    }
    [self setupUI];
    if (!MStringIsEmpty(self.courseId)) {
        [self getCourseData];
    }
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"id": self.courseId
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/audit/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.courseModel = [CourseModel mj_objectWithKeyValues:json[@"data"]];
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
    //标题
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, MScreenWidth, MCellH)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    UILabel *titleLabel = [self getTitleLabelWithText:@"课程标题"];
    [titleView addSubview:titleLabel];
    
    UITextField * titleTF = [self getTextFieldWithPlaceholder:@"请输入"];
    self.titleTF = titleTF;
    [titleView addSubview:titleTF];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), MScreenWidth, 1)];
    line1.backgroundColor = MWhiteLineColor;
    [self.view addSubview:line1];
    
    //专业
    UIView * typeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), MScreenWidth, MCellH)];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    
    UILabel *typeLabel = [self getTitleLabelWithText:@"课程专业"];
    [typeView addSubview:typeLabel];
    
    UITextField * typeTF = [self getTextFieldWithPlaceholder:@"请输入"];
    self.typeTF = typeTF;
    typeTF.delegate = self;
    [typeView addSubview:typeTF];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(typeView.frame), MScreenWidth, 1)];
    line2.backgroundColor = MWhiteLineColor;
    [self.view addSubview:line2];
    
    //选择专业
    CourseCategoryPickerView * categoryPickerView = [[CourseCategoryPickerView alloc] init];
    self.categoryPickerView = categoryPickerView;
    __weak typeof(self) wself = self;
    categoryPickerView.block = ^(NSDictionary * categoryDic, NSDictionary * subjectDic){
        wself.typeTF.text = [NSString stringWithFormat:@"%@ %@", categoryDic[@"categoryName"], subjectDic[@"categoryName"]];
        wself.categoryDic = categoryDic;
        wself.subjectDic = subjectDic;
    };
    
    //海报
    UIView * logoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), MScreenWidth, MCellH + 100)];
    logoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:logoView];
    
    UILabel *logoLabel = [self getTitleLabelWithText:@"课程海报"];
    [logoView addSubview:logoLabel];
    
    CGFloat imageViewH = 90;
    CGFloat imageViewW = 120;
    UILabel * logoBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(logoLabel.frame), imageViewW, imageViewH)];
    logoBgLabel.text = @"+上传海报";
    logoBgLabel.backgroundColor = MBackgroundColor;
    logoBgLabel.textColor = [UIColor darkGrayColor];
    logoBgLabel.font = [UIFont systemFontOfSize:13.5];
    logoBgLabel.textAlignment = NSTextAlignmentCenter;
    logoBgLabel.userInteractionEnabled = YES;
    [logoView addSubview:logoBgLabel];
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:logoBgLabel.bounds];
    self.logoImageView = logoImageView;
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)]];
    [logoBgLabel addSubview:logoImageView];
    
    //简介
    UIView * introView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoView.frame) + 9, MScreenWidth, MCellH + 150)];
    introView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:introView];
    
    UILabel *introLabel = [self getTitleLabelWithText:@"课程简介"];
    [introView addSubview:introLabel];
    
    IQTextView * introTV = [[IQTextView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(introLabel.frame), MScreenWidth - 12 * 2, 150)];
    self.introTV = introTV;
    introTV.backgroundColor = [UIColor whiteColor];
    introTV.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    introTV.textColor = MBlackTextColor;
    introTV.tintColor = MDefaultColor;
    introTV.font = [UIFont systemFontOfSize:16];
    introTV.placeholder = @"请输入";
    [introView addSubview:introTV];
    
    //价格
    UIView * priceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introView.frame) + 9, MScreenWidth, MCellH)];
    priceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:priceView];
    
    UILabel *priceLabel = [self getTitleLabelWithText:@"课程价格"];
    [priceView addSubview:priceLabel];
    
    UITextField * priceTF = [self getTextFieldWithPlaceholder:@"请输入"];
    self.priceTF = priceTF;
    priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    [priceView addSubview:priceTF];
    
    //下一步
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat nextButtonY = MScreenHeight - MStatusBarH - MNavBarH - MMargin;
    if (IsBangIPhone) {
        nextButtonY = MScreenHeight - MStatusBarH - MNavBarH - MSafeBottomMargin - 40;
    }
    nextButton.frame = CGRectMake(MMargin, nextButtonY, MScreenWidth - 2 * MMargin, 40);
    nextButton.backgroundColor = MDefaultColor;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextButton.layer.cornerRadius = nextButton.height / 2;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.typeTF) {//选择专业
        [self.view endEditing:YES];
        [self.categoryPickerView show];
        return NO;
    }
    return YES;
}

#pragma mark - Getting
- (HXPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.singleSelected = YES;
        _photoManager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _photoManager;
}

#pragma mark - Getting
- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    self.titleTF.text = _courseModel.courseName;
    self.courseLogo = _courseModel.courseLogo;
    self.introTV.text = _courseModel.introduce;
    self.priceTF.text = _courseModel.courseOriginal;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:_courseModel.courseLogo]];
    
    NSString *categoryString = @"";
    NSArray * categoryArray = [MUserDefaultTool getCategoryList];
    for (NSDictionary * categoryDic in categoryArray) {
        if ([categoryDic[@"id"] isEqualToString:_courseModel.categoryId1]) {
            categoryString = categoryDic[@"categoryName"];
        }
    }
    self.categoryDic = @{
        @"categoryName": categoryString,
        @"id": _courseModel.categoryId1
    };
    if (!MStringIsEmpty(_courseModel.categoryId2)) {
        NSString *subjectString = @"";
        for (NSDictionary * categoryDic in categoryArray) {
            if ([categoryDic[@"id"] isEqualToString:_courseModel.categoryId1]) {
                for (NSDictionary * subjectDic in categoryDic[@"list"]) {
                    if ([subjectDic[@"id"] isEqualToString:_courseModel.categoryId2]) {
                        subjectString = categoryDic[@"categoryName"];
                    }
                }
            }
        }
        self.subjectDic = @{
            @"categoryName": subjectString,
            @"id": _courseModel.categoryId2
        };
        self.typeTF.text = [NSString stringWithFormat:@"%@ %@", categoryString, subjectString];
    }else
    {
        self.typeTF.text = categoryString;
    }
}

#pragma mark - 选择图片
- (void)chooseImage:(UITapGestureRecognizer *)tap
{
    UIImageView * imageView = (UIImageView *)tap.view;
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel * photoModel = photoList.firstObject;
        imageView.image = photoModel.previewPhoto;
        [self upLoadImageWithImage:photoModel.previewPhoto];
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        MLog(@"block - 取消了");
    }];
}

- (void)upLoadImageWithImage:(UIImage *)image
{
    [[MHttpTool shareInstance] uploadWithImage:image currentIndex:-1 totalCount:1 Success:^(id json) {
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"图片上传成功"];
            self.courseLogo = json[@"data"];
        }else
        {
            ShowErrorView
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"图片上传失败"];
    }];
}

- (void)nextButtonDidClick:(UIButton *)button
{
    [self.view endEditing:YES];
    
//    //1230016747263684610
//    //1229965384022421505
//    PeriodListViewController * classListVC = [[PeriodListViewController alloc] init];
//    classListVC.courseId = @"1230016747263684610";
//    classListVC.courseType = self.courseType;
//    [self.navigationController pushViewController:classListVC animated:YES];
//    return;
    
    if (MStringIsEmpty(self.titleTF.text)) {
        [MBProgressHUD showError:@"请输入课程标题"];
        return;
    }
    if (MDictIsEmpty(self.categoryDic)) {
        [MBProgressHUD showError:@"请选择课程分类"];
        return;
    }
    if (MStringIsEmpty(self.courseLogo)) {
        [MBProgressHUD showError:@"请选择海报"];
        return;
    }
    if (MStringIsEmpty(self.introTV.text)) {
        [MBProgressHUD showError:@"请输入课程简介"];
        return;
    }
    if (MStringIsEmpty(self.priceTF.text)) {
        [MBProgressHUD showError:@"请输入课程价格"];
        return;
    }
    NSString * categoryId1 = @"";
    if ([self.categoryDic.allKeys containsObject:@"id"]) {
        categoryId1 = self.categoryDic[@"id"];
    }
    NSString * categoryId2 = @"";
    if (!MDictIsEmpty(self.subjectDic)) {
        if ([self.subjectDic.allKeys containsObject:@"id"]) {
            categoryId2 = self.subjectDic[@"id"];
        }
    }
    
    NSInteger courseType = 0;
    if (self.courseType == VideoCourse) {
        courseType = 1;
    }else if (self.courseType == PublicCourse)
    {
        courseType = 2;
    }else if (self.courseType == OnetooneCourse)
    {
        courseType = 3;
    }
    NSDictionary *parameters = @{
        @"categoryId1": categoryId1,
        @"categoryId2": categoryId2,
        @"courseName": self.titleTF.text,
        @"courseLogo": self.courseLogo,
        @"introduce": self.introTV.text,
        @"courseOriginal": self.priceTF.text,
        @"courseType": @(courseType),
    };
    NSMutableDictionary *parameters_mu = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString * url = @"/course/auth/course/audit/save";
    if (!MStringIsEmpty(self.courseId)) {
        [parameters_mu setValue:self.courseId forKey:@"id"];
        url = @"/course/auth/course/audit/update";
    }
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:url success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"发布成功"];
            PeriodListViewController * classListVC = [[PeriodListViewController alloc] init];
            classListVC.courseId = json[@"data"][@"id"];//1228675557448658946
            classListVC.courseType = self.courseType;
            [self.navigationController pushViewController:classListVC animated:YES];
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
