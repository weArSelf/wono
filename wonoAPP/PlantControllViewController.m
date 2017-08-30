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

#import "ScreenDetailViewController.h"
#import "ScreenDetailModel.h"
#import "PlantBaseModel.h"

@interface PlantControllViewController ()<UITableViewDelegate,UITableViewDataSource,ScreenDetailDelegate>

@property (nonatomic,strong)UIView *headView2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

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
    NSMutableArray *dataArr;
    int Count;
    NSString *selID;
    
    NSString *type;
    NSString *typeContent;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBtn];
    type = @"0";
    
    selID = @"-10";
    dataArr = [NSMutableArray array];
    Count = 1;
    [self creatTitleAndBackBtn];
//    [self CreateTitleLabelWithText:@"种植管理"];
    [self createHeadView];
    [self createTabelview];
    _plantTableView.mj_footer.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWork];
    // Do any additional setup after loading the view.
    [self requestData];
    
    
}

-(void)creatTitleAndBackBtn{
    
    _headView2 = [[UIView alloc]init];
    _headView2.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView2.alpha = 0.8;
    [self.view addSubview:_headView2];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"种植管理";
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _plantTableView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _plantTableView.alpha = 1;
    }];
    
//    [self requestData];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    [_headView layoutIfNeeded];
    [self.view layoutIfNeeded];
    _plantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headView.y+5, SCREEN_WIDTH, SCREEN_HEIGHT - _headView.y-5 -49) style:UITableViewStyleGrouped];
//    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _plantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _plantTableView.allowsSelection = NO;
    _plantTableView.dataSource = self;
    _plantTableView.delegate = self;
//    _plantTableView.showsVerticalScrollIndicator = NO;
    _plantTableView.backgroundColor = [UIColor whiteColor];
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
    
    [self.view layoutIfNeeded];
    [_plantTableView layoutIfNeeded];
    [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
//        [_plantTableView setScrollEnabled:NO];
        UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"加载数据中...";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(390), 300, HDAutoHeight(60));
        [view addSubview:label];
        
        
        return view;
    } normalBlock:^(UITableView * _Nonnull sender) {
        [_plantTableView setScrollEnabled:YES];
    }];
    [_plantTableView reloadData];
}

-(void)refresh{
    NSLog(@"下拉刷新");
    Count = 1;
    [_plantTableView.mj_header beginRefreshing];
    if([type isEqualToString:@"0"]){
        [self requestData];
    }else if ([type isEqualToString:@"1"]){
        [self requestDataWithStufStr:typeContent];
    }else if ([type isEqualToString:@"2"]){
        [self requestDataWithTime:typeContent];
    }
    
    
//    [_plantTableView.mj_header endRefreshing];
//    [_plantTableView.mj_footer endRefreshing];
    
//    [self.view layoutIfNeeded];
//    [_plantTableView layoutIfNeeded];


}
-(void)loadMore{
    NSLog(@"上拉加载");
    Count++;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([type isEqualToString:@"0"]){
            [self requestData];
        }else if ([type isEqualToString:@"1"]){
            [self requestDataWithStufStr:typeContent];
        }else if ([type isEqualToString:@"2"]){
            [self requestDataWithTime:typeContent];
        }
    
//    });

    
}

-(void)SelectClick{
    NSLog(@"点击筛选了");
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideMiddle" object:nil];
    SelectionViewController *vc = [[SelectionViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    PlantBaseModel *baseModel = dataArr[section];
    NSArray *arr = baseModel.arr;
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArr.count;
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
    
    PlantBaseModel *baseModel = dataArr[indexPath.section];
    PlantModel *model = baseModel.arr[indexPath.row];
    
   
    
    int typeMark = [model.typeStr intValue];
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
    
    cell.model = model;
    
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
    PlantBaseModel *baseModel = dataArr[indexPath.section];
    PlantModel *model = baseModel.arr[indexPath.row];
    
    NSString *needID = model.pengID;
    
    SelectionViewController *sec = [[SelectionViewController alloc]init];
    
    sec.pengID = needID;
    
    sec.hidesBottomBarWhenPushed = YES;
    
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
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
//    UIColorFromHex(0x4db366)
    
//    leftBtn.layer.masksToBounds = YES;
//    leftBtn.layer.borderColor = UIColorFromHex(0x4db366).CGColor;
//    leftBtn.layer.borderWidth = 1;
    
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    [_headView addSubview:leftBtn];
    
    rightBtn = [[UIButton alloc]init];
//    rightBtn.layer.masksToBounds = YES;
//    rightBtn.layer.borderColor = UIColorFromHex(0x4db366).CGColor;
//    rightBtn.layer.borderWidth = 1;
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
        make.left.equalTo(@(APP_CONTENT_WIDTH/2));
        make.top.equalTo(_headView.mas_top).offset(0.5);
        make.bottom.equalTo(_headView.mas_bottom);
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromHex(0x4db366);
    
    view.alpha = 0.3;
    
    [_headView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.width.equalTo(@(1));
        make.height.equalTo(leftBtn.mas_height);
        make.centerY.equalTo(leftBtn.mas_centerY);
    }];
    
}

-(void)leftClick{
    NSLog(@"点击按员工");
    
//    [rightBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
//    rightBtn.backgroundColor = [UIColor whiteColor];
//    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    leftBtn.backgroundColor = UIColorFromHex(0x4db366);
    
    ScreenDetailViewController *sc = [[ScreenDetailViewController alloc]init];
    
    sc.delegate = self;
    
    sc.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:sc animated:YES];
    
}

