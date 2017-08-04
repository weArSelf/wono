//
//  WonoCircleTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoCircleTableViewCell.h"

@interface WonoCircleTableViewCell ()

@property (nonatomic,strong) UIView *ConView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *mainImageView;
@property (nonatomic,strong) UIImageView *positionImageView;
@property (nonatomic,strong) UILabel *positionLabel;
@property (nonatomic,strong) UILabel *answerCountLabel;
@property (nonatomic,strong) UIButton *answerBtn;



@end

@implementation WonoCircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createContent];
        [self creatSubViews];
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
    _ConView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ConView.layer.borderWidth = 0.6;
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
-(void)creatSubViews{
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"施用石灰氮需要注意那些问题？";
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_ConView addSubview:_titleLabel];
    
    _mainImageView = [[UIImageView alloc]init];
    UIImage *img = [UIImage imageNamed:@"沃农圈测试背景"];
    _mainImageView.image = img;
    _mainImageView.contentMode = UIViewContentModeScaleToFill;
    _mainImageView.backgroundColor = [UIColor orangeColor];
    [_ConView addSubview:_mainImageView];
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    _positionLabel = [[UILabel alloc]init];
    _positionLabel.textColor = UIColorFromHex(0x727171);
    _positionLabel.text = @"天津市 西青区 华苑产业园";
    _positionLabel.font = [UIFont systemFontOfSize:12];
    
    [_ConView addSubview:_positionLabel];
    
    _answerCountLabel = [[UILabel alloc]init];
    _answerCountLabel.text = @"10个回答";
    _answerCountLabel.textColor = UIColorFromHex(0x000000);
    _answerCountLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_answerCountLabel];
    
    _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_answerBtn setTitle:@"我来回答" forState:UIControlStateNormal];
    [_answerBtn setTitleColor:UIColorFromHex(0x000000) forState:UIControlStateNormal];
    [_answerBtn addTarget:self action:@selector(answerClick) forControlEvents:UIControlEventTouchUpInside];
    _answerBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
    
    [_ConView addSubview:_answerBtn];
    
    [self layoutIfNeeded];
    [self.ConView layoutIfNeeded];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(326)));
    }];
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_mainImageView.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_positionImageView.mas_centerY);
        make.height.equalTo(@(HDAutoWidth(40)));
        make.width.equalTo(@(_ConView.width*2/3));
        make.left.equalTo(_positionImageView.mas_right).offset(HDAutoWidth(10));
        
    }];
    [_answerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_positionImageView.mas_left);
        make.top.equalTo(_positionLabel.mas_bottom).offset(HDAutoHeight(10));
        make.bottom.equalTo(_ConView.mas_bottom).offset(-HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_positionImageView.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(150)));
        make.height.equalTo(@(HDAutoHeight(50)));
        make.right.equalTo(_mainImageView.mas_right);
    }];
    [self layoutIfNeeded];
    [self.ConView layoutIfNeeded];
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, _answerBtn.width, _answerBtn.height);//虚线框的大小
    borderLayer.position = CGPointMake(CGRectGetMidX(_answerBtn.bounds),CGRectGetMidY(_answerBtn.bounds));//虚线框锚点
    
    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;//矩形路径
    
    
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];//虚线宽度
    
    //虚线边框
    borderLayer.lineDashPattern = @[@5, @5];
    //实线边框
    //    borderLayer.lineDashPattern = nil;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = MainColor.CGColor;
    borderLayer.cornerRadius = 5;
    [_answerBtn.layer addSublayer:borderLayer];
}

-(void)answerClick{
    NSLog(@"点击了我要回答");
    
}

@end
