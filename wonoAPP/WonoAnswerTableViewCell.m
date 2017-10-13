//
//  WonoCircleTableViewCell.m
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoAnswerTableViewCell.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import <AVFoundation/AVFoundation.h>
#import "BBFlashCtntLabel.h"

#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height


@interface WonoAnswerTableViewCell ()

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

@property (nonatomic,strong) UIButton *audioBtn;
@property (nonatomic,strong) UILabel *audioLabel;

@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) AVAudioSession *session;



@end

@implementation WonoAnswerTableViewCell{
    NSData *data;
}

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
    [dic setObject:_model.answerId forKey:@"ID"];
    self.cellBlock(dic);
    
}
- (NSUInteger)durationWithVideo:(NSURL *)videoUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    
    return second;
}
-(void)reloadTitle{
//    _positionLabel.text = @"aaaaaaaaaaaaawwwwwwwwwwweeeeeeeeeeeeeddddddddd";
    [_positionLabel layoutIfNeeded];
//    _positionLabel.speed = -1;
    [_positionLabel reloadView];
}
-(void)setModel:(WonoAnswerModel *)model{
    
    _model = model;
    
//    if(![_model.audioUrl isEqualToString:@""]){
//        NSURL *url = [NSURL URLWithString:_model.audioUrl];
//        NSInteger leng = [self durationWithVideo:url];
//        _model.audioLength = [NSString stringWithFormat:@"%ld",(long)leng];
//    }
    if(model == nil){
        
        return;
        
    }
    
    [self createHead];
    
    switch (model.type) {
        case 1:{
//            _model.contentStr = @"";
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
            
        case 4:{
            [self createType4];
            break;
        }
        case 5:{
            [self createType5];
            break;
        }
        case 6:{
            [self createType6];
            break;
        }
            
            
        default:{
            [self createType7];
            
            break;
        }
    }
    [self creatSubViews];
    
    

}

-(void)createHead{
    
//    if(_titleLabel == nil){
//        _titleLabel = [[UILabel alloc]init];
//    }
//    _titleLabel.text = _model.titleStr;
//    _titleLabel.textColor = UIColorFromHex(0x000000);
//    _titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [_ConView addSubview:_titleLabel];
//    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
//        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(10));
//        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
//        make.height.equalTo(@(HDAutoHeight(50)));
//    }];
    
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = HDAutoWidth(40);
    
    NSURL *url = [NSURL URLWithString:_model.headUrl];
    
    [_headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [_ConView addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ConView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_ConView.mas_top).offset(HDAutoHeight(15));
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
        make.height.equalTo(@(HDAutoHeight(80)));
        make.width.equalTo(@(HDAutoWidth(400)));
    }];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = _model.time;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = UIColorFromHex(0x727171);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_ConView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(60));
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(80)));
        make.width.equalTo(@(HDAutoWidth(400)));
    }];
    
       
}



-(void)createType1{
    
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
    
    NSString *res;
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        
    }else{
        res = _model.contentStr;
    }
    _contentLabel.text = res;
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
    
    CGFloat height = [self getSpaceLabelHeight:res withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)];
    
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(height+HDAutoHeight(40)));
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
        make.left.equalTo(_headImageView.mas_left);
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
    
    
    _model.contentStr = @"";
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        NSString *res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        _contentLabel.text = res;
    }else{
        _contentLabel.text = _model.contentStr;
    }
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
    
    if([_model.replyName isEqualToString:@""]){
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(0.01));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];

    }else{
    
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }
    
    
    
    _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioBtn setBackgroundImage:[UIImage imageNamed:@"点击播放"] forState:UIControlStateNormal];
    [_audioBtn addTarget:self action:@selector(audioClick) forControlEvents:UIControlEventTouchUpInside];
    [_ConView addSubview:_audioBtn];
    _audioLabel = [[UILabel alloc]init];
    _audioLabel.text = [NSString stringWithFormat:@"%@'",_model.audioLength];
    _audioLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_audioLabel];
    
    [_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.width.equalTo(@(HDAutoWidth(227)));
        make.height.equalTo(@(HDAutoHeight(50)));
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(5));
    }];
    
    [_audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_audioBtn.mas_right).offset(HDAutoWidth(5));
        make.top.equalTo(_audioBtn.mas_top);
        make.bottom.equalTo(_audioBtn.mas_bottom);
        make.width.equalTo(@(HDAutoWidth(300)));
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
        make.left.equalTo(_headImageView.mas_left);
        make.top.equalTo(_audioBtn.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}

