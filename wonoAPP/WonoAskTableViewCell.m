//
//  WonoCircleTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoAskTableViewCell.h"
//#import "UIImageView+MHFacebookImageViewer.h"
#import "BBFlashCtntLabel.h"
#import "SDPhotoBrowser.h"

#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height


@interface WonoAskTableViewCell ()<SDPhotoBrowserDelegate>

@property (nonatomic,strong) UIView *ConView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *mainImageView;
@property (nonatomic,strong) UIImageView *positionImageView;
@property (nonatomic,strong) BBFlashCtntLabel *positionLabel;
@property (nonatomic,strong) UILabel *answerCountLabel;
@property (nonatomic,strong) UIButton *answerBtn;

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;



@end

@implementation WonoAskTableViewCell

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


-(void)answerClick{
    NSLog(@"点击了我要回答");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_model.askId forKey:@"ID"];
    self.cellBlock(dic);
    
}

-(void)setModel:(WonoAskModel *)model{
    
    _model = model;
    
    [self createHead];
    
    switch (model.type) {
        case 1:{
            _model.contentStr = @"";
            [self createType1];
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

-(void)createHead{

    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc]init];
    }
    _titleLabel.text = _model.titleStr;
    _titleLabel.textColor = UIColorFromHex(0x000000);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    [_ConView addSubview:_titleLabel];
    
    CGFloat height = [self getSpaceLabelHeight:_model.titleStr withFont:[UIFont systemFontOfSize:15] withWidth:(SCREEN_WIDTH-HDAutoWidth(40))];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(height));
    }];
    
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = HDAutoWidth(40);
    
    NSURL *url = [NSURL URLWithString:_model.headUrl];
    
    [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [_ConView addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(HDAutoHeight(15));
        make.width.equalTo(@(HDAutoWidth(80)));
        make.height.equalTo(@(HDAutoWidth(80)));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = _model.name;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = UIColorFromHex(0x000000);
    [_ConView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(HDAutoWidth(5));
        make.top.equalTo(_headImageView.mas_top);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(400)));
    }];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = _model.time;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = UIColorFromHex(0x727171);
    [_ConView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(HDAutoWidth(5));
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.width.equalTo(@(HDAutoWidth(400)));
    }];

    _sujjestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sujjestBtn setImage:[UIImage imageNamed:@"未点击点赞"] forState:UIControlStateNormal];
    
    
    int needInt = [_model.sujjestCount intValue];
    NSString *res = [NSString stringWithFormat:@"%d",needInt];
    
    [_sujjestBtn setTitle:res forState:UIControlStateNormal];
    _sujjestBtn.layer.masksToBounds = YES;
    _sujjestBtn.layer.borderWidth = 0.5;
    _sujjestBtn.layer.borderColor = MainColor.CGColor;
    _sujjestBtn.layer.cornerRadius = 5;
    [_sujjestBtn addTarget:self action:@selector(sujjestClick) forControlEvents:UIControlEventTouchUpInside];
    _sujjestBtn.imageEdgeInsets = UIEdgeInsetsMake(HDAutoHeight(0), HDAutoWidth(15), HDAutoHeight(0), HDAutoWidth(90));
    _sujjestBtn.titleEdgeInsets = UIEdgeInsetsMake(HDAutoHeight(5), -HDAutoWidth(20), HDAutoHeight(5), HDAutoWidth(5));
    _sujjestBtn.titleLabel.font = [UIFont systemFontOfSize:13];

    [_sujjestBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [_ConView addSubview:_sujjestBtn];
    [_sujjestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(25));
        make.centerY.equalTo(_headImageView.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(50)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
    _sujjestBtn.selected = NO;
    
    [self getPermission];
}

-(void)sujjestClick{
    NSLog(@"点击点赞");
    
    _sujjestBtn.enabled = NO;
    
    if(_sujjestBtn.selected == NO){
        _sujjestBtn.selected = YES;
        
        [[InterfaceSingleton shareInstance].interfaceModel MarkPointWithAction:@"1" AndQid:_model.askId WithCallBack:^(int state, id data, NSString *msg) {
           
            _sujjestBtn.enabled = YES;
            
        }];
        
        
        NSString *str = _sujjestBtn.titleLabel.text;
        int needint = [str intValue];
        needint++;
        NSString *res = [NSString stringWithFormat:@"%d",needint];
        
        [_sujjestBtn setImage:[UIImage imageNamed:@"点击点赞"] forState:UIControlStateNormal];
        [_sujjestBtn setTitle:res forState:UIControlStateNormal];
    }else{
        
        [[InterfaceSingleton shareInstance].interfaceModel MarkPointWithAction:@"2" AndQid:_model.askId WithCallBack:^(int state, id data, NSString *msg) {
            
            _sujjestBtn.enabled = YES;
            
        }];

        
        _sujjestBtn.selected = NO;
        
        NSString *str = _sujjestBtn.titleLabel.text;
        int needint = [str intValue];
        needint--;
        NSString *res = [NSString stringWithFormat:@"%d",needint];

        [_sujjestBtn setImage:[UIImage imageNamed:@"未点击点赞"] forState:UIControlStateNormal];
        [_sujjestBtn setTitle:res forState:UIControlStateNormal];
    }
    
    
}

-(void)getPermission{
    
    [[InterfaceSingleton shareInstance].interfaceModel getUserLikeWithQid:_model.askId WithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            NSDictionary *dic = data;
            int res = [dic[@"like"] intValue];
            if(res == 0){
                _sujjestBtn.selected = NO;
                [_sujjestBtn setImage:[UIImage imageNamed:@"未点击点赞"] forState:UIControlStateNormal];
            }else{
                _sujjestBtn.selected = YES;
                [_sujjestBtn setImage:[UIImage imageNamed:@"点击点赞"] forState:UIControlStateNormal];
            }
        }
        
    }];
}

