//
//  MyFarmTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MyFarmTableViewCell.h"


@interface MyFarmTableViewCell()

@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) UIView *whiteView;


@end


@implementation MyFarmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = UIColorFromHex(0xf7f8f8);
    
    
    
    return self;
}

-(void)createContentWithLeftStr:(NSString *)leftStr AndRightStr:(NSString *)rightStr{
    if(_leftLabel == nil){
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textColor = UIColorFromHex(0x9fa0a0);
        [self addSubview:_leftLabel];
    }
    NSString *resStr = [NSString stringWithFormat:@"%@:  %@",leftStr,rightStr];
    _leftLabel.text = resStr;
    if(_whiteView == nil){
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteView];
    }
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAutoWidth(32));
        make.width.equalTo(self.mas_width).offset(-HDAutoWidth(150));
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
    }];
    
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(1));
    }];
    
}

@end
