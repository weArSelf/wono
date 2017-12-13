//
//  StaticChangeView.m
//  wonoAPP
//
//  Created by IF on 2017/11/20.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "StaticChangeView.h"
#import "BBFlashCtntLabel.h"
#import "UIColor+Hex.h"

#import "UIButton+EnlargeTouchArea.h"


@interface StaticChangeView ()

@property (nonatomic,strong) UIScrollView *headScrlView;

@property (nonatomic,strong) UILabel *yueLabel;

@property (nonatomic,strong) UIImageView *shouruImgView;
@property (nonatomic,strong) UIView *shouruView;
@property (nonatomic,strong) UILabel *shourumiaoshuLabel;


@property (nonatomic,strong) UIImageView *zhichuImageView;
@property (nonatomic,strong) UIView *zhichuView;
@property (nonatomic,strong) UILabel *zhichumiaoshuLabel;



//@property (nonatomic,strong) UIView *rewardDetailView;

//@property (nonatomic,strong) UIView *secondView;

@property (nonatomic,strong) UIView *model4View;
@property (nonatomic,strong) UIView *model5View;
@property (nonatomic,strong) UIView *model6View;

@end


@implementation StaticChangeView{
    
    float height1;
    
    float heightOrgin;
    float height2;
    
    UIView *botbotView;
    
    NSDictionary *circleData;
    NSDictionary *total;
    NSDictionary *yuenian;
    NSDictionary *yuenian2;
    
    NSMutableArray *bbArrays;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setModel:(NSMutableDictionary *)model{
    
    bbArrays = [NSMutableArray array];
    
    _model = model;
    circleData = [NSDictionary dictionary];
    total = [NSDictionary dictionary];
    yuenian = [NSDictionary dictionary];
    yuenian2 = [NSDictionary dictionary];
    
    circleData = [_model objectForKey:@"circleData"];
    total = [_model objectForKey:@"total"];
    yuenian = [_model objectForKey:@"yuenian"];
    yuenian2 = [_model objectForKey:@"yuenian2"];
    
    
    [self createModel1];
    
}


-(void)createModel1{
    NSArray *inArr;
    NSArray *outArr;
    @try {
        inArr = yuenian[@"in"];
        outArr = yuenian[@"out"];
    } @catch (NSException *exception) {
        inArr = [NSMutableArray array];
        outArr = [NSMutableArray array];
    } @finally {
        
    }
    
    long int resin = 0;
    long int resout = 0;
    for (int i=0; i<inArr.count; i++) {
        NSDictionary *dic = inArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resin +=res;
    }
    
    for (int i=0; i<outArr.count; i++) {
        NSDictionary *dic = outArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resout +=res;
    }
//    resout = -resout;
    long int total = resin + resout;
    
    float shouruLength = HDAutoWidth(400)*(float)resin/total;
    float zhichuLength = HDAutoWidth(400)*(float)resout/total;
    if(isnan(shouruLength)){
        shouruLength = 0.0;
    }
    if(isnan(zhichuLength)){
        zhichuLength = 0.0;
    }
    
    NSString *shouruText;
    NSString *zhichuText;

    if(resin<10000){
        shouruText = [NSString stringWithFormat:@"%ld元",resin];
    }else{
        if(resin<100000000){
            shouruText = [NSString stringWithFormat:@"%.1f万元",(float)resin/10000];
        }else{
            shouruText = [NSString stringWithFormat:@"%.1f亿",(float)resin/100000000];
        }
        
    }
    if(resout<10000){
        zhichuText = [NSString stringWithFormat:@"%ld元",resout];
    }else{
        if(resout<100000000){
            zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)resout/10000];
        }else{
            zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)resout/100000000];
        }
    }
    
    
    
    
    _headScrlView = [[UIScrollView alloc]init];
    _headScrlView.backgroundColor = [UIColor clearColor];
    _headScrlView.showsVerticalScrollIndicator = NO;
    _headScrlView.showsHorizontalScrollIndicator = NO;
    _headScrlView.pagingEnabled = YES;
    _headScrlView.scrollEnabled = NO;
    
    [self addSubview:_headScrlView];
    //    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, <#CGFloat height#>)
    
    _yueLabel = [self myLabel2];
    _yueLabel.text = @"当月总收入与支出";
    //    _yueLabel.textAlignment = NSTextAlignmentCenter;
    
    _yueLabel.textColor = [UIColor blackColor];
    
    _yueLabel.frame = CGRectMake(HDAutoWidth(20),0, SCREEN_WIDTH, HDAutoHeight(60));
//    _yueLabel.speed = -1;
    [_headScrlView addSubview:_yueLabel];
    _shouruImgView = [self myImageView];
    //    _shouruImgView.layer.cornerRadius = HDAutoWidth(20);
    [_shouruImgView setImage:[UIImage imageNamed:@"收入"]];
    [_headScrlView addSubview:_shouruImgView];
    
    _shouruView = [self myView];
    _shouruView.backgroundColor = UIColorFromHex(0x64a3d9);
    [_headScrlView addSubview:_shouruView];
    
    _shourumiaoshuLabel = [self myLabel2];
    _shourumiaoshuLabel.text = shouruText;
    [_headScrlView addSubview:_shourumiaoshuLabel];
    
    //fb589b
    _zhichuImageView = [self myImageView];
    //    _zhichuImageView.layer.cornerRadius = HDAutoWidth(20);
    [_zhichuImageView setImage:[UIImage imageNamed:@"支出"]];
    [_headScrlView addSubview:_zhichuImageView];
    
    _zhichuView = [self myView];
    _zhichuView.backgroundColor = UIColorFromHex(0xf6a901);
    [_headScrlView addSubview:_zhichuView];
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    [_headScrlView addSubview:botView];
    
    _zhichumiaoshuLabel = [self myLabel2];
    _zhichumiaoshuLabel.text = zhichuText;
    [_headScrlView addSubview:_zhichumiaoshuLabel];
    
    
    
    [_shouruImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headScrlView.mas_left).offset(HDAutoWidth(20));
        make.height.width.equalTo(@(HDAutoWidth(75)));
        make.top.equalTo(_yueLabel.mas_bottom).offset(HDAutoHeight(30));
    }];
    [_shouruView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shouruImgView.mas_right).offset(HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(55)));
        make.centerY.equalTo(_shouruImgView.mas_centerY);
        make.width.equalTo(@(shouruLength));
    }];
    
    [_shourumiaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shouruView.mas_right).offset(HDAutoWidth(5));
        make.height.equalTo(_shouruImgView.mas_height);
        make.centerY.equalTo(_shouruImgView.mas_centerY);
        make.right.equalTo(@(SCREEN_WIDTH));
    }];
    
    
    [_zhichuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headScrlView.mas_left).offset(HDAutoWidth(20));
        make.height.width.equalTo(@(HDAutoWidth(75)));
        make.top.equalTo(_shouruImgView.mas_bottom).offset(HDAutoHeight(30));
    }];
    [_zhichuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shouruImgView.mas_right).offset(HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(55)));
        make.centerY.equalTo(_zhichuImageView.mas_centerY);
        make.width.equalTo(@(zhichuLength));
    }];
    
    [_zhichumiaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_zhichuView.mas_right).offset(HDAutoWidth(5));
        make.height.equalTo(_zhichuImageView.mas_height);
        make.centerY.equalTo(_zhichuImageView.mas_centerY);
        make.right.equalTo(@(SCREEN_WIDTH));
    }];
    
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(1));
        make.top.equalTo(_zhichuImageView.mas_bottom).offset(HDAutoHeight(30));
    }];
    
    [self layoutIfNeeded];
