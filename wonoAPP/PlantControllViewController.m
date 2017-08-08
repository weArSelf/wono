//
//  PlantControllViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PlantControllViewController.h"
#import "PlantCell.h"
#import "PlantModel.h"
#import "SelectionViewController.h"
#import "WSDatePickerView.h"
#import "WorkViewController.h"

#import "AddViewController.h"


@interface PlantControllViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UITableView *plantTableView;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong)WSDatePickerView *datepicker;

@property (nonatomic,strong)NSDate *SelDate;

@property (nonatomic,strong)UIButton *workBtn;

@end

@implementation PlantControllViewController{
    UIButton *leftBtn;
    UIButton *rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBtn];
    
    [self CreateTitleLabelWithText:@"种植管理"];
    [self createHeadView];
    [self createTabelview];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWork];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)setBtn{
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(10, 5 , 40, 40);
    _selectBtn.backgroundColor = [UIColor clearColor];
    [_selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_selectBtn addTarget:self action:@selector(SelectClick) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationController.navigationBar addSubview:_selectBtn];
    
}

-(void)createTabelview{
    
    _plantTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _plantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _plantTableView.allowsSelection = NO;
    _plantTableView.dataSource = self;
    _plantTableView.delegate = self;
//    _plantTableView.showsVerticalScrollIndicator = NO;
    _plantTableView.backgroundColor = [UIColor clearColor];
//    _plantTableView.frame = self.view.frame;
   _plantTableView.showsVerticalScrollIndicator = NO;
   
    
    [self.view addSubview:_plantTableView];
    [_plantTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.headView.mas_bottom).offset(5);
    }];
    
    _plantTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _plantTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

-(void)refresh{
    NSLog(@"下拉刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_plantTableView.mj_header endRefreshing];
    });

}
-(void)loadMore{
    NSLog(@"上拉加载");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_plantTableView.mj_footer endRefreshing];
    });

    
}

-(void)SelectClick{
    NSLog(@"点击筛选了");
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideMiddle" object:nil];
    SelectionViewController *vc = [[SelectionViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    PlantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PlantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setLeftColor:[UIColor blueColor]];
    }
//    [cell creatConView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(140);

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HDAutoHeight(68);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc]init];
    
    headView.backgroundColor = [UIColor clearColor];
    
    headView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40);
    
//    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = @"本月";
    label.textColor = UIColorFromHex(0x727171);
    label.font = [UIFont systemFontOfSize:13];
    [headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(20);
        make.centerY.equalTo(headView.mas_centerY).offset(5);
        make.height.equalTo(@(35));
        make.width.equalTo(@(150));
    }];
    
    return headView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
    SelectionViewController *sec = [[SelectionViewController alloc]init];
    [self.navigationController pushViewController:sec animated:YES];
}




-(void)createHeadView{
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.layer.shadowColor = UIColorFromHex(0x4cb566).CGColor;
    _headView.layer.shadowOpacity = 0.3f;
//    _ConView.layer.shadowRadius =5;
    _headView.layer.shadowOffset = CGSizeMake(2,5);
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(HDAutoHeight(90)));
    }];
    leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"按员工" forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:UIColorFromHex(0x4db366)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_headView addSubview:leftBtn];
    
    rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"按时间" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    [_headView addSubview:rightBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left);
        make.width.equalTo(@(APP_CONTENT_WIDTH/2));
        make.top.equalTo(_headView.mas_top).offset(0.5);
        make.bottom.equalTo(_headView.mas_bottom);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headView.mas_right);
        make.width.equalTo(@(APP_CONTENT_WIDTH/2));
        make.top.equalTo(_headView.mas_top).offset(0.5);
        make.bottom.equalTo(_headView.mas_bottom);
    }];
}

-(void)leftClick{
    NSLog(@"点击按员工");
    [rightBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.backgroundColor = UIColorFromHex(0x4db366);
}

-(void)rightClick{
    NSLog(@"点击按时间");
    
    _datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        
        _SelDate = startDate;
        
        [leftBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
        leftBtn.backgroundColor = [UIColor whiteColor];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.backgroundColor = UIColorFromHex(0x4db366);
        
    }];
    if(_SelDate != nil){
        [_datepicker getNowDate:_SelDate animated:YES];
    }
    
    _datepicker.doneButtonColor = UIColorFromHex(0x3fb36f);//确定按钮的颜色
    
    [_datepicker show];
}

-(void)createWork{
    _workBtn = [[UIButton alloc]init];
    _workBtn.backgroundColor = MainColor;
    [_workBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_workBtn setTitle:@"开\n始\n干\n活" forState:UIControlStateNormal];
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
    NSLog(@"点击去工作");
    
    AddViewController *add = [[AddViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
//    WorkViewController *wor = [[WorkViewController alloc]init];
//    [self.navigationController pushViewController:wor animated:YES];
    
}

@end