-(void)audioClick{
    NSLog(@"点击音频");
    
    if(_audioBlo){
        
        _audioBlo(_model.audioUrl);
        
    }
    
    

    
    
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
    
    
    _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_answerBtn setTitle:@"回复" forState:UIControlStateNormal];
    [_answerBtn setTitleColor:UIColorFromHex(0x000000) forState:UIControlStateNormal];
    [_answerBtn addTarget:self action:@selector(answerClick) forControlEvents:UIControlEventTouchUpInside];
    _answerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    [_ConView addSubview:_answerBtn];
    
    [self layoutIfNeeded];
    [self.ConView layoutIfNeeded];
    
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_positionImageView.mas_centerY);
        make.height.equalTo(@(HDAutoWidth(40)));
        make.width.equalTo(@(_ConView.width*2/3));
        make.left.equalTo(_positionImageView.mas_right).offset(HDAutoWidth(10));
        
    }];
    
    if([_positionLabel.text isEqualToString:@"官方"]){
        [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_positionLabel.mas_centerY).offset(HDAutoHeight(8));
            make.width.equalTo(@(HDAutoWidth(150)));
            make.height.equalTo(@(HDAutoHeight(50)));
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        }];
    }else{
        [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_positionLabel.mas_centerY);
            make.width.equalTo(@(HDAutoWidth(150)));
            make.height.equalTo(@(HDAutoHeight(50)));
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
        }];
    }
    
    
//    [self layoutIfNeeded];
//    [self.ConView layoutIfNeeded];
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    borderLayer.bounds = CGRectMake(0, 0, _answerBtn.width, _answerBtn.height);//虚线框的大小
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
    
    
    _model.contentStr = @"";
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        NSString *res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        _contentLabel.text = res;
    }else{
        _contentLabel.text = _model.contentStr;
    }
    _contentLabel.numberOfLines = 0;
    [_ConView addSubview:_contentLabel];

    
    
    CGFloat height = [self getSpaceLabelHeight:_model.contentStr withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)];
    
    if([_model.replyName isEqualToString:@""]){
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(0.01));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }else{
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }

    
    
    [_contentLabel layoutIfNeeded];
    [_headImageView layoutIfNeeded];
    [_ConView layoutIfNeeded];
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
        [imageView setupImageViewer];
        [_ConView addSubview:imageView];
        
    }
    
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(170));
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
    
    //    if(_contentLabel == nil){
    //        _contentLabel = [[UILabel alloc]init];
    //    }
    //    _contentLabel.textColor = [UIColor grayColor];
    //    _contentLabel.font = [UIFont systemFontOfSize:13];
    //    _contentLabel.text = _model.contentStr;
    //    _contentLabel.numberOfLines = 0;
    //    [_ConView addSubview:_contentLabel];
    
    