//    _shourumiaoshuLabel.speed = -1;
//    _zhichumiaoshuLabel.speed = -1;
    
    height1 = botView.bottom +HDAutoHeight(10);
    //
    height2 = height1;
    
    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    
    [self createModel10];
    [self createMode2];
    
}

-(void)createMode2{
    
    NSArray *inArr;
    @try {
        inArr = yuenian[@"in"];
    } @catch (NSException *exception) {
        inArr = [NSMutableArray array];
    } @finally {
        
    }
    long int resin = 0;
    for (int i=0; i<inArr.count; i++) {
        NSDictionary *dic = inArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resin +=res;
    }
    
    
    BBFlashCtntLabel *headLabel = [self myLabel];
    
    [bbArrays addObject:headLabel];
    
    headLabel.text = @"各项收入与支出";
    headLabel.textColor = [UIColor blackColor];
    headLabel.frame = CGRectMake(HDAutoWidth(20), height1 + HDAutoHeight(10), SCREEN_WIDTH, HDAutoHeight(60));
    headLabel.speed = -1;
    [_headScrlView addSubview:headLabel];
    
    
    UIImageView *shouruImageView = [self myImageView];
    [shouruImageView setImage:[UIImage imageNamed:@"收入"]];
    //    [shouruImageView addSubview:_shouruImgView];
    [_headScrlView addSubview:shouruImageView];
    shouruImageView.frame = CGRectMake(HDAutoWidth(20), headLabel.bottom+HDAutoHeight(30), HDAutoWidth(75), HDAutoWidth(75));
    
    float bot = 0.0;
    
    for (int i=0; i<inArr.count; i++) {
        NSDictionary *dic = inArr[i];
        
        BBFlashCtntLabel *label = [self myLabel];
        [bbArrays addObject:label];
        label.text = dic[@"variety_name"];
        NSString *nowCountStr = dic[@"total_amount"];
        int nowCount = [nowCountStr intValue];
        float needLength = inArr.count * HDAutoWidth(100)*(float)nowCount/resin;
        if(isnan(needLength)){
            needLength = 0.0;
        }
        
        if(IS_IPHONE_5){
            label.frame = CGRectMake(HDAutoWidth(110), headLabel.bottom+HDAutoHeight(30) +i*(HDAutoHeight(75)), HDAutoHeight(100), HDAutoHeight(75));
        }else{
            label.frame = CGRectMake(HDAutoWidth(110), headLabel.bottom+HDAutoHeight(30) +i*(HDAutoHeight(75)), HDAutoHeight(85), HDAutoHeight(75));
        }
        label.speed = -1;
        
        
        UIColor *color = [UIColor colorWithHexString:dic[@"color"]];
        
        UIView *view = [self myView];
        view.backgroundColor = color;
        view.frame = CGRectMake(label.right + HDAutoWidth(20), label.top + HDAutoHeight(10), needLength, HDAutoHeight(55));
        
        NSString * totalStr = dic[@"total_amount"];
        long int re = [totalStr intValue];
        
        NSString *zhichuText;
        
        if(re<10000){
            zhichuText = [NSString stringWithFormat:@"%ld元",re];
        }else{
            if(re<100000000){
                zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)re/10000];
            }else{
                zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)re/100000000];
            }
        }
        
        BBFlashCtntLabel *detailLabel = [self myLabel];
        [bbArrays addObject:detailLabel];
        detailLabel.text = zhichuText;
        detailLabel.frame = CGRectMake(view.right +HDAutoWidth(15), label.top, HDAutoWidth(250), HDAutoHeight(75));
        detailLabel.speed = -1;
        
        
        [_headScrlView addSubview:label];
        [_headScrlView addSubview:view];
        [_headScrlView addSubview:detailLabel];
        
        bot = view.bottom;
    }
    if(inArr.count == 0){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, headLabel.bottom+HDAutoHeight(30), SCREEN_WIDTH, HDAutoHeight(100));
        
        [_headScrlView addSubview:label];
        bot = label.bottom;
    }
    
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    botView.frame = CGRectMake(HDAutoWidth(40), bot +HDAutoHeight(50), SCREEN_WIDTH-HDAutoWidth(80), 1);
    [_headScrlView addSubview:botView];
    
    if(!IS_IPHONE_5){
        height1 = botView.bottom +HDAutoHeight(10);
    }else{
        height1 = botView.bottom +HDAutoHeight(50);
    }
    
    
    
    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    
    
    
    [self createModel3];
    
}

