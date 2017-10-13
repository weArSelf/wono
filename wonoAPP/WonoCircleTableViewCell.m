//
//  WonoCircleTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoCircleTableViewCell.h"
#import "BBFlashCtntLabel.h"

@interface WonoCircleTableViewCell ()

@property (nonatomic,strong) UIView *ConView;

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *mainImageView;
@property (nonatomic,strong) UIImageView *positionImageView;
@property (nonatomic,strong) BBFlashCtntLabel *positionLabel;
@property (nonatomic,strong) UILabel *answerCountLabel;
@property (nonatomic,strong) UIButton *answerBtn;




@end

@implementation WonoCircleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)prepareForReuse{
    [super prepareForReuse];
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
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beChange) name:@"markChange" object:nil];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)beChange{
    _changeMark = @"1";
}

-(void)layoutSubviews{
    
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


-(void)answerClick{
    NSLog(@"点击了我要回答");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_model.askId forKey:@"ID"];
    self.cellBlock(dic);
    
}

-(void)setModel:(WonoCircleModel *)model{
    
    _model = model;
    
    switch (model.type) {
        case 1:{
            _model.contentStr = @"";
            [self createType1];
//            [self creatSubViews];
            break;
        }
        case 2:{
            [self createType2];
            break;
        }

        case 3:{
            [self createType3];
            break;
        }

//        case 4:{
//            
//            break;
//        }

            
        default:{
            [self createType4];
            
            break;
        }
    }
    [self creatSubViews];
    
}

-(void)createType1{
    
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc]init];
    }
    _titleLabel.text = _model.titleStr;
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_ConView addSubview:_titleLabel];
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.text = _model.contentStr;
    _contentLabel.numberOfLines = 0;
    [_ConView addSubview:_contentLabel];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(10));
    }];

    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
    

    
}
-(void)createType2{
    
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc]init];
    }
    _titleLabel.text = _model.titleStr;
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_ConView addSubview:_titleLabel];
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.text = _model.contentStr;
    _contentLabel.numberOfLines = 0;
    [_ConView addSubview:_contentLabel];
    
    
    
    
    
    
    //    if(_mainImageView == nil){
    //        _mainImageView = [[UIImageView alloc]init];
    //    }
    //    UIImage *img = [UIImage imageNamed:@"沃农圈测试背景"];
    //    _mainImageView.image = img;
    //    _mainImageView.contentMode = UIViewContentModeScaleToFill;
    //    _mainImageView.backgroundColor = [UIColor orangeColor];
    //    [_ConView addSubview:_mainImageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(80)));
        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(10));
    }];
    //    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_titleLabel.mas_left);
    //        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
    //        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
    //        make.height.equalTo(@(HDAutoHeight(326)));
    //    }];
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}

-(void)reloadTitle{
    [_positionLabel reloadView];
}

-(void)creatSubViews{
    
    
    _positionLabel = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(0, 0, HDAutoWidth(400), HDAutoHeight(40))];
    _positionLabel.textColor = UIColorFromHex(0x727171);
    _positionLabel.text = _model.positionStr;
    _positionLabel.font = [UIFont systemFontOfSize:12];
    _positionLabel.speed = -1;
    [_ConView addSubview:_positionLabel];
    
    _answerCountLabel = [[UILabel alloc]init];
    
    int qwe = [_model.answerCount floatValue];
    NSString *Cstr = [NSString stringWithFormat:@"%d个回答",qwe];
    
    _answerCountLabel.text = Cstr;
    _answerCountLabel.textColor = UIColorFromHex(0x000000);
    _answerCountLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_answerCountLabel];
    
    _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_answerBtn setBackgroundImage:[UIImage imageNamed:@"我来回答"] forState:UIControlStateNormal];
//    [_answerBtn setTitle:@"我来回答" forState:UIControlStateNormal];
//    [_answerBtn setTitleColor:UIColorFromHex(0x000000) forState:UIControlStateNormal];
    [_answerBtn addTarget:self action:@selector(answerClick) forControlEvents:UIControlEventTouchUpInside];
    _answerBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
    
    [_ConView addSubview:_answerBtn];
    