-(void)createType1{
    
    
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
    

    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(40)));
        make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
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
-(void)createType2{
    
//    if(_titleLabel == nil){
//        _titleLabel = [[UILabel alloc]init];
//    }
//    _titleLabel.text = _model.titleStr;
//    _titleLabel.textColor = UIColorFromHex(0x000000);
//    _titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [_ConView addSubview:_titleLabel];
    
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
    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
//        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
//        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
//        make.height.equalTo(@(HDAutoHeight(50)));
//    }];
    
    CGFloat height = [self getSpaceLabelHeight:_model.contentStr withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)];
    
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.equalTo(@(height+HDAutoHeight(20)));
        make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
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
    
//    int qwe = [_model.answerCount floatValue];
//    NSString *Cstr = [NSString stringWithFormat:@"%d个回答",qwe];
    
    _answerCountLabel.text = @"您能回答这个问题吗？";
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
        make.width.equalTo(@(HDAutoWidth(400)));
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
}


-(void)createType3{
    
//    if(_titleLabel == nil){
//        _titleLabel = [[UILabel alloc]init];
//    }
//    _titleLabel.text = _model.titleStr;
//    _titleLabel.textColor = UIColorFromHex(0x000000);
//    _titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [_ConView addSubview:_titleLabel];
    
    //    if(_contentLabel == nil){
    //        _contentLabel = [[UILabel alloc]init];
    //    }
    //    _contentLabel.textColor = [UIColor grayColor];
    //    _contentLabel.font = [UIFont systemFontOfSize:13];
    //    _contentLabel.text = _model.contentStr;
    //    _contentLabel.numberOfLines = 0;
    //    [_ConView addSubview:_contentLabel];
    
    
//    [_headImageView layoutIfNeeded];
//    [_ConView layoutIfNeeded];
    [self layoutIfNeeded];
    
    CGRect frame1 = CGRectMake(HDAutoWidth(20), _headImageView.y+_headImageView.height+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame2 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3+HDAutoWidth(40), _headImageView.y+_headImageView.height+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame3 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3*2+HDAutoWidth(60), _headImageView.y+_headImageView.height+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    
    for (int i=0; i<_model.imageArr.count; i++) {
        NSString *urlStr = _model.imageArr[i];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        
        switch (i) {
            case 0:
                imageView.frame = frame1;
                break;
            case 1:
                imageView.frame = frame2;
                break;
            case 2:
                imageView.frame = frame3;
                break;
            default:
                break;
        }
        
        imageView.tag = 300+i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        [_ConView addSubview:imageView];
        
    }
    
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(170));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}


-(void)createType4{
    
//    if(_titleLabel == nil){
//        _titleLabel = [[UILabel alloc]init];
//    }
//    _titleLabel.text = _model.titleStr;
//    _titleLabel.textColor = UIColorFromHex(0x000000);
//    _titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [_ConView addSubview:_titleLabel];
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.text = _model.contentStr;
    _contentLabel.numberOfLines = 0;
    [_ConView addSubview:_contentLabel];
    
    
    
    CGFloat height = [self getSpaceLabelHeight:_model.contentStr withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)];
    
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.equalTo(@(height+HDAutoHeight(20)));
        make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
    }];
    
    
//    [_contentLabel layoutIfNeeded];
//    [_ConView layoutIfNeeded];
    [self layoutIfNeeded];
    
    CGRect frame1 = CGRectMake(HDAutoWidth(20), _contentLabel.y+_contentLabel.height+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame2 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3+HDAutoWidth(40), _contentLabel.y+_contentLabel.height+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame3 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3*2+HDAutoWidth(60), _contentLabel.y+_contentLabel.height+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    
    for (int i=0; i<_model.imageArr.count; i++) {
        NSString *urlStr = _model.imageArr[i];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        //        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        
        switch (i) {
            case 0:
                imageView.frame = frame1;
                break;
            case 1:
                imageView.frame = frame2;
                break;
            case 2:
                imageView.frame = frame3;
                break;
            default:
                break;
        }
        
        
        imageView.tag = 300+i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        
        [_ConView addSubview:imageView];
        
    }
    
   
    
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(170));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}


-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(void)imgTapClick:(UIGestureRecognizer *)ges{
    
    UIView *view = ges.view;
    NSInteger tap = view.tag;
    NSLog(@"%ld",tap);
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = _model.imageArr.count; // 图片总数
    browser.currentImageIndex = tap-300;
    browser.delegate = self;
    [browser show];
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    NSString *url2 = _model.imageArr[index];
    NSURL *url = [NSURL URLWithString:url2];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
    
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *url2 = _model.imageArr[index];
    NSURL *url = [NSURL URLWithString:url2];
    return url;
}


@end