-(void)createModel3{
    
    NSArray *outArr;
    @try {
        outArr = yuenian[@"out"];
    } @catch (NSException *exception) {
        outArr = [NSMutableArray array];
    } @finally {
        
    }
    
    long int resin = 0;
    for (int i=0; i<outArr.count; i++) {
        NSDictionary *dic = outArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resin +=res;
    }
    if(resin<0){
        resin = -resin;
    }

    
    UIImageView *shouruImageView = [self myImageView];
    [shouruImageView setImage:[UIImage imageNamed:@"支出"]];
    //    [shouruImageView addSubview:_shouruImgView];
    [_headScrlView addSubview:shouruImageView];
    shouruImageView.frame = CGRectMake(HDAutoWidth(20), height1+HDAutoHeight(10), HDAutoWidth(75), HDAutoWidth(75));
    
    float bot = 0.0;
    
    for (int i=0; i<outArr.count; i++) {
         NSDictionary *dic = outArr[i];
        
        BBFlashCtntLabel *label = [self myLabel];
        [bbArrays addObject:label];
        label.text = dic[@"plant_name"];
        NSString *nowCountStr = dic[@"total_amount"];
        int nowCount = [nowCountStr intValue];
        if(nowCount<0){
            nowCount = -nowCount;
        }
        float needLength = outArr.count* HDAutoWidth(100)*(float)nowCount/resin;
        if(isnan(needLength)){
            needLength = 0.0;
        }
        
        label.frame = CGRectMake(HDAutoWidth(110), height1+HDAutoHeight(20) +i*(HDAutoHeight(75)), HDAutoHeight(85), HDAutoHeight(75));
        label.speed = -1;
        UIColor *color = [UIColor colorWithHexString:dic[@"color"]];
        
        UIView *view = [self myView];
        view.backgroundColor = color;
        view.frame = CGRectMake(label.right + HDAutoWidth(20), label.top + HDAutoHeight(10), needLength, HDAutoHeight(55));
        
        NSString * totalStr = dic[@"total_amount"];
        long int re = [totalStr intValue];
        
        NSString *zhichuText;
        
        if(re<10000){
            zhichuText = [NSString stringWithFormat:@"%ld元",re];
        }else{
            if(re<100000000){
                zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)re/10000];
            }else{
                zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)re/100000000];
            }
        }
        
        BBFlashCtntLabel *detailLabel = [self myLabel];
        [bbArrays addObject:detailLabel];
        detailLabel.text = zhichuText;
        detailLabel.frame = CGRectMake(view.right +HDAutoWidth(15), label.top, HDAutoWidth(200), HDAutoHeight(75));
        detailLabel.speed = -1;
        
        
        [_headScrlView addSubview:label];
        [_headScrlView addSubview:view];
        [_headScrlView addSubview:detailLabel];
        
        bot = view.bottom;
    }
    
    if(outArr.count == 0){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, height1+HDAutoHeight(20), SCREEN_WIDTH, HDAutoHeight(100));
        
        [_headScrlView addSubview:label];
        bot = label.bottom;
    }
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    botView.frame = CGRectMake(0, bot +HDAutoHeight(50), SCREEN_WIDTH, 1);
    [_headScrlView addSubview:botView];
    
    if(!IS_IPHONE_5){
        height1 = botView.bottom +HDAutoHeight(10);
    }else{
        height1 = botView.bottom +HDAutoHeight(50);
    }
    
    
    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    heightOrgin = height1;
    
    [self createMode4];
}


-(void)createModel10{
    
    NSArray *inArr;
    NSArray *outArr;
    @try {
        inArr = yuenian2[@"in"];
        outArr = yuenian2[@"out"];
    } @catch (NSException *exception) {
        inArr = [NSMutableArray array];
        outArr = [NSMutableArray array];
    } @finally {
        
    }
    long int resin = 0;
    long int resout = 0;
    for (int i=0; i<inArr.count; i++) {
        NSDictionary *dic = inArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resin +=res;
    }
    
    for (int i=0; i<outArr.count; i++) {
        NSDictionary *dic = outArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resout +=res;
    }
//    resout = -resout;
    long int total = resin + resout;
    
    float shouruLength = HDAutoWidth(500)*(float)resin/total;
    float zhichuLength = HDAutoWidth(500)*(float)resout/total;
    
    if(isnan(shouruLength)){
        shouruLength = 0.0;
    }
    if(isnan(zhichuLength)){
        zhichuLength = 0.0;
    }
    
    NSString *shouruText;
    NSString *zhichuText;
    
    if(resin<10000){
        shouruText = [NSString stringWithFormat:@"%ld元",resin];
    }else{
        if(resin<100000000){
            shouruText = [NSString stringWithFormat:@"%.1f万元",(float)resin/10000];
        }else{
            shouruText = [NSString stringWithFormat:@"%.1f亿",(float)resin/100000000];
        }
        
    }
    if(resout<10000){
        zhichuText = [NSString stringWithFormat:@"%ld元",resout];
    }else{
        if(resout<100000000){
            zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)resout/10000];
        }else{
            zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)resout/100000000];
        }
    }
    
    
    _yueLabel = [self myLabel2];
    _yueLabel.text = @"本年总收入与支出";
//    _yueLabel.textAlignment = NSTextAlignmentCenter;
    
    _yueLabel.textColor = [UIColor blackColor];
    
    _yueLabel.frame = CGRectMake(HDAutoWidth(20)+SCREEN_WIDTH, 0, SCREEN_WIDTH, HDAutoHeight(60));
//    _yueLabel.speed = -1;
    [_headScrlView addSubview:_yueLabel];
    _shouruImgView = [self myImageView];
//    _shouruImgView.layer.cornerRadius = HDAutoWidth(20);
    [_shouruImgView setImage:[UIImage imageNamed:@"收入"]];
    [_headScrlView addSubview:_shouruImgView];
    
    _shouruView = [self myView];
    _shouruView.backgroundColor = UIColorFromHex(0x64a3d9);
    [_headScrlView addSubview:_shouruView];
    
    _shourumiaoshuLabel = [self myLabel2];
    _shourumiaoshuLabel.text = shouruText;
    [_headScrlView addSubview:_shourumiaoshuLabel];
    
    //fb589b
    _zhichuImageView = [self myImageView];
