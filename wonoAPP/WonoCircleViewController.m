//
//  WonoCircleViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoCircleViewController.h"
#import "WonoCircleTableViewCell.h"

//#import <BaiduMobStat/BaiduMobStat.h>

@interface WonoCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong) UIButton *askBtn;
@property (nonatomic,strong) UITableView *wonoTableView;
@property (nonatomic,strong)UIButton *workBtn;

@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation WonoCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self setBtn];
////    [self CreateTitleLabelWithText:@"农知道"];
    [self creatTable];
    [self createWork];
//    [[BaiduMobStat defaultStat] eventStart:@"login" eventLabel:@"登录"];
}


-(void)setBtn{
    
    _askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _askBtn.frame = CGRectMake(SCREEN_WIDTH-HDAutoWidth(80), HDAutoHeight(55), HDAutoWidth(50), HDAutoWidth(50));
    _askBtn.backgroundColor = [UIColor clearColor];
//    [_askBtn setTitle:@"我要提问" forState:UIControlStateNormal];
//    [_askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_askBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_askBtn setImage:[UIImage imageNamed:@"3-消息"] forState:UIControlStateNormal];
    _askBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_askBtn addTarget:self action:@selector(askClick) forControlEvents:UIControlEventTouchUpInside];
    _askBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_headView2 addSubview:_askBtn];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.backgroundColor = [UIColor redColor];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.text = @"99+";
    _numberLabel.layer.masksToBounds = YES;
    
    _numberLabel.font = [UIFont systemFontOfSize:10];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:10]};
    CGSize size=[@"99" sizeWithAttributes:attrs];
    CGSize size2=[_numberLabel.text sizeWithAttributes:attrs];
    
    float multy = size.width - size2.width;
    
    if(multy>0){
        _numberLabel.layer.cornerRadius = HDAutoHeight(12);
        
        _numberLabel.frame = CGRectMake(SCREEN_WIDTH-HDAutoWidth(50), HDAutoHeight(45.5), size2.width+HDAutoWidth(10), HDAutoWidth(25));
        
    }else{
        _numberLabel.layer.cornerRadius = HDAutoHeight(12);
        
        _numberLabel.frame = CGRectMake(SCREEN_WIDTH-HDAutoWidth(55), HDAutoHeight(44.5), size2.width+HDAutoWidth(10), HDAutoWidth(25));
    }
    [_headView2 addSubview:_numberLabel];
//    [self.navigationController.navigationBar addSubview:_numberLabel];
    
   
   
}

-(void)askClick{
    NSLog(@"点击消息");
}

-(void)creatTable{
    _wonoTableView = [[UITableView alloc]init];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _wonoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _wonoTableView.allowsSelection = NO;
    _wonoTableView.dataSource = self;
    _wonoTableView.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _wonoTableView.backgroundColor = [UIColor whiteColor];
//    _wonoTableView.frame = self.view.frame;
    
    
    
    [self.view addSubview:_wonoTableView];
    
    [_wonoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headView2.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
//    _wonoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    _wonoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(520);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    WonoCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WonoCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    //    [cell creatConView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击");
}


-(void)createWork{
    _workBtn = [[UIButton alloc]init];
    _workBtn.backgroundColor = MainColor;
    [_workBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_workBtn setTitle:@"提\n问" forState:UIControlStateNormal];
    _workBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_workBtn addTarget:self action:@selector(workClick) forControlEvents:UIControlEventTouchUpInside];
    
    _workBtn.layer.shadowColor = UIColorFromHex(0x4cb566).CGColor;
    _workBtn.layer.shadowOpacity = 0.3f;
    //    _ConView.layer.shadowRadius =5;
    _workBtn.layer.shadowOffset = CGSizeMake(-6,-6);
    _workBtn.layer.cornerRadius = HDAutoHeight(130);
    _workBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, HDAutoHeight(100));
    //    _workBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;//换行模式自动换行
    _workBtn.titleLabel.numberOfLines = 0;
    [self.view addSubview:_workBtn];
    [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(HDAutoHeight(260)));
        make.width.equalTo(@(HDAutoWidth(260)));
        make.centerX.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-HDAutoHeight(160));
    }];
    //    [self.view.superview layoutIfNeeded];
    //    [_workBtn.superview layoutIfNeeded];
    //    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_workBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(HDAutoHeight(130), HDAutoHeight(130))];
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = _workBtn.bounds;
    //    maskLayer.path = maskPath.CGPath;
    //    _workBtn.layer.mask = maskLayer;
    
}

-(void)workClick{
    NSLog(@"点击了提问");
}

-(void)creatTitleAndBackBtn{
    
    _headView2 = [[UIView alloc]init];
    _headView2.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView2.alpha = 0.8;
    [self.view addSubview:_headView2];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"沃农圈";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headView2 addSubview:_titleLabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"0-返回"] forState:UIControlStateNormal];
    //    [_backBtn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_headView2 addSubview:_backBtn];
    
    _backBtn.hidden = YES;
    
    [_headView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(64));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView2.mas_left).offset(15);
        make.top.equalTo(_headView2.mas_top).offset(24);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView2.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"我显示了");
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


@end
