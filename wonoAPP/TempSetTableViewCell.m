//
//  TempSetTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/26.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "TempSetTableViewCell.h"


@interface TempSetTableViewCell()




@end


@implementation TempSetTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.backgroundColor = [UIColor greenColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createContent];
//        [self createModel];
        
        self.selectMark = NO;
//        [self creatSubViews];
    }
    return self;
}



-(void)createContent{
    
    _ConView = [[UIView alloc]init];
    _ConView.backgroundColor = [UIColor whiteColor];
//    _ConView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _ConView.layer.shadowOpacity = 0.3f;
//    _ConView.layer.shadowRadius =5;
//    _ConView.layer.shadowOffset = CGSizeMake(5,5);
    _ConView.layer.borderColor = MainColor.CGColor;
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



-(NSAttributedString *)attrWithStr:(NSString *)str{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [[attStr string]rangeOfString:@"气温"];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range];
    
    NSRange range2 = [[attStr string]rangeOfString:@"气湿"];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range2];
    
    NSRange range3 = [[attStr string]rangeOfString:@"地温"];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range3];
    
    NSRange range4 = [[attStr string]rangeOfString:@"地湿"];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:MainColor range:range4];
    
    return attStr;
}

-(void)createModel{
    
    UILabel *nameLabel = [self myLabel];
    nameLabel.text = _model.name;
    UILabel *label1 = [self myLabel2];
    
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@≤安全气温≤%@",_model.airMin,_model.airMax];
    NSString *str2 = [NSString stringWithFormat:@"%@≤安全地温≤%@",_model.landMin,_model.landMax];
    NSString *str3 = [NSString stringWithFormat:@"%@≤安全气湿≤%@",_model.air2Min,_model.air2Max];
    NSString *str4 = [NSString stringWithFormat:@"%@≤安全地湿≤%@",_model.land2Min,_model.land2Max];
    
    label1.attributedText =  [self attrWithStr:str];
    UILabel *label2 = [self myLabel2];
    label2.attributedText =  [self attrWithStr:str2];
    UILabel *label3 = [self myLabel2];
    label3.attributedText =  [self attrWithStr:str3];
    UILabel *label4 = [self myLabel2];
    label4.attributedText =  [self attrWithStr:str4];
    
    [_ConView addSubview:nameLabel];
    [_ConView addSubview:label1];
    [_ConView addSubview:label2];
    [_ConView addSubview:label3];
    [_ConView addSubview:label4];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(5));
        make.right.equalTo(_ConView.mas_centerX);
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(nameLabel.mas_bottom).offset(HDAutoHeight(5));
        make.right.equalTo(_ConView.mas_centerX);
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(HDAutoWidth(40));
        make.top.equalTo(label1.mas_top);
        make.right.equalTo(_ConView.mas_right);
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(label1.mas_bottom).offset(HDAutoHeight(5));
        make.right.equalTo(_ConView.mas_centerX);
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(HDAutoWidth(40));
        make.top.equalTo(label3.mas_top);
        make.right.equalTo(_ConView.mas_right);
        make.height.equalTo(@(HDAutoHeight(40)));
    }];
    
}

-(UILabel *)myLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x727171);
    return label;
}

-(UILabel *)myLabel2{
    UILabel * label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x727171);
    return label;
}

-(void)changeColor{
//    [_ConView removeFromSuperview];
//    [self layoutIfNeeded];
    _ConView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.selectMark = true;
}

-(void)changeBackColor{
    //    [_ConView removeFromSuperview];
    //    [self layoutIfNeeded];
    _ConView.layer.borderColor = MainColor.CGColor;
    self.selectMark = false;
    
}

-(void)setModel:(SetModel *)model{
    _model = model;
    
    [self createModel];
    
}


@end