-(void)rightClick{
    NSLog(@"点击按时间");
    
    _datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"时间： %@",date);
        
        Count = 1;
        [self requestDataWithTime:date];
        
        _SelDate = startDate;
        
        [leftBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
        leftBtn.backgroundColor = [UIColor whiteColor];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.backgroundColor = UIColorFromHex(0x4db366);
        
    }];
    NSDate *date = [NSDate date];
    _datepicker.maxLimitDate = date;
    
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
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
//    WorkViewController *wor = [[WorkViewController alloc]init];
//    [self.navigationController pushViewController:wor animated:YES];
    
}

-(void)requestData{
    
    type = @"0";

    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    MainPlantModel *model = [[MainPlantModel alloc]init];
    model.fid = str;
    model.page = Count;
    
//    int zxc = [selID intValue];
//    if(zxc!=-10){
//        model.uid = selID;
//    }
    
    if(Count == 1){
        dataArr = [NSMutableArray array];
    }
    
    [[InterfaceSingleton shareInstance].interfaceModel getMainPlantWithModel:model WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_header endRefreshing];
        [_plantTableView.mj_footer endRefreshing];
        if(state == 2000){
            NSLog(@"成功");
            

            NSArray *arr = data[@"data"];
            for (int i = 0 ; i<arr.count; i++) {
                
                
                NSDictionary *dic = arr[i];
                
                PlantBaseModel *baseModel = [[PlantBaseModel alloc]init];
                
                baseModel.arr = [NSMutableArray array];
                
                baseModel.name = dic[@"name"];
                NSArray *arr2 = dic[@"plant"];
//                baseModel.arr = arr2;
                
                for(int j=0;j<arr2.count;j++){
                    
                    NSDictionary *dic2 = arr2[j];
                    
                    PlantModel *model = [[PlantModel alloc]init];
                    model.dateStr = dic2[@"week"];
                    model.timeStr = dic2[@"time"];
                    model.nameStr = dic2[@"title"];
                    model.typeStr = dic2[@"plant_type_id"];
                    model.numberStr = dic2[@"total_amount"];
                    model.extraStr = dic2[@"variety_name"];
                    
                    model.pengID = dic2[@"gid"];
                    
                    [baseModel.arr addObject:model];
                }
                
                [dataArr addObject:baseModel];

            }
            
            _plantTableView.mj_footer.hidden = NO;
            [_plantTableView reloadData];
            
        }else{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.text = @"暂无数据";
                    label.font = [UIFont systemFontOfSize:16];
                    label.textColor = MainColor;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(390), 300, HDAutoHeight(60));
                    [view addSubview:label];
                    
                    
                    return view;
                } normalBlock:^(UITableView * _Nonnull sender) {
                    [_plantTableView setScrollEnabled:YES];
                }];
                [_plantTableView reloadData];

            });
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];

}

-(void)selectWithDic:(NSDictionary *)dic{
    
    [rightBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.backgroundColor = UIColorFromHex(0x4db366);
    
    NSArray *arr = [dic allValues];
    
    Count = 1;
    if(arr.count == 0){
        
        [self requestData];
        
    }else{
    
        NSString *str = [self objArrayToJSON:arr];
        [self requestDataWithStufStr:str];
        
    }
    
    
    
}


- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        ScreenDetailModel *model = array[i];
        NSString *str = model.needId;
        int a = [str intValue];
        NSString *res = [NSString stringWithFormat:@"%d",a];
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:res];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}


