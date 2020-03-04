//
//  MyCourseViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/5.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MyCourseViewController.h"
#import "MyCourseListViewController.h"
#import "SGPagingView.h"

@interface MyCourseViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation MyCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的课程";
    [self setupPageView];
}

- (void)setupPageView
{
    NSArray *titleArr = @[@"视频课", @"公开课", @"一对一"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleSelectedFont = [UIFont systemFontOfSize:17];
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.titleSelectedColor = MDefaultColor;
    configure.indicatorColor = MDefaultColor;
    configure.showBottomSeparator = NO;
    configure.titleGradientEffect = YES;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, MScreenWidth, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    NSMutableArray * childArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        MyCourseListViewController * courseListVC = [[MyCourseListViewController alloc] init];
        if (i == 0) {
            courseListVC.courseType = VideoCourse;
        }else if (i == 1)
        {
            courseListVC.courseType = PublicCourse;
        }else if (i == 2)
        {
            courseListVC.courseType = OnetooneCourse;
        }
        [childArr addObject:courseListVC];
    }
    CGFloat contentViewHeight = MScreenHeight - MStatusBarH - MNavBarH - CGRectGetMaxY(self.pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), MScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
    self.pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:self.pageContentScrollView];
    
    self.pageTitleView.selectedIndex = self.index;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


@end