//    _model.contentStr = @"";
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        NSString *res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        _contentLabel.text = res;
    }else{
        _contentLabel.text = _model.contentStr;
    }
    _contentLabel.numberOfLines = 0;
    [_ConView addSubview:_contentLabel];
    
    
    
    CGFloat height = [self getSpaceLabelHeight:_model.contentStr withFont:[UIFont systemFontOfSize:13] withWidth:SCREEN_WIDTH - HDAutoWidth(80)];
    
    if([_model.replyName isEqualToString:@""]){
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }else{
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }
    
    
    
    [_contentLabel layoutIfNeeded];
    [_headImageView layoutIfNeeded];
    [_ConView layoutIfNeeded];
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
        [imageView setupImageViewer];
        [_ConView addSubview:imageView];
        
    }
    
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(170));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}
-(void)createType5{
    
    //    if(_titleLabel == nil){
    //        _titleLabel = [[UILabel alloc]init];
    //    }
    //    _titleLabel.text = _model.titleStr;
    //    _titleLabel.textColor = UIColorFromHex(0x000000);
    //    _titleLabel.font = [UIFont systemFontOfSize:15];
    //
    //    [_ConView addSubview:_titleLabel];
    
    
//    _model.contentStr = @"";
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        NSString *res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        _contentLabel.text = res;
    }else{
        _contentLabel.text = _model.contentStr;
    }
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
    
    if([_model.replyName isEqualToString:@""]){
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }else{
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }
    
    
    
    _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioBtn setBackgroundImage:[UIImage imageNamed:@"点击播放"] forState:UIControlStateNormal];
    [_audioBtn addTarget:self action:@selector(audioClick) forControlEvents:UIControlEventTouchUpInside];
    [_ConView addSubview:_audioBtn];
    _audioLabel = [[UILabel alloc]init];
    _audioLabel.text = [NSString stringWithFormat:@"%@'",_model.audioLength];
    _audioLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_audioLabel];
    
    [_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.width.equalTo(@(HDAutoWidth(227)));
        make.height.equalTo(@(HDAutoHeight(50)));
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(5));
    }];
    
    [_audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_audioBtn.mas_right).offset(HDAutoWidth(5));
        make.top.equalTo(_audioBtn.mas_top);
        make.bottom.equalTo(_audioBtn.mas_bottom);
        make.width.equalTo(@(HDAutoWidth(300)));
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
        make.left.equalTo(_headImageView.mas_left);
        make.top.equalTo(_audioBtn.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}




-(void)createType6{
    
    //    if(_titleLabel == nil){
    //        _titleLabel = [[UILabel alloc]init];
    //    }
    //    _titleLabel.text = _model.titleStr;
    //    _titleLabel.textColor = UIColorFromHex(0x000000);
    //    _titleLabel.font = [UIFont systemFontOfSize:15];
    //
    //    [_ConView addSubview:_titleLabel];
    
    
    _model.contentStr = @"";
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        NSString *res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        _contentLabel.text = res;
    }else{
        _contentLabel.text = _model.contentStr;
    }
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
    
    if([_model.replyName isEqualToString:@""]){
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(0.01));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }else{
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }
    
    
    
    _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioBtn setBackgroundImage:[UIImage imageNamed:@"点击播放"] forState:UIControlStateNormal];
    [_audioBtn addTarget:self action:@selector(audioClick) forControlEvents:UIControlEventTouchUpInside];
    [_ConView addSubview:_audioBtn];
    _audioLabel = [[UILabel alloc]init];
    _audioLabel.text = [NSString stringWithFormat:@"%@'",_model.audioLength];
    _audioLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_audioLabel];
    
    [_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.width.equalTo(@(HDAutoWidth(227)));
        make.height.equalTo(@(HDAutoHeight(50)));
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(5));
    }];
    
    [_audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_audioBtn.mas_right).offset(HDAutoWidth(5));
        make.top.equalTo(_audioBtn.mas_top);
        make.bottom.equalTo(_audioBtn.mas_bottom);
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    //    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_titleLabel.mas_left);
    //        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
    //        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
    //        make.height.equalTo(@(HDAutoHeight(326)));
    //    }];
    
    [_audioLabel layoutIfNeeded];
    [_headImageView layoutIfNeeded];
    [_ConView layoutIfNeeded];
    [self layoutIfNeeded];
    
    
    CGRect frame1 = CGRectMake(HDAutoWidth(20), _audioLabel.y+_audioLabel.height+HDAutoHeight(10)+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame2 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3+HDAutoWidth(40), _audioLabel.y+_audioLabel.height+HDAutoHeight(10)+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame3 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3*2+HDAutoWidth(60), _audioLabel.y+_audioLabel.height+HDAutoHeight(10)+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    
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
        [imageView setupImageViewer];
        [_ConView addSubview:imageView];
        
    }

    
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.top.equalTo(_audioLabel.mas_bottom).offset(HDAutoHeight(185));
        make.width.equalTo(@(HDAutoWidth(30)));
        make.height.equalTo(@(HDAutoWidth(30)));
    }];
}


