//
//  ChooseCourseTypeViewController.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/4.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "ChooseCourseTypeViewController.h"
#import "ReleaseCourseViewController.h"

@interface ChooseCourseTypeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChooseCourseTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布新课";
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ChooseCourseTypeTableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = MBlackTextColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = MGrayTextColor;
        cell.imageView.backgroundColor = MPlaceholderColor;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"视频课";
        cell.detailTextLabel.text = @"上传课程录播视频，学员购买或免费观看";
    }else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"公开课";
        cell.detailTextLabel.text = @"一对多直播课程，学员预约成功后定时上课";
    }else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"一对一";
        cell.detailTextLabel.text = @"发布一对一在线辅导，学员预约成功后定时上课";
    }
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReleaseCourseViewController * releaseCourseVC = [[ReleaseCourseViewController alloc] init];
    if (indexPath.row == 0) {
        releaseCourseVC.courseType = VideoCourse;
    }else if (indexPath.row == 1)
    {
        releaseCourseVC.courseType = PublicCourse;
    }else if (indexPath.row == 2)
    {
        releaseCourseVC.courseType = OnetooneCourse;
    }
    [self.navigationController pushViewController:releaseCourseVC animated:YES];
}

@end
