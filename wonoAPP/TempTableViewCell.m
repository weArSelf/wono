//
//  TempTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/24.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "TempTableViewCell.h"


@interface TempTableViewCell()

@property (nonatomic,strong) UIView *ConView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *nextTitleLabel;
@property (nonatomic,strong) UILabel *qiwenLabel;
@property (nonatomic,strong) UILabel *qishiLabel;
@property (nonatomic,strong) UILabel *diwenLabel;
@property (nonatomic,strong) UILabel *dishiLabel;
@property (nonatomic,strong) UILabel *leibieLabel;
@property (nonatomic,strong) UILabel *yuangongLabel;

@property (nonatomic,strong) UIImageView *headImageView;


@end


@implementation TempTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createContent];
        [self createTitle];
        [self createDetail];
        [self createImage];
    }
    return self;
}

-(void)createContent{
    
    _ConView = [[UIView alloc]init];
    _ConView.backgroundColor = [UIColor whiteColor];
    _ConView.layer.shadowColor = [UIColor blackColor].CGColor;
    _ConView.layer.shadowOpacity = 0.3f;
    _ConView.layer.shadowRadius =5;
    _ConView.layer.shadowOffset = CGSizeMake(5,5);
//    _ConView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _ConView.layer.borderWidth = 0.6;
    //    _ConView.layer.masksToBounds = YES;
    _ConView.layer.cornerRadius = 5;
    
    [self addSubview:_ConView];
    
    [_ConView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
}

-(void)createTitle{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"黄瓜大棚";
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [_ConView addSubview:_titleLabel];
    _nextTitleLabel = [[UILabel alloc]init];
    _nextTitleLabel.text = @"(TPCG092)";
    _nextTitleLabel.textColor = UIColorFromHex(0x9fa0a0);
    _nextTitleLabel.font = [UIFont systemFontOfSize:14];
    [_ConView addSubview:_nextTitleLabel];
    float width = [self getLengthWithFont:15 AndText:_titleLabel.text];
    float width2 = [self getLengthWithFont:15 AndText:_nextTitleLabel.text];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(15));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(15));
        make.width.equalTo(@(width));
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    [_nextTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(HDAutoWidth(5));
        make.width.equalTo(@(width2));
        make.bottom.equalTo(_titleLabel.mas_bottom);
    }];

}

-(float)getLengthWithFont:(int)font AndText:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:font]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}

-(void)createDetail{
    _qiwenLabel = [self reLabel:_qiwenLabel];
    _qiwenLabel.text = @"气温：20°C";
    _qishiLabel = [self reLabel:_qishiLabel];
    _qishiLabel.text = @"气湿：30%";
    _diwenLabel = [self AlreLabel:_diwenLabel];
    _diwenLabel.text = @"地温：35°C";
    _dishiLabel = [self reLabel:_diwenLabel];
    _dishiLabel.text = @"地湿：25%";
    _leibieLabel = [self CatreLabel:_leibieLabel];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"类别：黄瓜"];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:@"类别："];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x9fa0a0) range:range1];
    
    _leibieLabel.attributedText = hintString;
    _yuangongLabel = [self reLabel:_yuangongLabel];
    _yuangongLabel.text = @"员工：张毅";
    
    [_qiwenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(15));
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [_qishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_qiwenLabel.mas_right);
        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(15));
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [_diwenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_qiwenLabel.mas_bottom).offset(HDAutoHeight(5));
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [_dishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_qishiLabel.mas_left);
        make.top.equalTo(_diwenLabel.mas_top);
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [_leibieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_diwenLabel.mas_bottom).offset(HDAutoHeight(5));
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [_yuangongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_qishiLabel.mas_left);
        make.top.equalTo(_leibieLabel.mas_top);
        make.width.equalTo(@(HDAutoWidth(200)));
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    
}

-(UILabel *)reLabel:(UILabel *)label{
    label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x9fa0a0);
    [_ConView addSubview:label];
    return  label;
}
-(UILabel *)AlreLabel:(UILabel *)label{
    label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0xcd1d02);
    [_ConView addSubview:label];
    return  label;
}
-(UILabel *)CatreLabel:(UILabel *)label{
    label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x4db366);
    [_ConView addSubview:label];
    return  label;
}

-(void)createImage{
    _headImageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"1-预警"];
    
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    CGFloat fixelH = CGImageGetHeight(image.CGImage);
    
    _headImageView.image = image;
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_ConView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ConView.mas_right);
        make.top.equalTo(_ConView.mas_top);
        make.width.equalTo(@(HDAutoWidth(170)));
        make.height.equalTo(@(HDAutoWidth(170)*fixelH/fixelW));
    }];
    
}


@end
