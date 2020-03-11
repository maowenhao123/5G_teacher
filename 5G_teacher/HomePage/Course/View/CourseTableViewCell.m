//
//  CourseTableViewCell.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/5.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseTableViewCell.h"

@interface CourseTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CourseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:_courseModel.courseLogo] placeholderImage:[UIImage imageNamed:@""]];
    
    NSString *tag = @"";
    if (_courseModel.courseType == 1) {
        tag = @"视频课";
    }else if (_courseModel.courseType == 2)
    {
        tag = @"公开课";
    }else if (_courseModel.courseType == 3)
    {
        tag = @"一对一";
    }
    NSString *titleString = [NSString stringWithFormat:@" %@", _courseModel.courseName];
    NSMutableAttributedString *nameAttStr = [[NSMutableAttributedString alloc] initWithString:titleString];
    if (!MStringIsEmpty(tag)) {
        int scale = 3;
        UILabel * tagLabel = [UILabel new];
        tagLabel.text = tag;
        tagLabel.font = [UIFont boldSystemFontOfSize:12 * scale];
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.backgroundColor = MDefaultColor;
        tagLabel.clipsToBounds = YES;
        tagLabel.layer.cornerRadius = 9 * scale;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        CGSize tagLabelSize = [tagLabel sizeThatFits:CGSizeMake(MScreenWidth, MScreenHeight)];
        tagLabel.frame = CGRectMake(0, 0, tagLabelSize.width + 10 * scale, 18 * scale);
        UIImage *image = [self imageWithUIView:tagLabel];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, tagLabelSize.width / 3 + 10, 18);
        attach.image = image;
        NSAttributedString * imageAttStr = [NSAttributedString attributedStringWithAttachment:attach];
        [nameAttStr insertAttributedString:imageAttStr atIndex:0];
    }
    self.nameLabel.attributedText = nameAttStr;
    
    self.statusLabel.text = [NSString stringWithFormat:@"浏览量%ld 购买量%ld", _courseModel.courseOriginal, _courseModel.courseOriginal];
    self.timeLabel.text = [NSString stringWithFormat:@"发布日期%@", _courseModel.gmtCreate];
}

//view转成image
- (UIImage *)imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


@end