-(void)createType7{
    
    //    if(_titleLabel == nil){
    //        _titleLabel = [[UILabel alloc]init];
    //    }
    //    _titleLabel.text = _model.titleStr;
    //    _titleLabel.textColor = UIColorFromHex(0x000000);
    //    _titleLabel.font = [UIFont systemFontOfSize:15];
    //
    //    [_ConView addSubview:_titleLabel];
    
    
//    _model.contentStr = @"";
    
    if(_contentLabel == nil){
        _contentLabel = [[UILabel alloc]init];
    }
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    if(![_model.replyName isEqualToString:@""]){
        //        NSString *conS = _model.contentStr;
        NSString *res = [NSString stringWithFormat:@"回复@%@:  %@",_model.replyName,_model.contentStr];
        _contentLabel.text = res;
    }else{
        _contentLabel.text = _model.contentStr;
    }
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
    
    if([_model.replyName isEqualToString:@""]){
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }else{
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_left);
            make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
            make.height.equalTo(@(height+HDAutoHeight(40)));
            make.top.equalTo(_headImageView.mas_bottom).offset(HDAutoHeight(10));
        }];
        
    }
    
    
    
    _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_audioBtn setBackgroundImage:[UIImage imageNamed:@"点击播放"] forState:UIControlStateNormal];
    [_audioBtn addTarget:self action:@selector(audioClick) forControlEvents:UIControlEventTouchUpInside];
    [_ConView addSubview:_audioBtn];
    _audioLabel = [[UILabel alloc]init];
    _audioLabel.text = [NSString stringWithFormat:@"%@'",_model.audioLength];
    _audioLabel.font = [UIFont systemFontOfSize:13];
    [_ConView addSubview:_audioLabel];
    
    [_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.width.equalTo(@(HDAutoWidth(227)));
        make.height.equalTo(@(HDAutoHeight(50)));
        make.top.equalTo(_contentLabel.mas_bottom).offset(HDAutoHeight(5));
    }];
    
    [_audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_audioBtn.mas_right).offset(HDAutoWidth(5));
        make.top.equalTo(_audioBtn.mas_top);
        make.bottom.equalTo(_audioBtn.mas_bottom);
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    //    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_titleLabel.mas_left);
    //        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
    //        make.right.equalTo(_ConView.mas_right).offset(-HDAutoWidth(20));
    //        make.height.equalTo(@(HDAutoHeight(326)));
    //    }];
    
    [_audioLabel layoutIfNeeded];
    [_headImageView layoutIfNeeded];
    [_ConView layoutIfNeeded];
    [self layoutIfNeeded];
    
    
    CGRect frame1 = CGRectMake(HDAutoWidth(20), _audioLabel.y+_audioLabel.height+HDAutoHeight(10)+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame2 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3+HDAutoWidth(40), _audioLabel.y+_audioLabel.height+HDAutoHeight(10)+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    CGRect frame3 = CGRectMake((SCREEN_WIDTH-HDAutoWidth(120))/3*2+HDAutoWidth(60), _audioLabel.y+_audioLabel.height+HDAutoHeight(10)+HDAutoHeight(10), (SCREEN_WIDTH-HDAutoWidth(120))/3, HDAutoHeight(140));
    
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
        [imageView setupImageViewer];
        [_ConView addSubview:imageView];
        
    }
    
    
    
    
    _positionImageView = [[UIImageView alloc]init];
    _positionImageView.image = [UIImage imageNamed:@"地点"];
    _positionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_ConView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_left);
        make.top.equalTo(_audioLabel.mas_bottom).offset(HDAutoHeight(185));
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



@end
