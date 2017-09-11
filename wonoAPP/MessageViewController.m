//
//  MessageViewController.m
//  wonoAPP
//
//  Created by IF on 2017/9/6.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "BBFlashCtntLabel.h"
#import "WonoCircleDetailViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation MessageViewController{
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createTabel];
    [self requestData];
    
}

-(void)requestData{
    
    dataArr = [NSMutableArray array];
    MessageModel *model = [[MessageModel alloc]init];
    model.type = 1;
    model.content = @"消息内容消息内容消息内容消息内容";
    model.needID = @"233";
    
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [_mainTableView reloadData];
    
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"消息";
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
    
    UIButton *hubBtn = [[UIButton alloc]init];
    hubBtn.backgroundColor = [UIColor clearColor];
    [hubBtn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:hubBtn];
    
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left);
        make.right.equalTo(_backBtn.mas_right).offset(HDAutoWidth(40));
        make.top.equalTo(_headView.mas_top);
        make.bottom.equalTo(_headView.mas_bottom);
    }];
}


-(void)BackClick{
    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTabel{
    
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    [self.view addSubview:_mainTableView];
    
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identy = @"cellIdenty";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *conView = [[UIView alloc]init];
    conView.backgroundColor = [UIColor whiteColor];
    conView.layer.masksToBounds  = YES;
    conView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    conView.layer.borderWidth = 0.3;
    [cell addSubview:conView];
    [conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(-1);
        make.right.equalTo(cell.mas_right).offset(1);
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
    }];
    
    
    MessageModel *model = dataArr[indexPath.row];
    
    BBFlashCtntLabel *label = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(HDAutoWidth(41), 0, SCREEN_WIDTH - HDAutoWidth(82), HDAutoHeight(100))];
    label.text = model.content;
    label.speed = -1;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [conView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(conView.mas_left).offset(HDAutoWidth(40));
//        make.top.equalTo(conView.mas_top);
//        make.bottom.equalTo(conView.mas_bottom);
//        make.right.equalTo(conView.mas_right).offset(-HDAutoWidth(150));
//    }];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(100);

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
    WonoCircleDetailViewController *wonoDetailVc = [[WonoCircleDetailViewController alloc]init];
    [self.navigationController pushViewController:wonoDetailVc animated:YES];
}
@end
