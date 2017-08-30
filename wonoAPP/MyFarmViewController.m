//
//  MyFarmViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MyFarmViewController.h"
#import "MyFarmTableViewCell.h"
#import "WSDatePickerView.h"
#import "NeedSelectionViewController.h"

@interface MyFarmViewController ()<UITableViewDelegate,UITableViewDataSource,SelectDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UITableView *contentTabel;

@property (nonatomic,strong)WSDatePickerView *datepicker;
@property (nonatomic,strong)NSDate *SelDate;

@end

@implementation MyFarmViewController{
    NSArray *firstDataArr;
    NSMutableArray *nextDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self creatHeadView];
    
    firstDataArr = [NSArray arrayWithObjects:@"地理位置",@"占地面积",@"大棚总数",@"员工总数",@"成立时间", nil];
    NSArray *arr = [NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
//    NSArray *arr = [NSArray arrayWithObjects:@"天津市",@"35亩",@"14座",@"100个",@"2014年7月12日", nil];
    
    nextDataArr = [NSMutableArray arrayWithArray:arr];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:@"2010-08-04 16:01:03"];
    
    [self createTable];
    [self requestData];
}

-(void)requestData{
    [_contentTabel.mj_header beginRefreshing];
    [[InterfaceSingleton shareInstance].interfaceModel getMyFarmWithCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            nextDataArr = [NSMutableArray array];
            NSDictionary *dic = data;
            [nextDataArr addObject:dic[@"address"]];
            [nextDataArr addObject:dic[@"area"]];
            [nextDataArr addObject:dic[@"greenhouse_num"]];
            [nextDataArr addObject:dic[@"employee_num"]];
            [nextDataArr addObject:dic[@"build"]];
            
            [_contentTabel reloadData];
            
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"我的农场";
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


-(void)creatHeadView{
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.image = [UIImage imageNamed:@"矩形-3"];
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headView.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(300)));
    }];
}

-(void)createTable{
    
    _contentTabel = [[UITableView alloc]init];
    _contentTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTabel.showsVerticalScrollIndicator = NO;
    _contentTabel.delegate = self;
    _contentTabel.dataSource = self;
    _contentTabel.scrollEnabled = NO;
    _contentTabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentTabel];
    [_contentTabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headImageView.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(700)));
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    MyFarmTableViewCell *myFarmCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(myFarmCell == nil){
        myFarmCell = [[MyFarmTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        myFarmCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row!=0){
            myFarmCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    NSString *firStr = firstDataArr[indexPath.row];
    NSString *nextStr = nextDataArr[indexPath.row];
    [myFarmCell createContentWithLeftStr:firStr AndRightStr:nextStr];
    
    return myFarmCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(80)+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:{
            NeedSelectionViewController *neeSel = [[NeedSelectionViewController alloc]init];
            neeSel.delegate = self;
            [neeSel changeStyle:zhandiStyle];
            neeSel.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:neeSel animated:YES];
            break;
        }
        case 2:{
            NeedSelectionViewController *neeSel = [[NeedSelectionViewController alloc]init];
            neeSel.delegate = self;
            [neeSel changeStyle:dapengStyle];
            neeSel.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:neeSel animated:YES];
            break;
        }
        case 3:{
            NeedSelectionViewController *neeSel = [[NeedSelectionViewController alloc]init];
            neeSel.delegate = self;
            [neeSel changeStyle:yuangongStyle];
            neeSel.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:neeSel animated:YES];
            break;
        }
       
        case 4:{
            [self rightClick];
            break;
        }
            
        default:
            break;
    }
}


-(void)rightClick{
    NSLog(@"点击按时间");
    
    _datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy年MM月dd日"];
        NSLog(@"时间： %@",date);
        
        _SelDate = startDate;
        
        nextDataArr[4] = date;
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        
        [_contentTabel reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationRight];
    }];
    if(_SelDate != nil){
        [_datepicker getNowDate:_SelDate animated:YES];
    }
    
    _datepicker.doneButtonColor = UIColorFromHex(0x3fb36f);//确定按钮的颜色
    
    [_datepicker show];
}

-(void)clickConfirmWithType:(FarmStyle)type AndStr:(NSString *)str{
    int NeedIndex = type + 1;
    
    if(type == yuangongStyle){
        str = [NSString stringWithFormat:@"%@个",str];
    }else if(type == dapengStyle){
        str = [NSString stringWithFormat:@"%@座",str];
    }else if(type == zhandiStyle){
        str = [NSString stringWithFormat:@"%@亩",str];
    }
    
    nextDataArr[NeedIndex] = str;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:NeedIndex inSection:0];
    [_contentTabel reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationRight];
//    if(type == zhandiStyle){
//        nextDataArr[1] = str;
//    }else if (type == dapengStyle){
//        nextDataArr[2] = str;
//    }else if(type == yuangongStyle){
//        nextDataArr[3] = str;
//    }
    
}



@end
