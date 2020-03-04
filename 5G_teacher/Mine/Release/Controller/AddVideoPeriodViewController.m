//
//  AddVideoPeriodViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "AddVideoPeriodViewController.h"
#import "HXPhotoPicker.h"

@interface AddVideoPeriodViewController ()

@property (nonatomic, weak) UITextField * titleTF;
@property (nonatomic, weak) UIImageView * videoImageView;
@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (nonatomic, copy) NSString *videoNo;

@end

@implementation AddVideoPeriodViewController

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
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, MScreenWidth, MCellH + 110)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
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
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), MScreenWidth, 1)];
    line.backgroundColor = MWhiteLineColor;
    [contentView addSubview:line];
    
    CGFloat imageViewH = 90;
    CGFloat imageViewW = 120;
    UILabel * videoBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(line.frame) + 10, imageViewW, imageViewH)];
    videoBgLabel.text = @"+上传视频";
    videoBgLabel.backgroundColor = MBackgroundColor;
    videoBgLabel.textColor = [UIColor darkGrayColor];
    videoBgLabel.font = [UIFont systemFontOfSize:13.5];
    videoBgLabel.textAlignment = NSTextAlignmentCenter;
    videoBgLabel.userInteractionEnabled = YES;
    [contentView addSubview:videoBgLabel];
    
    UIImageView * videoImageView = [[UIImageView alloc] initWithFrame:videoBgLabel.bounds];
    self.videoImageView = videoImageView;
    videoImageView.backgroundColor = MBackgroundColor;
    videoImageView.userInteractionEnabled = YES;
    [videoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseVideo:)]];
    [videoBgLabel addSubview:videoImageView];
    
    CGFloat playImageViewWH = 25;
    UIImageView * playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageViewW - playImageViewWH) / 2, (imageViewH - playImageViewWH) / 2, playImageViewWH, playImageViewWH)];
    playImageView.image = [UIImage imageNamed:@"video_play_icon"];
    playImageView.center = videoImageView.center;
    [videoImageView addSubview:playImageView];
    
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
        self.videoNo = self.periodModel.periodVideo.videoNo;
        [self getVideoUrlWithVideoNo:self.periodModel.periodVideo.videoNo];
    }
}

#pragma mark - 获取视频URL
- (void)getVideoUrlWithVideoNo:(NSString *)videoNo
{
    NSDictionary *parameters = @{
        @"videoNo": videoNo
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/chapter/period/audit/video" success:^(id json) {
        if (SUCCESS) {
            self.videoImageView.image = [Tool getVideoPreViewImage:[NSURL URLWithString:json[@"data"]]];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        
    }];
}

#pragma mark - Getting
- (HXPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.type = HXPhotoManagerSelectedTypeVideo;
        _photoManager.configuration.singleSelected = YES;
        _photoManager.configuration.requestImageAfterFinishingSelection = YES;
    }
    return _photoManager;
}

#pragma mark - 选择视频
- (void)chooseVideo:(UITapGestureRecognizer *)tap
{
    UIImageView * imageView = (UIImageView *)tap.view;
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel * photoModel = videoList.firstObject;
        imageView.image = [Tool getVideoPreViewImage:photoModel.videoURL];
        [self upLoadVideoWithPath:photoModel.videoURL];
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        MLog(@"block - 取消了");
    }];
}

- (void)upLoadVideoWithPath:(NSURL *)path
{
    [[MHttpTool shareInstance] upFileWithVideo:path Success:^(id  _Nonnull json) {
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"视频上传成功"];
            self.videoNo = json[@"data"];
        }else
        {
            ShowErrorView
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"视频上传失败"];
    }];
}

#pragma mark - 提交课时
- (void)confirmButtonDidClick
{
    [self.view endEditing:YES];
    
    if (MStringIsEmpty(self.titleTF.text)) {
        [MBProgressHUD showError:@"请输入课时标题"];
        return;
    }
    if (MStringIsEmpty(self.videoNo)) {
        [MBProgressHUD showError:@"请选择视频"];
        return;
    }
    NSDictionary *parameters = @{
        @"courseId": self.courseId,
        @"periodName": self.titleTF.text,
        @"videoNo": self.videoNo
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