//    _zhichuImageView.layer.cornerRadius = HDAutoWidth(20);
    [_zhichuImageView setImage:[UIImage imageNamed:@"支出"]];
    [_headScrlView addSubview:_zhichuImageView];
    
    _zhichuView = [self myView];
    _zhichuView.backgroundColor = UIColorFromHex(0xf6a901);
    [_headScrlView addSubview:_zhichuView];
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    [_headScrlView addSubview:botView];
    
    _zhichumiaoshuLabel = [self myLabel2];
    _zhichumiaoshuLabel.text = zhichuText;
    
    
    [_headScrlView addSubview:_zhichumiaoshuLabel];
    
    
    
    [_shouruImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headScrlView.mas_left).offset(HDAutoWidth(20)+SCREEN_WIDTH);
        make.height.width.equalTo(@(HDAutoWidth(75)));
        make.top.equalTo(_yueLabel.mas_bottom).offset(HDAutoHeight(30));
    }];
    [_shouruView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shouruImgView.mas_right).offset(HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(55)));
        make.centerY.equalTo(_shouruImgView.mas_centerY);
        make.width.equalTo(@(shouruLength));
    }];
    
    [_shourumiaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shouruView.mas_right).offset(HDAutoWidth(5));
        make.height.equalTo(_shouruImgView.mas_height);
        make.centerY.equalTo(_shouruImgView.mas_centerY);
        make.right.equalTo(_headScrlView.mas_right);
    }];
    
    
    [_zhichuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headScrlView.mas_left).offset(HDAutoWidth(20)+SCREEN_WIDTH);
        make.height.width.equalTo(@(HDAutoWidth(75)));
        make.top.equalTo(_shouruImgView.mas_bottom).offset(HDAutoHeight(30));
    }];
    [_zhichuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_shouruImgView.mas_right).offset(HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(55)));
        make.centerY.equalTo(_zhichuImageView.mas_centerY);
        make.width.equalTo(@(zhichuLength));
    }];
    
    [_zhichumiaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_zhichuView.mas_right).offset(HDAutoWidth(5));
        make.height.equalTo(_zhichuImageView.mas_height);
        make.centerY.equalTo(_zhichuImageView.mas_centerY);
        make.right.equalTo(_headScrlView.mas_right);
    }];
    
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(1));
        make.top.equalTo(_zhichuImageView.mas_bottom).offset(HDAutoHeight(30));
    }];
    
    [self layoutIfNeeded];
    
//    _shourumiaoshuLabel.speed = -1;
//    _zhichumiaoshuLabel.speed = -1;
////
//    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
//    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    
    [self createMode20];
}

-(void)createMode20{
    NSArray *inArr;
    @try {
        inArr = yuenian2[@"in"];
    } @catch (NSException *exception) {
        inArr = [NSMutableArray array];
    } @finally {
        
    }
    
    int resin = 0;
    for (int i=0; i<inArr.count; i++) {
        NSDictionary *dic = inArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resin +=res;
    }
    
    BBFlashCtntLabel *headLabel = [self myLabel];
    [bbArrays addObject:headLabel];
    headLabel.text = @"各项收入与支出";
    headLabel.textColor = [UIColor blackColor];
    headLabel.frame = CGRectMake(HDAutoWidth(20)+SCREEN_WIDTH, height2 + HDAutoHeight(10), SCREEN_WIDTH, HDAutoHeight(60));
    headLabel.speed = -1;
    [_headScrlView addSubview:headLabel];
    
    
    UIImageView *shouruImageView = [self myImageView];
    [shouruImageView setImage:[UIImage imageNamed:@"收入"]];
//    [shouruImageView addSubview:_shouruImgView];
    [_headScrlView addSubview:shouruImageView];
    shouruImageView.frame = CGRectMake(HDAutoWidth(20)+SCREEN_WIDTH, headLabel.bottom+HDAutoHeight(30), HDAutoWidth(75), HDAutoWidth(75));
    
    float bot = 0.0;
    
    for (int i=0; i<inArr.count; i++) {
        NSDictionary *dic = inArr[i];
        BBFlashCtntLabel *label = [self myLabel];
        [bbArrays addObject:label];
        label.text = dic[@"variety_name"];
        NSString *nowCountStr = dic[@"total_amount"];
        int nowCount = [nowCountStr intValue];
        float needLength = inArr.count* HDAutoWidth(100)*(float)nowCount/resin;
        
        if(isnan(needLength)){
            needLength = 0.0;
        }
        if(IS_IPHONE_5){
            label.frame = CGRectMake(HDAutoWidth(110)+SCREEN_WIDTH, headLabel.bottom+HDAutoHeight(30) +i*(HDAutoHeight(75)), HDAutoHeight(100), HDAutoHeight(75));
        }else{
            label.frame = CGRectMake(HDAutoWidth(110)+SCREEN_WIDTH, headLabel.bottom+HDAutoHeight(30) +i*(HDAutoHeight(75)), HDAutoHeight(85), HDAutoHeight(75));
        }
        
        label.speed = -1;
        
        UIColor *color = [UIColor colorWithHexString:dic[@"color"]];
        
        UIView *view = [self myView];
        view.backgroundColor = color;
        view.frame = CGRectMake(label.right + HDAutoWidth(20), label.top + HDAutoHeight(10), needLength, HDAutoHeight(55));
        
        NSString * totalStr = dic[@"total_amount"];
        int re = [totalStr intValue];
        
        NSString *zhichuText;
        
        if(re<10000){
            zhichuText = [NSString stringWithFormat:@"%d元",re];
        }else{
            if(re<100000000){
                zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)re/10000];
            }else{
                zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)re/100000000];
            }
        }
        
        BBFlashCtntLabel *detailLabel = [self myLabel];
        [bbArrays addObject:detailLabel];
        detailLabel.text = zhichuText;
        detailLabel.frame = CGRectMake(view.right +HDAutoWidth(15), label.top, HDAutoWidth(250), HDAutoHeight(75));
        
        detailLabel.speed = -1;
        
        [_headScrlView addSubview:label];
        [_headScrlView addSubview:view];
        [_headScrlView addSubview:detailLabel];
        
        bot = view.bottom;
    }
    
    if(inArr.count == 0){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(SCREEN_WIDTH, headLabel.bottom+HDAutoHeight(30), SCREEN_WIDTH, HDAutoHeight(100));
        
        [_headScrlView addSubview:label];
        bot = label.bottom;
    }
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    botView.frame = CGRectMake(HDAutoWidth(40)+SCREEN_WIDTH, bot +HDAutoHeight(50), SCREEN_WIDTH-HDAutoWidth(80), 1);
    [_headScrlView addSubview:botView];
    
    if(!IS_IPHONE_5){
        height2 = botView.bottom +HDAutoHeight(10);
    }else{
        height2 = botView.bottom +HDAutoHeight(50);
    }
    