//-(void)selectWithDic:(ScreenDetailModel *)model{
//    
////    if([model.needId intValue]==-10){
//    
//    selID = model.needId;
//        Count = 1;
//        [self requestData];
//        
////    }else{
////    
////        Count = 1;
////        [self requestDataWithStufID:model.needId];
////        
////    }
//    
//}
-(void)requestDataWithStufStr:(NSString *)stufStr{
    
    type = @"1";
    typeContent = stufStr;
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    MainPlantModel *model = [[MainPlantModel alloc]init];
    model.fid = str;
    model.page = Count;
    model.uid = stufStr;
    
    
//    int zxc = [selID intValue];
//    if(zxc!=-10){
//        model.uid = selID;
//    }
    
    if(Count == 1){
        dataArr = [NSMutableArray array];
    }
    
    [[InterfaceSingleton shareInstance].interfaceModel getMainPlantWithModel:model WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_header endRefreshing];
        [_plantTableView.mj_footer endRefreshing];
        if(state == 2000){
            NSLog(@"成功");

            NSArray *arr = data[@"data"];
            for (int i = 0 ; i<arr.count; i++) {
                
                
                NSDictionary *dic = arr[i];
                
                PlantBaseModel *baseModel = [[PlantBaseModel alloc]init];
                
                baseModel.arr = [NSMutableArray array];
                
                baseModel.name = dic[@"name"];
                NSArray *arr2 = dic[@"plant"];
                //                baseModel.arr = arr2;
                
                for(int j=0;j<arr2.count;j++){
                    
                    NSDictionary *dic2 = arr2[j];
                    
                    PlantModel *model = [[PlantModel alloc]init];
                    model.dateStr = dic2[@"week"];
                    model.timeStr = dic2[@"time"];
                    model.nameStr = dic2[@"title"];
                    model.typeStr = dic2[@"plant_type_id"];
                    model.numberStr = dic2[@"total_amount"];
                    model.extraStr = dic2[@"variety_name"];
                    
                    model.pengID = dic2[@"gid"];
                    [baseModel.arr addObject:model];
                }
                
                [dataArr addObject:baseModel];
                
            }
            
            [_plantTableView reloadData];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.text = @"暂无数据";
                    label.font = [UIFont systemFontOfSize:16];
                    label.textColor = MainColor;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(390), 300, HDAutoHeight(60));
                    [view addSubview:label];
                    
                    
                    return view;
                } normalBlock:^(UITableView * _Nonnull sender) {
                    [_plantTableView setScrollEnabled:YES];
                }];
                [_plantTableView reloadData];
                
            });
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
}
-(void)requestDataWithTime:(NSString *)time{
    
    
    type = @"2";
    
    typeContent = time;
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    MainPlantModel *model = [[MainPlantModel alloc]init];
    model.fid = str;
    model.page = Count;
    model.date = time;
    
    
    //    int zxc = [selID intValue];
    //    if(zxc!=-10){
    //        model.uid = selID;
    //    }
    
    if(Count == 1){
        dataArr = [NSMutableArray array];
    }
//    UIView *view = (UIView *)[_plantTableView viewWithTag:450];
//    
//    UILabel *label = (UILabel *)[view viewWithTag:444];
//    label.text = @"暂无数据，请重试。";
    
   
    
    [[InterfaceSingleton shareInstance].interfaceModel getMainPlantWithModel:model WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_header endRefreshing];
        [_plantTableView.mj_footer endRefreshing];
        if(state == 2000){
            NSLog(@"成功");

            NSArray *arr = data[@"data"];
            for (int i = 0 ; i<arr.count; i++) {
                
                
                NSDictionary *dic = arr[i];
                
                PlantBaseModel *baseModel = [[PlantBaseModel alloc]init];
                
                baseModel.arr = [NSMutableArray array];
                
                baseModel.name = dic[@"name"];
                NSArray *arr2 = dic[@"plant"];
                //                baseModel.arr = arr2;
                
                for(int j=0;j<arr2.count;j++){
                    
                    NSDictionary *dic2 = arr2[j];
                    
                    PlantModel *model = [[PlantModel alloc]init];
                    model.dateStr = dic2[@"week"];
                    model.timeStr = dic2[@"time"];
                    model.nameStr = dic2[@"title"];
                    model.typeStr = dic2[@"plant_type_id"];
                    model.numberStr = dic2[@"total_amount"];
                    model.extraStr = dic2[@"variety_name"];
                    
                    model.pengID = dic2[@"gid"];
                    [baseModel.arr addObject:model];
                }
                
                [dataArr addObject:baseModel];
                
            }
            
            [_plantTableView reloadData];
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *label = [[UILabel alloc]init];
                    label.text = @"暂无数据";
                    label.font = [UIFont systemFontOfSize:16];
                    label.textColor = MainColor;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.frame = CGRectMake(APP_CONTENT_WIDTH/2-150, HDAutoHeight(390), 300, HDAutoHeight(60));
                    [view addSubview:label];
                    
                    
                    return view;
                } normalBlock:^(UITableView * _Nonnull sender) {
                    [_plantTableView setScrollEnabled:YES];
                }];
                [_plantTableView reloadData];
                
            });

            
        }
        
        
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
}



@end
