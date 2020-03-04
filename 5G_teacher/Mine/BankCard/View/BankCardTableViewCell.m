//
//  BankCardTableViewCell.m
//  5G_teacher
//
//  Created by 毛文豪 on 2020/2/13.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "BankCardTableViewCell.h"

@interface BankCardTableViewCell ()

@property (nonatomic, weak) UIView * backView;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UILabel *bankLabel;
@property (nonatomic, weak) UILabel *cardTypeLabel;
@property (nonatomic, weak) UILabel *cardLabel;

@end

@implementation BankCardTableViewCell

+ (BankCardTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BankCardTableViewCellId";
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[BankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = MBackgroundColor;
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    //背景
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(MMargin, MMargin, MScreenWidth - 2 * MMargin, 100)];
    self.backView = backView;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4;
    [self.contentView addSubview:backView];
    
    //logo
    CGFloat logoWH = 50;
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MMargin, 20, logoWH, logoWH)];
    self.logoImageView = logoImageView;
    [backView addSubview:logoImageView];
    
    CGFloat labelX = CGRectGetMaxX(logoImageView.frame) + 7;
    CGFloat labelW = MScreenWidth - MMargin - labelX;
    //银行
    UILabel * bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 15, labelW, 25)];
    self.bankLabel = bankLabel;
    bankLabel.font = [UIFont boldSystemFontOfSize:16];
    bankLabel.textColor = [UIColor whiteColor];
    [backView addSubview: bankLabel];
    
    //银行卡类型
    UILabel * cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 40, labelW, 20)];
    self.cardTypeLabel = cardTypeLabel;
    cardTypeLabel.font = [UIFont systemFontOfSize:13];
    cardTypeLabel.textColor = [UIColor whiteColor];
    [backView addSubview: cardTypeLabel];
    
    //银行卡号
    UILabel * cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 67, labelW, 20)];
    self.cardLabel = cardLabel;
    cardLabel.font = [UIFont boldSystemFontOfSize:16];
    cardLabel.textColor = [UIColor whiteColor];
    [backView addSubview:cardLabel];
}

- (void)setModel:(BankCardModel *)model
{
    _model = model;
    if ([UIImage imageNamed:_model.bankName]) {
        self.logoImageView.image = [UIImage imageNamed:_model.bankName];
    }else
    {
        self.logoImageView.image = [UIImage imageNamed:@"其他银行"];
    }
    self.bankLabel.text = _model.bankName;
    self.cardLabel.text = _model.bankCardNo;
    self.cardTypeLabel.text = _model.bankBranchName;
    
    //设置背景颜色
    if ([_model.bankName isEqualToString:@"中国建设银行"]) {
        self.backView.backgroundColor = MColor(85, 132, 222, 1);
    }else if ([_model.bankName isEqualToString:@"中国工商银行"])
    {
        self.backView.backgroundColor = MColor(251, 100, 151, 1);
    }else if ([_model.bankName isEqualToString:@"招商银行"])
    {
        self.backView.backgroundColor = MColor(236, 75, 65, 1);
    }else if ([_model.bankName isEqualToString:@"中国银行"])
    {
        self.backView.backgroundColor = MColor(208, 48, 42, 1);
    }else if ([_model.bankName isEqualToString:@"中国农业银行"])
    {
        self.backView.backgroundColor = MColor(23, 166, 146, 1);
    }else//其他银行
    {
        self.backView.backgroundColor = MColor(166, 202, 228, 1);
    }
}


@end
