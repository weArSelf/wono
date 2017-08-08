//
//  SelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "SelectionViewController.h"
#import "PlantCell.h"

@interface SelectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIView *firstView;

@property (nonatomic,strong) UITableView *plantTableView;


@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self createFirseView];
    [self createTabelview];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"AppearMiddle" object:nil];
    
}


-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"蔬菜大棚";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_titleLabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"0-返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_headView addSubview:_backBtn];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(64));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.top.equalTo(_headView.mas_top).offset(24);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
}

-(void)BackClick{
    NSLog(@"点击返回");
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createFirseView{
    _firstView = [[UIView alloc]init];
    _firstView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"图层-3"]];
    [self.view addSubview:_firstView];
    
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headView.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(300)));
    }];
    UILabel *label1 = [self mylabel];
    label1.text = @"种植品种: 西红柿";
    UILabel *label2 = [self mylabel];
    label2.text = @"占地面积: 10亩";
    UILabel *label3 = [self mylabel];
    label3.text = @"大棚类型: 某某类型";
    UILabel *label4 = [self mylabel];
    label4.text = @"创建时间: 2017-05-02";
    
    [_firstView addSubview:label1];
    [_firstView addSubview:label2];
    [_firstView addSubview:label3];
    [_firstView addSubview:label4];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstView.mas_left).offset(HDAutoWidth(35));
        make.top.equalTo(_firstView.mas_top).offset(HDAutoHeight(55));
        make.height.equalTo(@(HDAutoHeight(36)));
        make.width.equalTo(@(HDAutoWidth(600)));
        
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstView.mas_left).offset(HDAutoWidth(35));
        make.top.equalTo(label1.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(36)));
        make.width.equalTo(@(HDAutoWidth(600)));
        
    }];

    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstView.mas_left).offset(HDAutoWidth(35));
        make.top.equalTo(label2.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(36)));
        make.width.equalTo(@(HDAutoWidth(600)));
        
    }];

    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstView.mas_left).offset(HDAutoWidth(35));
        make.top.equalTo(label3.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(36)));
        make.width.equalTo(@(HDAutoWidth(600)));
        
    }];

    
}

-(UILabel *)mylabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0xffffff);
    return label;
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-44);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.firstView.mas_bottom).offset(5);
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



@end
