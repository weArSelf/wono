//
//  SelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

//蔬菜大棚

#import "SelectionViewController.h"
#import "PlantCell.h"
#import "StatisticsTableViewCell.h"
#import "PlantBaseModel.h"
#import "PengUpdateViewController.h"


@interface SelectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIView *firstView;

@property (nonatomic,strong) UITableView *plantTableView;


@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,strong)UIButton *xiugaiBtn;

@end

@implementation SelectionViewController{
    int fertilizer;
    int plant;
    int protect;
    PercentModel *model;
    int Count;
    NSMutableArray *dataArr;
    
    bool dataMark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataMark = false;
    dataArr = [NSMutableArray array];
    
    fertilizer = 0;
    plant = 0;
    protect = 0;
    
    Count = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    
    [self createFirseView];
    [self createTabelview];
//    [self createNextBtn];
    
}

-(void)createNextBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"修改" forState:UIControlStateNormal];
//    [_nextBtn setTitle:@"取消编辑" forState:UIControlStateSelected];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_nextBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_nextBtn];
    //    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(26)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
    UIButton *hubBtn = [[UIButton alloc]init];
    hubBtn.backgroundColor = [UIColor clearColor];
    [hubBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:hubBtn];
    
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right);
        make.height.equalTo(_headView.mas_height);
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
}

-(void)SaveClick{
    NSLog(@"点击编辑");
    PengUpdateViewController *updateVC = [[PengUpdateViewController alloc]init];
    updateVC.pengID = _pengID;
    [self.navigationController pushViewController:updateVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
   
}





-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"";
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
}

-(void)createFirseView{
    _firstView = [[UIView alloc]init];
    
    
    
//    _firstView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"图层-3"]];
    [self.view addSubview:_firstView];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-3"]];
    [_firstView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstView.mas_left);
        make.right.equalTo(_firstView.mas_right);
        make.top.equalTo(_firstView.mas_top);
        make.bottom.equalTo(_firstView.mas_bottom);
    }];
    
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_headView.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(300)));
    }];
    UILabel *label1 = [self mylabel];
    label1.tag = 200;
    label1.text = @"大棚名称: ";
//    种植品种
    UILabel *label2 = [self mylabel];
    label2.tag = 201;
    label2.text = @"占地面积: ";
    UILabel *label3 = [self mylabel];
    label3.tag = 202;
    label3.text = @"大棚类型: ";
    UILabel *label4 = [self mylabel];
    label4.tag = 203;
    label4.text = @"创建时间: ";
    
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

    int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
    if(userType == 1){
        _xiugaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xiugaiBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
        [_xiugaiBtn setTitle:@"修改大棚信息>" forState:UIControlStateNormal];
        _xiugaiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _xiugaiBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_xiugaiBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
        
        [_firstView addSubview:_xiugaiBtn];
        
        [_xiugaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(_firstView.mas_right).offset(-HDAutoWidth(0));
            make.bottom.equalTo(label4.mas_bottom);
            make.top.equalTo(label4.mas_top);
            make.width.equalTo(@(HDAutoWidth(250)));
            
        }];
    }
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
    
//    _plantTableView.panGestureRecognizer.delegate = self;
    
//    _plantTableView.scrollEnabled = false;
    
//    if (@available(iOS 11.0, *)){
//        _plantTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _plantTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
//        _plantTableView.scrollIndicatorInsets = _plantTableView.contentInset;
//    }

    
    [self.view addSubview:_plantTableView];
    [_plantTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.firstView.mas_bottom).offset(5);
    }];
    
    _plantTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _plantTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [_plantTableView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        [_plantTableView setScrollEnabled:NO];
        UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"加载数据中...";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(190), 300, HDAutoHeight(60));
        
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:label];
        
        return view;
    } normalBlock:^(UITableView * _Nonnull sender) {
        [_plantTableView setScrollEnabled:YES];
    }];
    [_plantTableView reloadData];
    
    _plantTableView.mj_footer.hidden = YES;
}

