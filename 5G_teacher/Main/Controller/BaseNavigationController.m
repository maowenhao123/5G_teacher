//
//  BaseNavigationController.m
//  5G_teacher
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+Category.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

#pragma mark - 初始化
/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    [self setupNavigationBarTheme];
//    [self setupBarButtonItemTheme];
}

+ (void)setupNavigationBarTheme
{
    // 取出appearance对象
    UINavigationBar *navigationBar = [UINavigationBar appearance];

    // 设置背景
    [navigationBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, MScreenWidth, MStatusBarH + MNavBarH)] forBarMetrics:UIBarMetricsDefault];

    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MBlackTextColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navigationBar setTitleTextAttributes:textAttrs];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];

    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MBlackTextColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barButtonItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

#pragma mark - 跳转下个页面
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.tabBarController.viewControllers.count > 0)
    {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    return vc;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL hiddenNavBar = [viewController isKindOfClass:[NSClassFromString(@"LoginViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"CourseDetailViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"MineViewController") class]];
    [navigationController setNavigationBarHidden:hiddenNavBar animated:YES];
}


@end
