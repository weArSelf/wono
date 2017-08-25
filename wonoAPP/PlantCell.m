//
//  PlantCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/14.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PlantCell.h"

@interface PlantCell ()

@property(nonatomic,strong) UIView *ConView;
@property(nonatomic,strong) UIView *leftView;

@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UILabel *timeLabel;
//@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UILabel *numberLabel;

@property(nonatomic,strong) UILabel *typeContentLabel;

@end

//蔬菜>西红柿>小西红柿

@implementation PlantCell



//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatConView];
       
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self creatConView];
        [self createOtherContent];
    }
    return self;
}

-(void)creatConView{
    
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
        make.top.equalTo(self.mas_top).offset(HDAutoHeight(5));
        make.bottom.equalTo(self.mas_bottom).offset(-HDAutoHeight(5));
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    _leftView = [[UIView alloc]init];
    
    _leftView.frame = CGRectMake(0, 0, HDAutoWidth(20), HDAutoHeight(130));
    _leftView.backgroundColor = UIColorFromHex(0x4cb566);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_leftView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _leftView.bounds;
    maskLayer.path = maskPath.CGPath;
    _leftView.layer.mask = maskLayer;

    [_ConView addSubview:_leftView];
}

-(void)createOtherContent{

    _dateLabel = [[UILabel alloc]init];
    _dateLabel.text = @"昨天";
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    [self.ConView addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"09:45";
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.ConView addSubview:_timeLabel];
    
//    _headImageView = [[UIImageView alloc]init];
//    _headImageView.image = [UIImage imageNamed:@"我的"];
//    //设置内部image大小限制 添加圆角等 未完待续
//    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _headImageView.layer.masksToBounds = YES;
//    _headImageView.layer.cornerRadius = 22;
//    
//    [self.ConView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"黄瓜大棚-张毅";
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.ConView addSubview:_nameLabel];
    
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.text = @"种植";
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.font = [UIFont systemFontOfSize:14];
    [self.ConView addSubview:_typeLabel];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.text = @"-4500.00";
    _numberLabel.textColor = [UIColor redColor];
    _numberLabel.font = [UIFont systemFontOfSize:14];
    [self.ConView addSubview:_numberLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(30));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(26));
        make.width.equalTo(@(60));
        make.height.equalTo(@(HDAutoHeight(33)));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateLabel.mas_left);
        make.bottom.equalTo(_ConView.mas_bottom).offset(-HDAutoHeight(26));
        make.width.equalTo(@(60));
        make.height.equalTo(@(HDAutoHeight(33)));
    }];
//    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_timeLabel.mas_right);
//        make.centerY.equalTo(_ConView.mas_centerY);
//        make.width.equalTo(@(HDAutoWidth(64)));
//        make.height.equalTo(@(HDAutoWidth(64)));
//    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right).offset(10);
        make.centerY.equalTo(_dateLabel.mas_centerY);
        make.width.equalTo(@(150));
        make.height.equalTo(@(40));
    }];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.centerY.equalTo(_timeLabel.mas_centerY);
        make.width.equalTo(@(35));
        make.height.equalTo(@(40));
    }];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeLabel.mas_right).offset(10);
        make.centerY.equalTo(_typeLabel.mas_centerY);
        make.width.equalTo(@(100));
        make.height.equalTo(_typeLabel.mas_height);
    }];
    
    
    _typeContentLabel = [[UILabel alloc]init];
    _typeContentLabel.text = @"蔬菜>西红柿>小西红柿";
    _typeContentLabel.textColor = [UIColor grayColor];
    _typeContentLabel.font = [UIFont systemFontOfSize:11];
    _typeContentLabel.textAlignment = NSTextAlignmentRight;
    [self.ConView addSubview:_typeContentLabel];

    [_typeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.height.equalTo(_nameLabel.mas_height);
        make.width.equalTo(@(HDAutoWidth(400)));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
    }];
    
}



-(void)setLeftColor:(UIColor *)color{
    
    _leftView.backgroundColor = color;
    
}

-(void)setModel:(PlantModel *)model{
    _model = model;
    
    _dateLabel.text = model.dateStr;
    _timeLabel.text = model.timeStr;
    
    _nameLabel.text = model.nameStr;
    
    int a = [model.typeStr intValue];
    
    switch (a) {
        case 1:{
            _typeLabel.text = @"种植";
            break;
        }
        case 2:{
            _typeLabel.text = @"施肥";
            break;
        }
        case 3:{
            _typeLabel.text = @"植保";
            break;
        }
        case 4:{
            _typeLabel.text = @"采收";
            break;
        }
            
        default:
            break;
    }
    
//    NSString *str = [NSString stringWithFormat:@"%d",a];
    
    int b = [model.numberStr intValue];
    
   
    NSString *qwe = [NSString stringWithFormat:@"%d",b];
    
    _numberLabel.text = qwe;
    
    if(b<0){
        _numberLabel.textColor = [UIColor redColor];
    }else{
        _numberLabel.textColor = [UIColor grayColor];
    }
    if(a == 4){
        _numberLabel.textColor = MainColor;
    }
    _typeContentLabel.text = model.extraStr;
}

@end