-(void)refresh{
    NSLog(@"下拉刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Count = 1;
        [self requestCircleDataWithGid];
        [self requestList];
        
//        [_plantTableView.mj_header endRefreshing];
    });
    
}
-(void)loadMore{
    NSLog(@"上拉加载");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Count++;
//        [self requestCircleDataWithGid];
        [self requestList];
//        [_plantTableView.mj_footer endRefreshing];
//    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(dataMark == false){
        return 0;
    }
    if(section == 0){
        return 1;
    }
    PlantBaseModel *baseModel = dataArr[section-1];
    NSArray *arr = baseModel.arr;
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArr.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        static NSString *cellIdentifier = @"cellIdentifier2";
        StatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[StatisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           

        }
        if(model){
            cell.model = model;
        }
        return cell;
    }
    
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PlantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PlantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    //    [cell creatConView];
    
    PlantBaseModel *baseModel = dataArr[indexPath.section-1];
    PlantModel *model2 = baseModel.arr[indexPath.row];
    
    
    
    int typeMark = [model2.typeStr intValue];
    switch (typeMark) {
        case 1:{
            [cell setLeftColor:UIColorFromHex(0x4db366)];
            //            model.typeStr = @"种植";
            break;
        }
        case 2:{
            [cell setLeftColor:UIColorFromHex(0x795548)];
            //            model.typeStr = @"施肥";
            break;
        }
            
        case 3:{
            [cell setLeftColor:UIColorFromHex(0x2196f3)];
            //            model.typeStr = @"植保";
            break;
        }
            
        case 4:{
            [cell setLeftColor:UIColorFromHex(0xffc107)];
            //            model.typeStr = @"采收";
            break;
        }
            
            
        default:
            break;
    }
    
    cell.model = model2;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return HDAutoHeight(510);
    }
    
    return HDAutoHeight(140);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0.01;
    }
    return HDAutoHeight(68);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        UIView *view = [[UIView alloc]init];
        return view;
    }
    
    UIView *headView = [[UIView alloc]init];
    
    headView.backgroundColor = [UIColor clearColor];
    
    headView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40);
    
    //    headView.backgroundColor = [UIColor clearColor];
    PlantBaseModel *model123 = dataArr[section-1];
    UILabel *label = [[UILabel alloc]init];
    
    label.text = model123.name;
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

-(void)setPengID:(NSString *)pengID{
    _pengID = pengID;
    Count = 1;
//    [self requestData];
    [self requestCircleDataWithGid];
    [self requestList];
}

-(void)requestData{
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengDetailWithPengID:_pengID WithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            NSLog(@"成功");
            
            NSDictionary *dic = data;
            
            NSString *name = dic[@"name"];
            _titleLabel.text = name;
            
            
            NSString *str1 = dic[@"variety_name"];
            NSString *str2 = dic[@"area"];
            int num2 = [str2 intValue];
            NSString *str3 = dic[@"type_name"];
            NSString *str4 = dic[@"build"];
            
            UILabel *label1 = [self.view viewWithTag:200];
            label1.text = [NSString stringWithFormat:@"大棚名称: %@",name];
//            种植品种
            UILabel *label2 = [self.view viewWithTag:201];
            label2.text = [NSString stringWithFormat:@"占地面积: %d亩",num2];
            UILabel *label3 = [self.view viewWithTag:202];
            label3.text = [NSString stringWithFormat:@"大棚类型: %@",str3];
            UILabel *label4 = [self.view viewWithTag:203];
            label4.text = [NSString stringWithFormat:@"创建时间: %@",str4];
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}