//    height2 = botView.bottom +HDAutoHeight(10);
//
//    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
//    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    
    
//    [self createModel3];
    
    [self createModel30];
    
}

-(void)createModel30{
    
    NSArray *outArr;
    @try {
        outArr = yuenian2[@"out"];
    } @catch (NSException *exception) {
        outArr = [NSMutableArray array];
    } @finally {
        
    }
    long int resin = 0;
    for (int i=0; i<outArr.count; i++) {
        NSDictionary *dic = outArr[i];
        NSString *amount = dic[@"total_amount"];
        int res = [amount intValue];
        resin +=res;
    }
    if(resin<0){
        resin = -resin;
    }

    
    UIImageView *shouruImageView = [self myImageView];
    [shouruImageView setImage:[UIImage imageNamed:@"支出"]];
    //    [shouruImageView addSubview:_shouruImgView];
    [_headScrlView addSubview:shouruImageView];
    shouruImageView.frame = CGRectMake(HDAutoWidth(20)+SCREEN_WIDTH, height2+HDAutoHeight(10), HDAutoWidth(75), HDAutoWidth(75));
    
    float bot = 0.0;
    
    for (int i=0; i<outArr.count; i++) {
        NSDictionary *dic = outArr[i];
        
        
        BBFlashCtntLabel *label = [self myLabel];
        [bbArrays addObject:label];
        label.text = dic[@"plant_name"];
        NSString *nowCountStr = dic[@"total_amount"];
        int nowCount = [nowCountStr intValue];
        if(nowCount<0){
            nowCount = -nowCount;
        }
        float needLength = outArr.count * HDAutoWidth(100)*(float)nowCount/resin;
        if(isnan(needLength)){
            needLength = 0.0;
        }
        label.frame = CGRectMake(HDAutoWidth(110)+SCREEN_WIDTH, height2+HDAutoHeight(20) +i*(HDAutoHeight(75)), HDAutoHeight(85), HDAutoHeight(75));
        label.speed = -1;
        UIColor *color = [UIColor colorWithHexString:dic[@"color"]];
        
        UIView *view = [self myView];
        view.backgroundColor = color;
        view.frame = CGRectMake(label.right + HDAutoWidth(20), label.top + HDAutoHeight(10), needLength, HDAutoHeight(55));
        
        
        NSString * totalStr = dic[@"total_amount"];
        long int re = [totalStr intValue];
        
        NSString *zhichuText;
        
        if(re<10000){
            zhichuText = [NSString stringWithFormat:@"%ld元",re];
        }else{
            if(re<100000000){
                zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)re/10000];
            }else{
                zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)re/100000000];
            }
        }
        
        
        BBFlashCtntLabel *detailLabel = [self myLabel];
        [bbArrays addObject:detailLabel];
        detailLabel.text = zhichuText;
        detailLabel.frame = CGRectMake(view.right +HDAutoWidth(15), label.top, HDAutoWidth(200), HDAutoHeight(75));
        detailLabel.speed = -1;
        
        
        [_headScrlView addSubview:label];
        [_headScrlView addSubview:view];
        [_headScrlView addSubview:detailLabel];
        
        bot = view.bottom;
    }
    
    if(outArr.count == 0){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(SCREEN_WIDTH, height2+HDAutoHeight(20), SCREEN_WIDTH, HDAutoHeight(100));
        
        [_headScrlView addSubview:label];
        bot = label.bottom;
    }
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    botView.frame = CGRectMake(SCREEN_WIDTH, bot +HDAutoHeight(50), SCREEN_WIDTH, 1);
    [_headScrlView addSubview:botView];
    
    
    if(!IS_IPHONE_5){
        height2 = botView.bottom +HDAutoHeight(10);
    }else{
        height2 = botView.bottom +HDAutoHeight(50);
    }
    
//    height2 = botView.bottom +HDAutoHeight(10);
//
//    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
//    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    
    
}





