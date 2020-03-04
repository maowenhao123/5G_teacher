//
//  CourseCategoryPickerView.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseCategoryPickerView.h"
#import "MUserDefaultTool.h"

@interface CourseCategoryPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIPickerView * pickView;
@property (nonatomic, strong) NSArray *categoryArray1;
@property (nonatomic, strong) NSArray *categoryArray2;
@property (nonatomic, assign) NSInteger selectedIndex1;
@property (nonatomic, assign) NSInteger selectedIndex2;
@property (nonatomic, copy) NSArray * courseCategoryList;

@end

@implementation CourseCategoryPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.frame = [UIScreen mainScreen].bounds;
        UIView *topView = [KEY_WINDOW.subviews firstObject];
        [topView addSubview:self];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, MScreenHeight, MScreenWidth, 255)];
        self.contentView = contentView;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        //工具栏取消和选择
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 0, 40, 39);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelButton];
        
        UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(MScreenWidth - 50, 0, 40, 39);
        [selectButton setTitle:@"选择" forState:UIControlStateNormal];
        [selectButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [selectButton addTarget:self action:@selector(selectBarClicked) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:selectButton];
        
        //PickerView
        UIPickerView * pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 39, MScreenWidth, 216)];
        self.pickView = pickView;
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        [pickView selectRow:0 inComponent:0 animated:NO];
        [contentView addSubview:pickView];
        
        self.courseCategoryList = [MUserDefaultTool getCategoryList];
        [self setcategoryArray1];
        [self setcategoryArray2WithRow1:0];
        [self.pickView reloadAllComponents];
    }
    return self;
}

//设置数据
- (void)setcategoryArray1
{
    NSArray * categoryArr = self.courseCategoryList;
    NSMutableArray *categoryMuArr = [NSMutableArray array];
    for (NSDictionary * categoryDic in categoryArr) {
        [categoryMuArr addObject:categoryDic[@"categoryName"]];
    }
    self.categoryArray1 = [NSArray arrayWithArray:categoryMuArr];
}

- (void)setcategoryArray2WithRow1:(NSInteger)row1
{
    NSArray * categoryArr = self.courseCategoryList;
    
    NSDictionary * categoryDic_child = categoryArr[row1];
    NSArray * categoryArr_child = categoryDic_child[@"list"];
    
    NSMutableArray *categoryMuArr = [NSMutableArray array];
    for (NSDictionary * categoryDic in categoryArr_child) {
        [categoryMuArr addObject:categoryDic[@"categoryName"]];
    }
    self.categoryArray2 = [NSArray arrayWithArray:categoryMuArr];
}

#pragma  mark - function
- (void)selectBarClicked
{
    NSArray * categoryArr = self.courseCategoryList;
    
    NSDictionary * categoryDic_child = categoryArr[self.selectedIndex1];
    NSArray * categoryArr_child = categoryDic_child[@"list"];
    
    if (self.block) {
        self.block(categoryArr[self.selectedIndex1], categoryArr_child[self.selectedIndex2]);
    }
    [self hide];
}

- (void)show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = MScreenHeight - self.contentView.height;
        self.backgroundColor = MColor(0, 0, 0, 0.4);
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = MScreenHeight;
        self.backgroundColor = MColor(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.categoryArray1.count;
    }
    return self.categoryArray2.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.categoryArray1[row];
    }
    return self.categoryArray2[row];
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = MBlackTextColor;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //刷新数据
    if (component == 0) {
        [self setcategoryArray2WithRow1:row];
        self.selectedIndex2 = 0;
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadComponent:1];
        
        self.selectedIndex1 = row;
    }else if (component == 1)
    {
        self.selectedIndex2 = row;
    }
}

#pragma mark - Getting
- (NSArray *)categoryArray1
{
    if (!_categoryArray1)
    {
        _categoryArray1 = [NSArray array];
    }
    return _categoryArray1;
}

- (NSArray *)categoryArray2
{
    if (!_categoryArray2)
    {
        _categoryArray2 = [NSArray array];
    }
    return _categoryArray2;
}


@end
