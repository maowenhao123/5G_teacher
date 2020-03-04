//
//  HomeViewController.m
//  5G_teacher
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "HomeViewController.h"
#import "CourseListViewController.h"
#import "SGPagingView.h"

@interface HomeViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"上课";
    [self setupPageView];
}

- (void)setupPageView
{
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleSelectedFont = [UIFont systemFontOfSize:17];
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.titleSelectedColor = MDefaultColor;
    configure.indicatorColor = MDefaultColor;
    configure.showBottomSeparator = NO;
    configure.titleGradientEffect = YES;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray * childArr = [NSMutableArray array];
    NSArray * weeks = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    for (int i = 0; i < 7; i++) {
        if (i > 0) {
            dateComponents.day = dateComponents.day + 1;
        }
        NSDate *date = [calendar dateFromComponents:dateComponents];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDateComponents * weekDateComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
        if (i == 0) {
            [titleArr addObject:@"今天"];
        }else
        {
            [titleArr addObject:[NSString stringWithFormat:@"%@", weeks[weekDateComponents.weekday - 1]]];
        }
        
        CourseListViewController * courseListVC = [[CourseListViewController alloc] init];
        courseListVC.date = [dateFormatter stringFromDate:date];
        [childArr addObject:courseListVC];
    }
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, MScreenWidth, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    CGFloat contentViewHeight = MScreenHeight - MStatusBarH - MNavBarH - CGRectGetMaxY(self.pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), MScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
    self.pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:self.pageContentScrollView];
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