-(void)createMode4{
    
//    NSArray *arr = total[@"greens"];
    

    
    NSArray *arr;
    @try {
        arr = total[@"greens"];
    } @catch (NSException *exception) {
        arr = [NSMutableArray array];
    } @finally {
        
    }
    
    int total = 0;
    
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        NSString *str = dic[@"greenhouse_num"];
        int res = [str intValue];
        total +=res;
    }
    
    _model4View = [[UIView alloc]init];
    _model4View.tag = 234;
    
    _model4View.frame = CGRectMake(0, height1+HDAutoHeight(10), SCREEN_WIDTH, 0);
    
    [self addSubview:_model4View];
    
    BBFlashCtntLabel *headLabel = [self myLabel];
    [bbArrays addObject:headLabel];
    headLabel.text = @"种植棚数";
    headLabel.textColor = [UIColor blackColor];
    headLabel.frame = CGRectMake(HDAutoWidth(20), HDAutoHeight(10), SCREEN_WIDTH, HDAutoHeight(60));
    headLabel.speed = -1;
    [_model4View addSubview:headLabel];
    
    
    UIImageView *shouruImageView = [self myImageView];
    [shouruImageView setImage:[UIImage imageNamed:@""]];
    //    [shouruImageView addSubview:_shouruImgView];
    [_model4View addSubview:shouruImageView];
    shouruImageView.frame = CGRectMake(HDAutoWidth(20), headLabel.bottom+HDAutoHeight(30), HDAutoWidth(75), HDAutoWidth(75));
    
    float bot = 0.0;
    
    for (int i=0; i<arr.count; i++) {
        
        NSDictionary *dic = arr[i];
        NSString *countStr = dic[@"greenhouse_num"];
        int res = [countStr intValue];
        
        float needLength =arr.count * HDAutoWidth(100)*(float)res/total;
        
        if(isnan(needLength)){
            needLength = 0.0;
        }
        
        BBFlashCtntLabel *label = [self myLabel];
        [bbArrays addObject:label];
        label.text = dic[@"variety_name"];
        label.frame = CGRectMake(HDAutoWidth(110), headLabel.bottom+HDAutoHeight(30) +i*(HDAutoHeight(75)), HDAutoHeight(130), HDAutoHeight(75));
        label.speed = -1;
        UIColor *color = [UIColor colorWithHexString:dic[@"color"]];
        
        UIView *view = [self myView];
        view.backgroundColor = color;
        view.frame = CGRectMake(label.right + HDAutoWidth(20), label.top + HDAutoHeight(10), needLength, HDAutoHeight(55));
        
        NSString *str = [NSString stringWithFormat:@"%@个",countStr];
        
        BBFlashCtntLabel *detailLabel = [self myLabel];
        [bbArrays addObject:detailLabel];
        detailLabel.text = str;
        detailLabel.frame = CGRectMake(view.right +HDAutoWidth(15), label.top, HDAutoWidth(200), HDAutoHeight(75));
        
        detailLabel.speed = -1;
        
        [_model4View addSubview:label];
        [_model4View addSubview:view];
        [_model4View addSubview:detailLabel];
        
        bot = view.bottom;
    }
    
    if(arr.count == 0){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(SCREEN_WIDTH, headLabel.bottom+HDAutoHeight(30), SCREEN_WIDTH, HDAutoHeight(100));
        
        [_model4View addSubview:label];
        bot = label.bottom;
    }
    
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor grayColor];
    botView.frame = CGRectMake(0, bot +HDAutoHeight(50), SCREEN_WIDTH, 1);
    [_model4View addSubview:botView];
    _model4View.height = botView.bottom + HDAutoHeight(10);
    
    height1 = botView.bottom + height1 +HDAutoHeight(10);
    
//    _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height1);
//    _headScrlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height1);
    
    [self createMode5];
    
}


-(void)createMode5{
    
    
    
    NSDictionary *dic;
    
    @try {
        dic = total[@"bills"];
    } @catch (NSException *exception) {
        dic = [NSDictionary dictionary];
    } @finally {
        
    }
    
    NSArray *shouruArr;
    @try {
        shouruArr = dic[@"in"];
    } @catch (NSException *exception) {
        shouruArr = [NSMutableArray array];
    } @finally {
        
    }
    
//    NSArray *shouruArr = dic[@"in"];
    
//    shouruArr = [NSArray array];
    
    _model5View = [[UIView alloc]init];
    _model5View.layer.masksToBounds = YES;
    _model5View.tag = 201;
    
    _model5View.backgroundColor = [UIColor whiteColor];
    [self addSubview:_model5View];
    _model5View.frame = CGRectMake(0, height1, SCREEN_WIDTH, HDAutoHeight(290));
    
    BBFlashCtntLabel *titleLabel = [self myLabel];
    [bbArrays addObject:titleLabel];
    titleLabel.text = @"详细收入";
    titleLabel.textColor = [UIColor blackColor];
    [_model5View addSubview:titleLabel];
    titleLabel.frame = CGRectMake(HDAutoWidth(20), HDAutoHeight(0), HDAutoWidth(300), HDAutoHeight(80));
    titleLabel.speed = -1;
//    UIControlState
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.tag = 200;
    [moreBtn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
    
    moreBtn.selected = NO;
    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [_model5View addSubview:moreBtn];
    moreBtn.frame = CGRectMake(SCREEN_WIDTH - HDAutoWidth(100), titleLabel.top +HDAutoHeight(20), HDAutoHeight(100), HDAutoHeight(100));
    moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0,HDAutoHeight(30),HDAutoHeight(60),HDAutoHeight(30));;
//    [moreBtn setEnlargeEdgeWithTop:HDAutoHeight(30) right:HDAutoHeight(30) bottom:HDAutoHeight(30) left:HDAutoHeight(30)];
    if(shouruArr.count<=4){
        moreBtn.alpha = 0;
    }
    
    float bot = 0.0;
    
    
    if(shouruArr.count == 0 ){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, HDAutoHeight(100), SCREEN_WIDTH, HDAutoHeight(100));
        
        [_model5View addSubview:label];
        
    }else{
        
        for (int i=0; i<shouruArr.count; i++) {
            
            NSDictionary *needDic = shouruArr[i];
            
            
            UIColor *color = [UIColor colorWithHexString:needDic[@"color"]];
            
            UIView *leftView = [[UIView alloc]init];
            leftView.backgroundColor = color;
            [_model5View addSubview:leftView];
            
            NSString * totalStr = needDic[@"total_amount"];
            long int re = [totalStr intValue];
            
            NSString *zhichuText;
            
            if(re<10000){
                zhichuText = [NSString stringWithFormat:@"%ld元",re];
            }else{
                if(re<100000000){
                    zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)re/10000];
                }else{
                    zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)re/100000000];
                }
            }
            
            NSString *needText = [NSString stringWithFormat:@"%@     %@",needDic[@"variety_name"],zhichuText];
            
            BBFlashCtntLabel *label = [[BBFlashCtntLabel alloc]init];
            [bbArrays addObject:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor grayColor];
            
//            UILabel *label = [self myLabel];
            label.text = needText;
            [_model5View addSubview:label];
            
            int a = i%2;
            int row = i/2;
            //        300
            leftView.frame = CGRectMake(HDAutoWidth(30)+HDAutoWidth(340)*a, row*HDAutoHeight(85) + titleLabel.bottom+HDAutoHeight(40), HDAutoWidth(20), HDAutoHeight(60));
            label.frame = CGRectMake(leftView.right + HDAutoWidth(25), leftView.top, HDAutoWidth(250), HDAutoHeight(60));
            label.speed = -1;
            bot = leftView.bottom;
            
        }
        
    }
    
    
    
    
    UIView *botView = [[UIView alloc]init];
    botView.tag = 202;
    botView.backgroundColor = [UIColor grayColor];
    [_model5View addSubview:botView];
    
