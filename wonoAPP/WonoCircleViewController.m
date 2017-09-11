//
//  WonoCircleViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "WonoCircleViewController.h"
#import "WonoCircleTableViewCell.h"
#import "ToAskViewController.h"
#import "ToAnswerViewController.h"
#import "WonoCircleDetailViewController.h"
#import "MessageViewController.h"

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

@implementation WonoCircleViewController{
    
    NSMutableArray *dataArr;
    int page;
    
    BOOL ChangeMark;
    
    NSMutableArray *askArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ChangeMark = true;
    page = 1;
    dataArr = [NSMutableArray array];
    askArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self setBtn];
////    [self CreateTitleLabelWithText:@"农知道"];
    [self creatTable];
    [self createWork];
    
    
    [self requesData];
    
    _wonoTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _wonoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
//    [[BaiduMobStat defaultStat] eventStart:@"login" eventLabel:@"登录"];
    [self makePlaceHolderWithTitle:@"加载数据中..."];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wonoCircleRe" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)makePlaceHolderWithTitle:(NSString *)title{
    
    [self.view layoutIfNeeded];
    [_wonoTableView layoutIfNeeded];
    [_wonoTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        //        [_plantTableView setScrollEnabled:NO];
        UIView *view = [[UIView alloc]initWithFrame:_wonoTableView.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(390), 300, HDAutoHeight(60));
        [view addSubview:label];
        
        
        return view;
    } normalBlock:^(UITableView * _Nonnull sender) {
        [_wonoTableView setScrollEnabled:YES];
    }];
    [_wonoTableView reloadData];

    
}

-(void)refresh{
    page = 1;
//    _wonoTableView = [[UITableView alloc]init];
    
//    _wonoTableView.
    
    for(int i=0;i<dataArr.count;i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
//        NSString *cellIdentifier = [NSString stringWithFormat:@"identy%d",i];
        WonoCircleTableViewCell *cell = [_wonoTableView cellForRowAtIndexPath:path];
        if(cell == nil){
            break;
        }
        cell.changeMark = @"1";
    }
    dataArr = [NSMutableArray array];
    askArr = [NSMutableArray array];
    ChangeMark = true;
    [self requesData];
    
}
-(void)requestMore{
    page++;
    [self requesData];

    
}

-(void)requesData{
    [[InterfaceSingleton shareInstance].interfaceModel GetAllAskWithCallBackWithPage:page AndCallBack:^(int state, id data, NSString *msg) {
        [_wonoTableView.mj_header endRefreshing];
        [_wonoTableView.mj_footer endRefreshing];
        [self makePlaceHolderWithTitle:@"暂无数据"];
        if(state == 2000){
            NSLog(@"aa");
            NSArray *arr = data[@"data"];
            
            if(arr.count == 0){
                if(page!=1){
                    page--;
                }
            }

            
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                WonoCircleModel *model = [[WonoCircleModel alloc]init];
                model.titleStr = dic[@"title"];
                model.contentStr = dic[@"content"];
                NSArray *imageArr = dic[@"pic_urls"];
                if(imageArr.count != 0){
                    model.imgUrl = imageArr[0];
                }
                model.positionStr = dic[@"location"];
                model.answerCount = dic[@"answer_count"];
                model.askId = dic[@"id"];
                
                if([model.contentStr isEqualToString:@""]&&model.imgUrl == nil){
                    model.type = 1;
                }
                if(![model.contentStr isEqualToString:@""]&&model.imgUrl == nil){
                    model.type = 2;
                }
                if([model.contentStr isEqualToString:@""]&&model.imgUrl != nil){
                    model.type = 3;
                }
                if(![model.contentStr isEqualToString:@""]&&model.imgUrl != nil){
                    model.type = 4;
                }
                
                [dataArr addObject:model];
                
                
            
                
                
                
            }
            
            [_wonoTableView reloadData];
            
        }
        
        
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }

    }];
    
   
    
    
//    for (int i=1; i<5; i++) {
//        WonoCircleModel *model = [[WonoCircleModel alloc]init];
//        model.type = i;
//        model.titleStr = @"啊啊啊啊啊啊啊啊？";
//        model.contentStr = @"啊啊啊啊啊啊啊啊？啊啊啊啊啊啊啊啊？啊啊啊啊啊啊啊啊？啊啊啊啊啊啊啊啊？啊啊啊啊啊啊啊啊？啊啊啊啊啊啊啊啊？";
//        model.imgUrl = @"http://ospirz9dn.bkt.clouddn.com/8990AC7D-8679-4BC8-A125-8DCF381C036B.png";
//        model.positionStr = @"地点地点地点地点地点";
//        model.answerCount = @"10";
//        model.askId = @"233";
//        [dataArr addObject:model];
//    }
//   
////    [dataArr addObject:model];
////    [dataArr addObject:model];
////    [dataArr addObject:model];
//    [_wonoTableView reloadData];
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
    MessageViewController *msVc = [[MessageViewController alloc]init];
    msVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msVc animated:YES];
    
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

    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WonoCircleModel *model = dataArr[indexPath.row];
    
    CGFloat height = 0;
    
    switch (model.type) {
        case 1:{
            height = HDAutoHeight(270);
            break;
        }
        case 2:{
            height = HDAutoHeight(310);
            break;
        }
        case 3:{
            height = HDAutoHeight(550);
            break;
        }
        case 4:{
            height = HDAutoHeight(630);
            break;
        }
            
        default:
            break;
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"identy%ld",(long)indexPath.row];
    WonoCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WonoCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        WonoCircleModel *model = dataArr[indexPath.row];
        cell.model = model;
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    
    if([cell.changeMark isEqualToString:@"1"]){
        NSLog(@"aaa");
        
        cell = [[WonoCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        WonoCircleModel *model = dataArr[indexPath.row];
        cell.model = model;
        cell.changeMark = @"0";
    }
    
//    if(ChangeMark == true){
//        cell = [[WonoCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        
//        WonoCircleModel *model = dataArr[indexPath.row];
//        cell.model = model;
//    }
    
    if(indexPath.row == dataArr.count-1){
        ChangeMark = false;
    }
    
    //    [cell creatConView];

//    WonoCircleModel *Remodel = dataArr[indexPath.row];
//    int askId = [Remodel.askId intValue];
//    WonoCircleModel *model = cell.model;
//    int reAskID = [model.askId intValue];
//    if(askId != reAskID){
//        cell = [[WonoCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        
//        cell.model = Remodel;
//    }
//    
    
    cell.cellBlock = ^(NSDictionary *dic) {
        NSLog(@"aaa");
        NSString *needID = dic[@"ID"];
        ToAnswerViewController *ans = [[ToAnswerViewController alloc]init];
        ans.askID = needID;
        ans.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ans animated:YES];
        
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击");
    
    WonoCircleModel *model = dataArr[indexPath.row];
    
    WonoCircleDetailViewController *detailVc = [[WonoCircleDetailViewController alloc]init];
    detailVc.qid = model.askId;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
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
    
    ToAskViewController *asdVC = [[ToAskViewController alloc]init];
    asdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:asdVC animated:YES];
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
