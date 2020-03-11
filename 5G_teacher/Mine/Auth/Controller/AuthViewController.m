//
//  AuthViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/12.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "AuthViewController.h"
#import "HXPhotoPicker.h"

@interface AuthViewController ()

@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (strong, nonatomic) NSMutableArray *imageUrls;

@end

@implementation AuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"资格认证";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadBarDidClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    
    CGFloat imageViewH = 90;
    CGFloat imageViewW = (MScreenWidth - 4 * MMargin) / 3;
    for (int i = 0; i < 2; i++) {
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 9 + (9 + MCellH + imageViewH + MMargin * 2) * i, MScreenWidth, MCellH + imageViewH + MMargin * 2)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:contentView];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, MScreenWidth - 2 * MMargin, MCellH)];
        titleLabel.textColor = MBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:16];
        if (i == 0) {
            titleLabel.text = @"身份证";
        }else if (i == 1)
        {
            titleLabel.text = @"资格证书";
        }
        [contentView addSubview:titleLabel];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), MScreenWidth, 1)];
        line.backgroundColor = MWhiteLineColor;
        [contentView addSubview:line];
        
        for (int j = 0; j < 3; j++) {
            UILabel * bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin + (MMargin + imageViewW) * j, CGRectGetMaxY(titleLabel.frame) + MMargin, imageViewW, imageViewH)];
            bgLabel.backgroundColor = MBackgroundColor;
            bgLabel.textColor = MBlackTextColor;
            bgLabel.font = [UIFont systemFontOfSize:13.5];
            bgLabel.textAlignment = NSTextAlignmentCenter;
            bgLabel.numberOfLines = 2;
            bgLabel.userInteractionEnabled = YES;
            if (i == 0) {
                if (j == 0) {
                    bgLabel.text = @"+\n身份证正面";
                }else if (j == 1)
                {
                    bgLabel.text = @"+\n身份证反面";
                }else if (j == 2)
                {
                    bgLabel.text = @"+\n手持身份证照片";
                }
            }else if (i == 1)
            {
                if (j == 0) {
                    bgLabel.text = @"+\n院校毕业证书";
                }else if (j == 1)
                {
                    bgLabel.text = @"+\n教师从业资格证";
                }else if (j == 2)
                {
                    bgLabel.text = @"+\n专业资格证书";
                }
            }
            [contentView addSubview:bgLabel];
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:bgLabel.bounds];
            imageView.tag = i * 3 + j;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)]];
            [bgLabel addSubview:imageView];
            if (i == 0) {
                if (j == 0) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.idCardFrontImage] placeholderImage:[UIImage imageNamed:@""]];
                    [self.imageUrls replaceObjectAtIndex:0 withObject:self.userModel.idCardFrontImage];
                }else if (j == 1)
                {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.idCardBackImage] placeholderImage:[UIImage imageNamed:@""]];
                    [self.imageUrls replaceObjectAtIndex:1 withObject:self.userModel.idCardBackImage];
                }else if (j == 2)
                {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.idCardHandImage] placeholderImage:[UIImage imageNamed:@""]];
                    [self.imageUrls replaceObjectAtIndex:2 withObject:self.userModel.idCardHandImage];
                }
            }else if (i == 1)
            {
                if (j == 0) {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.graduateCertImage] placeholderImage:[UIImage imageNamed:@""]];
                    [self.imageUrls replaceObjectAtIndex:3 withObject:self.userModel.graduateCertImage];
                }else if (j == 1)
                {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.teacherCertImage] placeholderImage:[UIImage imageNamed:@""]];
                    [self.imageUrls replaceObjectAtIndex:4 withObject:self.userModel.teacherCertImage];
                }else if (j == 2)
                {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.specialCertImage] placeholderImage:[UIImage imageNamed:@""]];
                    [self.imageUrls replaceObjectAtIndex:5 withObject:self.userModel.specialCertImage];
                }
            }
        }
    }
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

- (NSMutableArray *)imageUrls
{
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            [_imageUrls addObject:@""];
        }
    }
    return _imageUrls;
}

#pragma mark - 选择图片
- (void)chooseImage:(UITapGestureRecognizer *)tap
{
    UIImageView * imageView = (UIImageView *)tap.view;
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel * photoModel = photoList.firstObject;
        imageView.image = photoModel.previewPhoto;
        [self upLoadImageWithImage:photoModel.previewPhoto index:imageView.tag];
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        MLog(@"block - 取消了");
    }];
}

- (void)upLoadImageWithImage:(UIImage *)image index:(NSInteger)index
{
    [[MHttpTool shareInstance] uploadWithImage:image currentIndex:-1 totalCount:1 Success:^(id json) {
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"图片上传成功"];
            [self.imageUrls replaceObjectAtIndex:index withObject:json[@"data"]];
        }else
        {
            ShowErrorView
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"图片上传失败"];
    }];
}

#pragma mark - 上传信息
- (void)uploadBarDidClick
{
    //判空
    for (int i = 0; i < self.imageUrls.count; i++) {
        NSString *imageUrl = self.imageUrls[i];
        if (MStringIsEmpty(imageUrl)) {
            if (i == 0) {
                [MBProgressHUD showError:@"请上传身份证正面"];
            }else if (i == 1)
            {
                [MBProgressHUD showError:@"请上传身份证反面"];
            }else if (i == 2)
            {
                [MBProgressHUD showError:@"请上传手持身份证照片"];
            }else if (i == 3)
            {
                [MBProgressHUD showError:@"请上传院校毕业证书"];
            }else if (i == 4)
            {
                [MBProgressHUD showError:@"请上传教师从业资格证"];
            }else if (i == 5)
            {
                [MBProgressHUD showError:@"请上传专业资格证书"];
            }
            return;
        }
    }
    
    NSDictionary *parameters = @{
        @"idCardFrontImage": self.imageUrls[0],
        @"idCardBackImage": self.imageUrls[1],
        @"idCardHandImage": self.imageUrls[2],
        @"graduateCertImage": self.imageUrls[3],
        @"teacherCertImage": self.imageUrls[4],
        @"specialCertImage": self.imageUrls[5],
    };
    waitingView
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/audit/apply" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationItem.rightBarButtonItem.enabled = YES;
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
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

@end
