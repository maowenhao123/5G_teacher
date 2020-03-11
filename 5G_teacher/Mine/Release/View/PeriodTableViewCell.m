//
//  PeriodTableViewCell.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/14.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "PeriodTableViewCell.h"

@interface PeriodTableViewCell ()

@property (nonatomic, weak) UILabel * indexLabel;
@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UIImageView * videoImageView;
@property (nonatomic, weak) UILabel * timeTitleLabel;
@property (nonatomic, weak) UILabel * timeLabel;

@end

@implementation PeriodTableViewCell

+ (PeriodTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PeriodTableViewCellId";
    PeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[PeriodTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return  cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupUI
{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 9)];
    lineView.backgroundColor = MBackgroundColor;
    [self addSubview:lineView];
    
    UILabel * indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(lineView.frame), 100, MCellH)];
    self.indexLabel = indexLabel;
    indexLabel.textColor = MBlackTextColor;
    indexLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:indexLabel];
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(MScreenWidth - MMargin - 50, CGRectGetMaxY(lineView.frame), 50, MCellH);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:MDefaultColor forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deleteButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(MScreenWidth - MMargin - 50 - 50, CGRectGetMaxY(lineView.frame), 50, MCellH);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:16];
    editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [editButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editButton];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(indexLabel.frame), MScreenWidth, 1)];
    line1.backgroundColor = MWhiteLineColor;
    [self addSubview:line1];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(indexLabel.frame), MScreenWidth - MMargin * 2, MCellH)];
    self.titleLabel = titleLabel;
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:titleLabel];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(indexLabel.frame), MScreenWidth, 1)];
    line2.backgroundColor = MWhiteLineColor;
    [self addSubview:line2];
    
    //视频
    CGFloat imageViewH = 90;
    CGFloat imageViewW = 120;
    UIImageView * videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(titleLabel.frame) + 10, imageViewW, imageViewH)];
    self.videoImageView = videoImageView;
    videoImageView.backgroundColor = MBackgroundColor;
    [self addSubview:videoImageView];
    
    CGFloat playImageViewWH = 25;
    UIImageView * playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageViewW - playImageViewWH) / 2, (imageViewH - playImageViewWH) / 2, playImageViewWH, playImageViewWH)];
    playImageView.image = [UIImage imageNamed:@"video_play_icon"];
    [videoImageView addSubview:playImageView];
    
    //时间
    UILabel * timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, CGRectGetMaxY(titleLabel.frame), 100, MCellH)];
    self.timeTitleLabel = timeTitleLabel;
    timeTitleLabel.text = @"时间";
    timeTitleLabel.textColor = MBlackTextColor;
    timeTitleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:timeTitleLabel];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin + 100, CGRectGetMaxY(titleLabel.frame), MScreenWidth - MMargin * 2 - 100, MCellH)];
    self.timeLabel = timeLabel;
    timeLabel.textColor = MGrayTextColor;
    timeLabel.font = [UIFont systemFontOfSize:16];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
}

- (void)buttonDidClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(periodTableViewCell:buttonDidClick:)]) {
        [_delegate periodTableViewCell:self buttonDidClick:button];
    }
}

#pragma mark - Setting
- (void)setCourseType:(CourseType)courseType
{
    _courseType = courseType;
    
    if (self.courseType == VideoCourse) {
        self.videoImageView.hidden = NO;
        self.timeTitleLabel.hidden = YES;
        self.timeLabel.hidden = YES;
    }else
    {
        self.videoImageView.hidden = YES;
        self.timeTitleLabel.hidden = NO;
        self.timeLabel.hidden = NO;
    }
}

- (void)setPeriodModel:(PeriodModel *)periodModel
{
    _periodModel = periodModel;
    
    self.indexLabel.text = [NSString stringWithFormat:@"课时%ld", _periodModel.index + 1];
    self.titleLabel.text = _periodModel.periodName;
    
    if (self.courseType == VideoCourse) {
        [self getVideoUrlWithVideoNo:_periodModel.periodVideo.videoNo];
    }else
    {
        NSString * date = _periodModel.periodLive.date;
        if ([date isEqualToString:@"EveryDay"]) {
            date = @"每天";
        }
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", date, _periodModel.periodLive.startTime, _periodModel.periodLive.endTime];
    }
}

#pragma mark - 获取视频URL
- (void)getVideoUrlWithVideoNo:(NSInteger)videoNo
{
    NSDictionary *parameters = @{
        @"periodVideoId": @(videoNo)
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/chapter/period/audit/video" success:^(id json) {
        if (SUCCESS) {
            self.videoImageView.image = [Tool getVideoPreViewImage:[NSURL URLWithString:json[@"data"]]];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        
    }];
}

@end
