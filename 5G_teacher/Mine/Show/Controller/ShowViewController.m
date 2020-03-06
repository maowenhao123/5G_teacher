//
//  ShowViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "ShowViewController.h"
#import "HXPhotoPicker.h"

@interface ShowViewController ()<HXPhotoViewDelegate>

@property (weak, nonatomic) UIScrollView * scrollView;
@property (weak, nonatomic) UIView * picView;
@property (strong, nonatomic) HXPhotoView *picPhotoView;
@property (weak, nonatomic) UIView * videoView;
@property (strong, nonatomic) HXPhotoView *videoPhotoView;
@property (nonatomic,copy) NSArray<HXPhotoModel *> *videos;
@property (nonatomic,copy) NSArray<HXPhotoModel *> *photos;
@property (nonatomic, strong) NSMutableArray * picUrlArray;
@property (nonatomic, strong) NSMutableArray * videoUrlArray;

@end

@implementation ShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MBackgroundColor;
    self.title = @"展示自我";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadBarDidClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //标题
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, MScreenWidth, MCellH)];
    titleView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:titleView];
    
    UILabel *titleLabel = [self getTitleLabelWithText:@"作品展示是学员认识你的首要途径"];
    [titleView addSubview:titleLabel];
    
    //图片
    UIView * picView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame) + 9, MScreenWidth, MCellH)];
    self.picView = picView;
    picView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:picView];
    
    UILabel *picTitleLabel = [self getTitleLabelWithText:@"图片"];
    [picView addSubview:picTitleLabel];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picTitleLabel.frame), MScreenWidth, 1)];
    line1.backgroundColor = MWhiteLineColor;
    [picView addSubview:line1];
    
    [picView addSubview:self.picPhotoView];
    picView.height = CGRectGetMaxY(self.picPhotoView.frame) + 2 * MMargin;
    
    //视频
    UIView * videoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picView.frame) + 9, MScreenWidth, MCellH + 100)];
    self.videoView = videoView;
    videoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:videoView];
    
    UILabel *videoTitleLabel = [self getTitleLabelWithText:@"视频"];
    [videoView addSubview:videoTitleLabel];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(videoTitleLabel.frame), MScreenWidth, 1)];
    line2.backgroundColor = MWhiteLineColor;
    [videoView addSubview:line2];
    
    [videoView addSubview:self.videoPhotoView];
    videoView.height = CGRectGetMaxY(self.videoPhotoView.frame) + 2 * MMargin;
}

- (UILabel *)getTitleLabelWithText:(NSString *)text
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, MScreenWidth - 2 * MMargin, MCellH)];
    titleLabel.text = text;
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    return titleLabel;
}