-(void)requestCircleDataWithGid{
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengPayWithGid:_pengID AndCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_footer endRefreshing];
        [_plantTableView.mj_header endRefreshing];
        if(state == 2000){
            NSLog(@"成功");
            
            NSDictionary *dic = data;
            fertilizer = [dic[@"fertilizer"]intValue];
            plant = [dic[@"plant"]intValue];
            protect = [dic[@"protect"]intValue];
            
            int total = fertilizer + plant + protect;
            
            double per1 = (double)fertilizer/total*100;
            double per2 = (double)plant/total*100;
            double per3 = (double)protect/total*100;
            
            NSArray *nameArr1 = [NSArray arrayWithObjects:@"施肥",@"种植",@"植保", nil];
            
            NSMutableArray *nameArr = [NSMutableArray array];
            
            NSArray *perArr1 = [NSArray arrayWithObjects:[NSNumber numberWithDouble:per1],[NSNumber numberWithDouble:per2],[NSNumber numberWithDouble:per3], nil];
            
            NSMutableArray *perArr = [NSMutableArray array];
            
            UIColor *color1 = UIColorFromHex(0x795548);
            UIColor *color2 = UIColorFromHex(0x4db366);
            UIColor *color3 = UIColorFromHex(0x2196f3);
            
            NSArray *colorArr1 = [NSArray arrayWithObjects:color1,color2,color3, nil];
            
            NSMutableArray *colorArr = [NSMutableArray array];

            
            if(per1 != 0){
                
                [nameArr addObject:@"施肥"];
                [perArr addObject:[NSNumber numberWithDouble:per1]];
                [colorArr addObject:color1];
                
            }
            if(per2 != 0){
                [nameArr addObject:@"种植"];
                [perArr addObject:[NSNumber numberWithDouble:per2]];
                [colorArr addObject:color2];

               
            }
            if(per3 != 0){
                [nameArr addObject:@"植保"];
                [perArr addObject:[NSNumber numberWithDouble:per3]];
                [colorArr addObject:color3];

              
            }
            
            if(nameArr.count==0){
                [MBProgressHUD showSuccess:@"暂无大棚支出记录"];
                return;
            }
            
            model = [[PercentModel alloc]init];
            
            model.nameArr = nameArr;
            model.percentArr = perArr;
            model.title = @"大棚支出记录";
            
            model.colorArr  = colorArr;
            
            [_plantTableView reloadData];
            
            
//            percentArr = [NSArray arrayWithObjects:[NSNumber numberWithDouble:20.0],[NSNumber numberWithDouble:30.0],[NSNumber numberWithDouble:40.0],[NSNumber numberWithDouble:10.0], nil];
//            dataArr = [NSArray arrayWithObjects:@"土豆",@"黄瓜",@"西红柿",@"白菜", nil];
            
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}

-(void)requestList{
    
    if(Count == 1){
        dataArr = [NSMutableArray array];
    }
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengListWithGid:_pengID AndPage:Count WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_footer endRefreshing];
        [_plantTableView.mj_header endRefreshing];
        if(state == 2000){
            NSLog(@"成功");
            dataMark = YES;
            
            NSArray *arr = data[@"data"];
            
            if(arr.count>0){
                _plantTableView.mj_footer.hidden = NO;
            }
            
           
            
            if(arr.count == 0){
                if(Count!=1){
                    Count--;
                    [_plantTableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
            }else{
                [_plantTableView.mj_footer endRefreshing];
            }
            
            for (int i = 0 ; i<arr.count; i++) {
                
                
                NSDictionary *dic = arr[i];
                
                PlantBaseModel *baseModel = [[PlantBaseModel alloc]init];
                
                baseModel.arr = [NSMutableArray array];
                
                baseModel.name = dic[@"name"];
                NSArray *arr2 = dic[@"plant"];
                //                baseModel.arr = arr2;
                
                for(int j=0;j<arr2.count;j++){
                    
                    NSDictionary *dic2 = arr2[j];
                    
                    PlantModel *model2 = [[PlantModel alloc]init];
                    model2.dateStr = dic2[@"week"];
                    model2.timeStr = dic2[@"time"];
                    model2.nameStr = dic2[@"title"];
                    model2.typeStr = dic2[@"plant_type_id"];
                    model2.numberStr = dic2[@"total_amount"];
                    model2.extraStr = dic2[@"variety_name"];
                    
                    model2.pengID = dic2[@"gid"];
                    
                    NSString *typeS = [NSString stringWithFormat:@"%@",dic2[@"plant_type_id"]];
                    if([typeS isEqualToString:@"1"]){
                        
                        NSString *needStr = [NSString stringWithFormat:@"%@株/粒",dic2[@"amount"]];
                        model2.numberStr = needStr;
                    }
                    
                    [baseModel.arr addObject:model2];
                }
                
                [dataArr addObject:baseModel];
                
            }
            
            [_plantTableView reloadData];
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}



@end