//    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(mainView.mas_left);
//        make.right.equalTo(mainView.mas_right);
//        make.height.equalTo(@(1));
//        make.bottom.equalTo(mainView.mas_bottom);
//
//    }];
    
    botView.frame = CGRectMake(0, _model5View.bottom-1 - _model5View.y, SCREEN_WIDTH, 1);

    height1 = botView.bottom +HDAutoHeight(10)+_model5View.y;
    
    NSLog(@"textheight:%f", height1);
    
    [self createMode6];
    
}



-(void)createMode6{
    
    
    
    
    _model6View = [[UIView alloc]init];
    _model6View.layer.masksToBounds = YES;
//    _model6View.tag = 301;
    
    _model6View.backgroundColor = [UIColor whiteColor];
    
    _model6View.frame = CGRectMake(0, height1, SCREEN_WIDTH, 300);
    [self addSubview:_model6View];
    
    
    BBFlashCtntLabel *titleLabel = [self myLabel];
    [bbArrays addObject:titleLabel];
    titleLabel.text = @"详细支出";
    titleLabel.textColor = [UIColor blackColor];
    [_model6View addSubview:titleLabel];
    titleLabel.frame = CGRectMake(HDAutoWidth(20), HDAutoHeight(0), HDAutoWidth(300), HDAutoHeight(80));
    titleLabel.speed = -1;

    NSArray *arr = [NSArray array];
    UIView *needView1 = [self createModel6DetailViewWithDataArr:arr AndTitle:@"种植"];
    needView1.layer.masksToBounds = YES;
    needView1.frame = CGRectMake(0, titleLabel.bottom+HDAutoHeight(10), SCREEN_WIDTH, HDAutoHeight(205));
    needView1.tag = 200;
    [_model6View addSubview:needView1];
    
    UIView *needView2 = [self createModel6DetailViewWithDataArr:arr AndTitle:@"植保"];
    needView2.layer.masksToBounds = YES;
    needView2.frame = CGRectMake(0, needView1.bottom+HDAutoHeight(10), SCREEN_WIDTH, HDAutoHeight(205));
    needView2.tag = 300;
    [_model6View addSubview:needView2];
    
    UIView *needView3 = [self createModel6DetailViewWithDataArr:arr AndTitle:@"施肥"];
    needView3.layer.masksToBounds = YES;
    needView3.frame = CGRectMake(0, needView2.bottom+HDAutoHeight(10), SCREEN_WIDTH, HDAutoHeight(205));
    needView3.tag = 400;
    [_model6View addSubview:needView3];
    
    float height = needView3.bottom;
    _model6View.height = height+HDAutoHeight(20);
    

    
    
}


-(UIView *)createModel6DetailViewWithDataArr:(NSArray *)dataArr AndTitle:(NSString *)title{
    
    int tag = 0;
    
    NSDictionary *qdic;
    
    @try {
        qdic = total[@"bills"];
    } @catch (NSException *exception) {
        qdic = [NSDictionary dictionary];
    } @finally {
        
    }
    @try {
        qdic = qdic[@"outdetail"];
    } @catch (NSException *exception) {
        qdic = [NSDictionary dictionary];
    } @finally {
        
    }
//    NSArray *needArr = qdic[@"out"];
    
    NSString *chectStr;
    
    if([title isEqualToString:@"种植"]){
        chectStr = @"plant";
        tag = 666;
    }else if ([title isEqualToString:@"植保"]){
        chectStr = @"protection";
        tag = 667;
    }else{
        chectStr = @"fertilize";
        tag = 668;
    }
    
    NSArray *needArr;
    @try {
        needArr = qdic[chectStr];
    } @catch (NSException *exception) {
        needArr = [NSArray array];
    } @finally {
        
    }
    
    
//    static int needTag = 400;
    
    UIView *detailView = [[UIView alloc]init];
//    detailView.backgroundColor = [UIColor greenColor];
    UIView *MleftView = [[UIView alloc]init];
    MleftView.backgroundColor = [UIColor orangeColor];
    [detailView addSubview:MleftView];
    
    BBFlashCtntLabel *Mlabel = [self myLabel];
    [bbArrays addObject:Mlabel];
    Mlabel.text = title;
    [detailView addSubview:Mlabel];
    Mlabel.textColor = [UIColor blackColor];
//    label.font = [UIFont systemFontOfSize:15];
    
    MleftView.frame = CGRectMake(HDAutoWidth(30), 0 , HDAutoWidth(20), HDAutoHeight(60));
    Mlabel.frame = CGRectMake(MleftView.right + HDAutoWidth(25), MleftView.top, HDAutoWidth(250), HDAutoHeight(60));
    Mlabel.speed = -1;
    UIButton *moreBtn = [[UIButton alloc]init];
//    moreBtn.tag = needTag;
//    needTag++;
    moreBtn.tag = tag;
    [moreBtn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
    moreBtn.selected = NO;
    [moreBtn addTarget:self action:@selector(mode6Click:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:moreBtn];
    moreBtn.frame = CGRectMake(SCREEN_WIDTH - HDAutoWidth(100), MleftView.top , HDAutoHeight(100), HDAutoHeight(100));
    
    moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0,HDAutoHeight(30),HDAutoHeight(60),HDAutoHeight(30));;
    
    if(needArr.count<=4){
        moreBtn.alpha = 0;
    }
    
    if(needArr.count == 0 ){
        
        UILabel *label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainColor;
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, HDAutoHeight(40), SCREEN_WIDTH, HDAutoHeight(80));
        
        [detailView addSubview:label];
        
    }else{
        
        for (int i=0; i<needArr.count; i++) {
            NSDictionary *dic = needArr[i];
            
            NSString * totalStr = dic[@"total_amount"];
            long int re = [totalStr intValue];
            
            NSString *zhichuText;
            
            if(re<10000){
                zhichuText = [NSString stringWithFormat:@"%ld元",re];
            }else{
                if(re<100000000){
                    zhichuText = [NSString stringWithFormat:@"%.1f万元",(float)re/10000];
                }else{
                    zhichuText = [NSString stringWithFormat:@"%.1f亿",(float)re/100000000];
                }
            }
            
            NSString *needText = [NSString stringWithFormat:@"%@     %@",dic[@"variety_name"],zhichuText];
            
            
            BBFlashCtntLabel *label = [self myLabel];
            [bbArrays addObject:label];
            label.text = needText;
            [detailView addSubview:label];
            
            int a = i%2;
            int row = i/2;
            //        300
            
            label.frame = CGRectMake(Mlabel.left+HDAutoWidth(340)*a, row*HDAutoHeight(85) + MleftView.bottom +HDAutoHeight(10), HDAutoWidth(270), HDAutoHeight(60));
            label.speed = -1;

        }
        
    }
    
    
    
    
    return detailView;
}


