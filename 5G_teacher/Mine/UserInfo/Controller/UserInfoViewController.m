//
//  UserInfoViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TextViewViewController.h"
#import "UserAvatarTableViewCell.h"
#import "UserInfoTableViewCell.h"
#import "HXPhotoPicker.h"
#import "UserModel.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, TextViewViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (strong, nonatomic) UserModel *userModel;

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"个人资料";
    [self setupUI];
    [self getUserData];
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
    [self.view addSubview:self.tableView];
    
    //确定
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(15, CGRectGetMaxY(self.tableView.frame), MScreenWidth - 2 * 15, 40);
    confirmButton.backgroundColor = MDefaultColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.layer.cornerRadius = confirmButton.height / 2;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)confirmButtonDidClick
{
    NSDictionary *parameters = @{
        @"headImgUrl": self.userModel.headImgUrl,
        @"lecturerName": self.userModel.lecturerName,
        @"introduce": self.userModel.introduce,
        @"graduateSchoolName": self.userModel.graduateSchoolName,
        @"tearcherAge": @(self.userModel.tearcherAge)
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/audit/apply" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
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
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat tableViewH = MScreenHeight - MStatusBarH - MNavBarH - MMargin;
        if (IsBangIPhone) {
            tableViewH = MScreenHeight - MStatusBarH - MNavBarH - MSafeBottomMargin - 40;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, tableViewH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (HXPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.singleSelected = YES;
        _photoManager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _photoManager;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section == 1)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserAvatarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserAvatarTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"UserAvatarTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        return cell;
    }else
    {
        UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.titleLabel.text = @"昵称";
            if (!MStringIsEmpty(self.userModel.lecturerName)) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.lecturerName];
            }
        }else if (indexPath.section == 0 && indexPath.row == 2)
        {
            cell.titleLabel.text = @"老师简介";
            cell.contentTF.userInteractionEnabled = NO;
            if (!MStringIsEmpty(self.userModel.introduce)) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.introduce];
            }
        }else if (indexPath.section == 0 && indexPath.row == 3)
        {
            cell.titleLabel.text = @"毕业院校";
            if (!MStringIsEmpty(self.userModel.graduateSchoolName)) {
                cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.graduateSchoolName];
            }
        }else if (indexPath.section == 0 && indexPath.row == 4)
        {
            cell.titleLabel.text = @"教龄";
            cell.contentTF.text = [NSString stringWithFormat:@"%ld", self.userModel.tearcherAge];
        }else if (indexPath.section == 1 && indexPath.row == 0)
        {
            cell.titleLabel.text = @"手机号码";
            cell.contentTF.userInteractionEnabled = NO;
            cell.contentTF.text = [NSString stringWithFormat:@"%@", self.userModel.lecturerMobile];
        }else if (indexPath.section == 1 && indexPath.row == 1)
        {
            cell.titleLabel.text = @"资格认证";
            cell.contentTF.userInteractionEnabled = NO;
            if (self.userModel.auditStatus == 2) {
                cell.contentTF.text = @"驳回";
            }else if (self.userModel.auditStatus == 1)
            {
                cell.contentTF.text = @"审核通过";
            }else if (self.userModel.auditStatus == 0)
            {
                cell.contentTF.text = @"审核中";
            }
        }
        return cell;
    }
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
            HXPhotoModel * photoModel = photoList.firstObject;
            [self upLoadImageWithImage:photoModel.previewPhoto];
        } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
            MLog(@"block - 取消了");
        }];
    }else if (indexPath.section == 0 && indexPath.row == 2)
    {
        TextViewViewController * textViewVC = [[TextViewViewController alloc] init];
        textViewVC.title = @"老师简介";
        textViewVC.text = self.userModel.introduce;
        textViewVC.delegate = self;
        [self.navigationController pushViewController:textViewVC animated:YES];
    }
}

- (void)textViewViewControllerDidConfirm:(NSString *)text
{
    self.userModel.introduce = text;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)upLoadImageWithImage:(UIImage *)image
{
    [[MHttpTool shareInstance] uploadWithImage:image currentIndex:-1 totalCount:1 Success:^(id json) {
        if (SUCCESS) {
            self.userModel.headImgUrl = json[@"data"];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            ShowErrorView
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"图片上传失败"];
    }];
}

@end