#pragma mark - Getting
- (HXPhotoView *)picPhotoView
{
    if (!_picPhotoView) {
        HXPhotoManager *photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        photoManager.configuration.photoMaxNum = 9;
        photoManager.configuration.reverseDate = YES;
        photoManager.configuration.requestImageAfterFinishingSelection = YES;
        
        _picPhotoView = [HXPhotoView photoManager:photoManager scrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat itemWH = (MScreenWidth - 4 * MMargin) / 3;
        _picPhotoView.frame = CGRectMake(0, MCellH, MScreenWidth, itemWH);
        _picPhotoView.collectionView.contentInset = UIEdgeInsetsMake(MMargin, MMargin, MMargin, MMargin);
        _picPhotoView.delegate = self;
        _picPhotoView.lineCount = 3;
        _picPhotoView.spacing = MMargin;
        _picPhotoView.previewShowDeleteButton = YES;
        _picPhotoView.showAddCell = YES;
    }
    return _picPhotoView;
}

- (HXPhotoView *)videoPhotoView
{
    if (!_videoPhotoView) {
        HXPhotoManager *photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
        photoManager.configuration.videoMaxNum = 9;
        photoManager.configuration.reverseDate = YES;
        photoManager.configuration.requestImageAfterFinishingSelection = YES;
        
        _videoPhotoView = [HXPhotoView photoManager:photoManager scrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat itemWH = (MScreenWidth - 4 * MMargin) / 3;
        _videoPhotoView.frame = CGRectMake(0, MCellH, MScreenWidth, itemWH);
        _videoPhotoView.collectionView.contentInset = UIEdgeInsetsMake(MMargin, MMargin, MMargin, MMargin);
        _videoPhotoView.delegate = self;
        _videoPhotoView.lineCount = 3;
        _videoPhotoView.spacing = MMargin;
        _videoPhotoView.previewShowDeleteButton = YES;
        _videoPhotoView.showAddCell = YES;
    }
    return _videoPhotoView;
}

- (NSMutableArray *)picUrlArray
{
    if (!_picUrlArray) {
        _picUrlArray = [NSMutableArray array];
    }
    return _picUrlArray;
}

- (NSMutableArray *)videoUrlArray
{
    if (!_videoUrlArray) {
        _videoUrlArray = [NSMutableArray array];
    }
    return _videoUrlArray;
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    if (photoView == self.picPhotoView) {
        self.picView.height = CGRectGetMaxY(self.picPhotoView.frame) + 2 * MMargin;
        self.videoView.y = CGRectGetMaxY(self.picView.frame) + 9;
    }else if (photoView == self.videoPhotoView)
    {
        self.videoView.height = CGRectGetMaxY(self.videoPhotoView.frame) + 2 * MMargin;
    }
    self.scrollView.contentSize = CGSizeMake(MScreenWidth, CGRectGetMaxY(self.videoView.frame) + MMargin);
}

- (void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal
{
    if (photoView == self.picPhotoView) {
        self.photos = photos;
    }else if (photoView == self.videoPhotoView)
    {
        self.videos = videos;
    }
}

#pragma mark - 上传
- (void)uploadBarDidClick
{
    if (MArrayIsEmpty(self.photos)) {
        [MBProgressHUD showError:@"请选择图片"];
        return;
    }
    if (MArrayIsEmpty(self.videos)) {
        [MBProgressHUD showError:@"请选择视频"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self upImageWithIndex:0];
}

- (void)upImageWithIndex:(NSInteger)index
{
    HXPhotoModel * photoModel = self.photos[index];
    UIImage * image = photoModel.previewPhoto;
    if (MObjectIsEmpty(image)) {
        image = photoModel.thumbPhoto;
    }
    [[MHttpTool shareInstance] uploadWithImage:image currentIndex:index totalCount:self.photos.count Success:^(id json) {
        if (SUCCESS) {
            [self.picUrlArray addObject:json[@"data"]];
            if (self.picUrlArray.count == self.photos.count) {
                [self upVideoWithIndex:0];
            }else
            {
                [self upImageWithIndex:index + 1];
            }
        }else
        {
            [MBProgressHUD showError:[NSString stringWithFormat:@"第%ld张图片%@", index, json[@"msg"]]];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"图片上传失败"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)upVideoWithIndex:(NSInteger)index
{
    HXPhotoModel * photoModel = self.videos[index];
    NSURL * videoURL = photoModel.videoURL;
    [[MHttpTool shareInstance] upFileWithVideo:videoURL currentIndex:index totalCount:self.videos.count Success:^(id json) {
        if (SUCCESS) {
            [self.videoUrlArray addObject:json[@"data"]];
            if (self.videoUrlArray.count == self.videos.count) {
                [self uploadData];
            }else
            {
                [self upVideoWithIndex:index + 1];
            }
        }else
        {
            [MBProgressHUD showError:[NSString stringWithFormat:@"第%ld个视频%@", index, json[@"msg"]]];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } Failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"图片上传失败"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)uploadData
{
    MLog(@"picUrlArray:%@\nvideoUrlArray:%@", self.picUrlArray, self.videoUrlArray);
    
    NSString * pictures = [self.picUrlArray componentsJoinedByString:@";"];
    NSString * videos = [self.videoUrlArray componentsJoinedByString:@";"];
    NSDictionary *parameters = @{
        @"pictures": pictures,
        @"videos": videos
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/user/auth/lecturer/audit/apply" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
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