-(void)mode6Click:(UIButton *)btn{
    
    
    NSDictionary *dic = total[@"bills"];
    dic = dic[@"outdetail"];
    NSArray *shouruArr;
    if(btn.tag == 666){
        shouruArr = dic[@"plant"];
    }else if (btn.tag == 667){
        shouruArr = dic[@"protection"];
    }else{
        shouruArr = dic[@"fertilize"];
    }
    
    int cha = (int)shouruArr.count - 4;
    int row = cha/2;
    int yu = cha%2;
    if(yu>0){
        row+=1;
    }
    
    
    float height = row *HDAutoHeight(90);
    
    UIView *nowView = btn.superview;
    UIView *faView = _model6View;
//    UIView *botView = [faView viewWithTag:233];
    NSArray *arr = faView.subviews;
    for (int i=0; i<arr.count; i++) {
        UIView *view = arr[i];
        if(view.tag > nowView.tag){
            
            if(btn.selected == NO){
                [UIView animateWithDuration:0.5 animations:^{
                    view.y+=height;
//                    faView.height += HDAutoHeight(200);
                } completion:^(BOOL finished) {
                    
                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    view.y-=height;
//                    faView.height -= HDAutoHeight(200);
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }
    }
    
    if(btn.selected == NO){
        
        [UIView animateWithDuration:0.5 animations:^{
//            botbotView.y+=height;
            faView.height += height;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
//            botbotView.y-=height;
            faView.height -= height;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if(btn.selected == NO){
        
        [btn setImage:[UIImage imageNamed:@"向上"] forState:UIControlStateNormal];
        
        btn.selected = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            nowView.height+=height;
//            botView.y+=HDAutoHeight(200);
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        btn.selected = NO;
        [btn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            nowView.height-=height;
//            botView.y-=HDAutoHeight(200);
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    [self needPostNoti];
}

-(void)moreClick:(UIButton *)btn{
    
    NSDictionary *dic = total[@"bills"];
    NSArray *shouruArr = dic[@"in"];
    
    int cha = (int)shouruArr.count - 4;
    int row = cha/2;
    int yu = cha%2;
    if(yu>0){
        row+=1;
    }
    
    float height = row *HDAutoHeight(90);
    
    NSLog(@"点击更多");
    UIView *needView;
    UIView *botView;
    NSArray *arr = self.subviews;
    
    if(btn.selected == NO){
        [UIView animateWithDuration:0.5 animations:^{
            _model6View.y+=height;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _model6View.y-=height;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    for (int i=0; i<arr.count; i++) {
        UIView *view = arr[i];
        if(view.tag == 201){
            needView = view;
        }
        if(view.tag>300){
            if(btn.selected == NO){
                [UIView animateWithDuration:0.5 animations:^{
                    view.y+=height;
                } completion:^(BOOL finished) {
                    
                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    view.y-=height;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            
        }
        
       
        
    }
    NSArray *arr2 = needView.subviews;
    for (int i=0; i<arr2.count; i++) {
        UIView *view = arr2[i];
        if(view.tag == 202){
            botView = view;
        }
    }
    
    if(btn.selected == NO){
        
        [btn setImage:[UIImage imageNamed:@"向上"] forState:UIControlStateNormal];
        
        btn.selected = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            needView.height+=height;
            botView.y+=height;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        btn.selected = NO;
        [btn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            needView.height-=height;
            botView.y-=height;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    [self needPostNoti];
    
}


-(UIView *)myView{
    UIView *view = [[UIView alloc]init];
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = HDAutoWidth(10);
    
    return view;
}

-(UIImageView *)myImageView{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.masksToBounds = YES;
    
    return imageView;
    
}

-(BBFlashCtntLabel *)myLabel{
    BBFlashCtntLabel *label = [[BBFlashCtntLabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    
    return label;
}

-(UILabel *)myLabel2{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    
    return label;
}

-(float)needToReturnHeightWithModel:(NSString *)model{
    
//    UIView *view = [self viewWithTag:301];
    return _model6View.bottom+HDAutoHeight(10);
//    return 2600;
    
}

-(void)needPostNoti{
    NSLog(@"needPostNoti");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"heightChange" object:nil];
}

-(void)changeScrollViewWithState:(int)state{
    NSLog(@"aaa233");
    
//    return;
    
//    [self checkView];
    
    float cha = height2 - heightOrgin;
    
    if (state == 1) {
        [_headScrlView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        _headScrlView.height = heightOrgin;
        _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, heightOrgin);
       
        [UIView animateWithDuration:0.5 animations:^{

            _model4View.y -=cha;
            _model5View.y -=cha;
            _model6View.y -=cha;

        }];
        
    }else{
        [_headScrlView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        _headScrlView.height = height2;
        _headScrlView.contentSize = CGSizeMake(SCREEN_WIDTH*2, height2);
        
        [UIView animateWithDuration:0.5 animations:^{

            _model4View.y +=cha;
            _model5View.y +=cha;
            _model6View.y +=cha;

        }];
        

        
    }
    [self needPostNoti];
}


-(void)needtoreload{
    
    for (int i=0; i<bbArrays.count; i++) {
        BBFlashCtntLabel *label = bbArrays[i];
        label.speed = -1;
    }
    
}




@end
