//
//  PengTypeViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/10.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ShifeiTypeViewController.h"
//#import "PengAddViewController.h"
#import "ShifeiViewController.h"
#import "PengTypeModel.h"

@interface ShifeiTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong) UITableView *contentTableView;

@end

@implementation ShifeiTypeViewController{
    NSMutableArray *dataArr;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    dataArr = [NSArray arrayWithObjects:@"蔬菜",@"花卉",@"水果",@"橘子",@"🍊",nil];
    
    [self creatTitleAndBackBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"施肥品种";
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
        make.height.equalTo(@(SafeAreaTopRealHeight));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.top.equalTo(_headView.mas_top).offset(24+SafeAreaTopHeight);
        make.width.equalTo(@(26));
        make.height.equalTo(@(26));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(300));
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
    
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"catChange" object:nil];
    //    for (UIViewController *controller in self.navigationController.viewControllers) {
    //        if ([controller isKindOfClass:[PengAddViewController class]]) {
    //            PengAddViewController *A =(PengAddViewController *)controller;
    //            [self.navigationController popToViewController:A animated:YES];
    //        }
    //    }
    
    
    
}



-(void)createTable{
    
    _contentTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.backgroundColor = [UIColor clearColor];
    //    _plantTableView.frame = self.view.frame;
    _contentTableView.showsVerticalScrollIndicator = NO;
    //    _contentTableView.scrollEnabled = NO;
    _contentTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
    [self.view addSubview:_contentTableView];
    
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = UIColorFromHex(0xf8f8f8);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = dataArr[indexPath.row];
    titleLabel.textColor = UIColorFromHex(0x9fa0a0);
    titleLabel.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@(HDAutoHeight(60)));
        make.left.equalTo(@(HDAutoWidth(32)));
        make.width.equalTo(@(120));
    }];
    UIView *botView = [[UIView alloc]init];
    botView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.right.equalTo(cell.contentView.mas_right);
        make.height.equalTo(@(1));
        make.bottom.equalTo(cell.contentView.mas_bottom);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PengTypeModel *model = _NowdataArr[indexPath.row];
    int child = [model.child intValue];
    
    if(child != 0){
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"我的-进入"];
        [cell.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-HDAutoWidth(32));
            make.width.equalTo(@(HDAutoWidth(60)));
            make.height.equalTo(@(HDAutoWidth(60)));
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(80)+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PengTypeModel *model = _NowdataArr[indexPath.row];
    
    NSString *pid = model.typeId;
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle:) name:@"catChange" object:nil];
    
    
    
    
    int child = [model.child intValue];
    
    if(child == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"catChange" object:model];
    }
    
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengWithCatPid:pid WithType:@"2" AndCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            NSLog(@"");
            NSMutableArray *RdataArr = [NSMutableArray array];
            
            NSArray *arr = data;
            
            for (int i=0; i<arr.count; i++) {
                PengTypeModel *model = [[PengTypeModel alloc]init];
                NSDictionary *dic = arr[i];
                model.typeName = dic[@"name"];
                model.typeId = dic[@"id"];
                model.child = dic[@"child"];
                [RdataArr addObject:model];
            }
            
            
            
            ShifeiTypeViewController *pengtype = [[ShifeiTypeViewController alloc]init];
            pengtype.NowdataArr = RdataArr;
            
            [self.navigationController pushViewController:pengtype animated:YES];
            
        }
        if(state == 2001){
            //            [self.navigationController popViewControllerAnimated:YES];
            
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ShifeiViewController class]]) {
                    ShifeiViewController *A =(ShifeiViewController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }
            
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
    
    
    //    PengTypeViewController *pengType = [[PengTypeViewController alloc]init];
    //    [self.navigationController pushViewController:pengType animated:YES];
    //
    //    NSLog(@"%ld",(long)indexPath.row);
}

-(void)setNowdataArr:(NSArray *)NowdataArr{
    _NowdataArr = NowdataArr;
    dataArr = [NSMutableArray array];
    for (int i=0; i<_NowdataArr.count; i++) {
        PengTypeModel *model = _NowdataArr[i];
        [dataArr addObject:model.typeName];
    }
    
    [self createTable];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
