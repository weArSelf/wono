//
//  StatisticsViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsTableViewCell.h"
#import "Charts/Charts.h"

@interface StatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (strong, nonatomic) PieChartView *chartView;
@property (nonatomic,strong) UITableView *contentTabel;

@end

@implementation StatisticsViewController{
    NSArray *dataArr;
    NSArray *percentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    percentArr = [NSArray arrayWithObjects:[NSNumber numberWithDouble:20.0],[NSNumber numberWithDouble:30.0],[NSNumber numberWithDouble:40.0],[NSNumber numberWithDouble:10.0], nil];
    dataArr = [NSArray arrayWithObjects:@"土豆",@"黄瓜",@"西红柿",@"白菜", nil];
    
    [self CreateTitleLabelWithText:@"农场概况"];
    
    [self createTabelview];
}

-(void)createTabelview{
    
    _contentTabel = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _contentTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _plantTableView.allowsSelection = NO;
    _contentTabel.dataSource = self;
    _contentTabel.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _contentTabel.backgroundColor = [UIColor clearColor];
    //    _plantTableView.frame = self.view.frame;
    _contentTabel.showsVerticalScrollIndicator = NO;
    
    
    [self.view addSubview:_contentTabel];
    [_contentTabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
    }];
    
//    _contentTabel.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    _contentTabel.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

-(void)refresh{
    NSLog(@"下拉刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_contentTabel.mj_header endRefreshing];
    });
    
}
-(void)loadMore{
    NSLog(@"上拉加载");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_contentTabel.mj_footer endRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"cellIdentifier";
    StatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[StatisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(510);
}




@end