//    [self layoutIfNeeded];
//    [self.ConView layoutIfNeeded];
    
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_positionImageView.mas_top);
        make.height.equalTo(@(HDAutoWidth(40)));
        make.width.equalTo(@(HDAutoWidth(400)));
        make.left.equalTo(_positionImageView.mas_right).offset(HDAutoWidth(10));
        
    }];
    [_answerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_positionImageView.mas_left);
        make.top.equalTo(_positionLabel.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(60)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
    [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_answerCountLabel.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(150)));
        make.height.equalTo(@(HDAutoHeight(60)));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
    }];
    
    if([_positionLabel.text isEqualToString:@"官方"]){
        
        _positionImageView.alpha = 0;
        _positionLabel.alpha = 0;
        UIImageView *realImageView = [[UIImageView alloc]init];
        realImageView.image = [UIImage imageNamed:@"官方消息"];
        realImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_ConView addSubview:realImageView];
        
        [realImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(HDAutoWidth(131.6)));
            make.height.equalTo(@(HDAutoHeight(42.8)));
            make.left.equalTo(_positionImageView.mas_left);
            make.top.equalTo(_positionImageView.mas_top);
        }];
        
    }
    
    
//    [_answerBtn layoutIfNeeded];
////    [self.ConView layoutIfNeeded];
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    borderLayer.bounds = CGRectMake(0, 0, HDAutoWidth(150), HDAutoHeight(50));//虚线框的大小
//    borderLayer.position = CGPointMake(CGRectGetMidX(_answerBtn.bounds),CGRectGetMidY(_answerBtn.bounds));//虚线框锚点
//    
//    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;//矩形路径
//    
//    
//    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];//虚线宽度
//    
//    //虚线边框
//    borderLayer.lineDashPattern = @[@5, @5];
//    //实线边框
//    //    borderLayer.lineDashPattern = nil;
//    borderLayer.fillColor = [UIColor clearColor].CGColor;
//    borderLayer.strokeColor = MainColor.CGColor;
//    borderLayer.cornerRadius = 5;
//    [_answerBtn.layer addSublayer:borderLayer];
}


-(void)createType3{
    
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc]init];
    }
    _titleLabel.text = _model.titleStr;
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_ConView addSubview:_titleLabel];
    
//    if(_contentLabel == nil){
//        _contentLabel = [[UILabel alloc]init];
//    }
//    _contentLabel.textColor = [UIColor grayColor];
//    _contentLabel.font = [UIFont systemFontOfSize:13];
//    _contentLabel.text = _model.contentStr;
//    _contentLabel.numberOfLines = 0;
//    [_ConView addSubview:_contentLabel];
    
    
    
    
    
    
    if(_mainImageView == nil){
        _mainImageView = [[UIImageView alloc]init];
    }
    NSString *ur = _model.imgUrl;
    NSURL *url = [NSURL URLWithString:ur];
    
    [_mainImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
//    UIImage *img = [UIImage imageNamed:@"沃农圈测试背景"];
//    _mainImageView.image = img;
    _mainImageView.contentMode = UIViewContentModeScaleToFill;
    _mainImageView.backgroundColor = [UIColor orangeColor];
    [_ConView addSubview:_mainImageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    
//    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_titleLabel.mas_left);
//        make.right.equalTo(_titleLabel.mas_right);
//        make.height.equalTo(@(HDAutoHeight(40)));
//        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(10));
//    }];
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(326)));
    }];
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_mainImageView.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}

-(void)createType4{
    
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc]init];
    }
    _titleLabel.text = _model.titleStr;
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_ConView addSubview:_titleLabel];
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.text = _model.contentStr;
    _contentLabel.numberOfLines = 0;
    [_ConView addSubview:_contentLabel];
    
    
    
    
    
    
    if(_mainImageView == nil){
        _mainImageView = [[UIImageView alloc]init];
    }
    NSString *ur = _model.imgUrl;
    NSURL *url = [NSURL URLWithString:ur];
    
    [_mainImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    //    UIImage *img = [UIImage imageNamed:@"沃农圈测试背景"];
    //    _mainImageView.image = img;
    _mainImageView.contentMode = UIViewContentModeScaleToFill;
    _mainImageView.backgroundColor = [UIColor orangeColor];
    [_ConView addSubview:_mainImageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(80)));
        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(10));
    }];
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(3);
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(326)));
    }];
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_mainImageView.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}

-(void)changeImg{
    
    [_answerBtn setImage:[UIImage imageNamed:@"取消收藏"] forState:UIControlStateNormal];
    
}

@end
