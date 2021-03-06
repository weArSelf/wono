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

@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UIButton *hubBtn;


@end

@implementation PlantControllViewController{
    UIButton *leftBtn;
    UIButton *rightBtn;
    NSMutableArray *dataArr;
    int Count;
    NSString *selID;
    
    NSString *type;
    NSString *typeContent;
    NSString *SelTime;
    
    int upCount;
    int donwCount;
    
    BOOL alMark;
    
    int wonoAlertMark;
    
    int orgRefMark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    orgRefMark = 1;
//    [self setBtn];
    wonoAlertMark = 1;
    alMark = false;
    type = @"0";
    
    selID = @"-10";
    dataArr = [NSMutableArray array];
    Count = 1;
    [self creatTitleAndBackBtn];
//    [self CreateTitleLabelWithText:@"种植管理"];
    [self createHeadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    int nongChangHave = [[[NSUserDefaults standardUserDefaults]objectForKey:@"fid"]intValue];
    NSString *pengHave = [[NSUserDefaults standardUserDefaults]objectForKey:@"pengID"];
    int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(re) name:@"plantChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WonoStateChange) name:@"WonoStateChange" object:nil];
    
    [self createNextBtn];
    if(userType == 1){

        [self createTabelview];
        _plantTableView.mj_footer.hidden = YES;
        // Do any additional setup after loading the view.
        [self requestData];
        [self createWork];
    }else{
       
        if(nongChangHave == 0){
//            [self createWork];
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有进入农场\n请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alertC addAction:confirmAct];
//            [self presentViewController:alertC animated:YES completion:nil];
//
//            leftBtn.alpha = 0.3;
//            rightBtn.alpha = 0.3;
//            _workBtn.alpha = 0.3;
//
//            leftBtn.enabled = NO;
//            rightBtn.enabled = NO;
//            _workBtn.enabled = NO;
            
        }else if ([pengHave isEqualToString:@""]){
//            [self createWork];
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有负责的大棚\n请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alertC addAction:confirmAct];
//            [self presentViewController:alertC animated:YES completion:nil];
//
//            leftBtn.alpha = 0.3;
//            leftBtn.enabled = NO;
        }else{
            
            [self createTabelview];
            _plantTableView.mj_footer.hidden = YES;
            
            [self requestData];
            
            [self createWork];
            
            leftBtn.alpha = 0.3;
            leftBtn.enabled = NO;
        }
        
       
        
    }
    
}

-(void)WonoStateChange{
//    [_plantTableView removeFromSuperview];
//    _plantTableView = nil;
    wonoAlertMark = 1;
    
    int nongChangHave = [[[NSUserDefaults standardUserDefaults]objectForKey:@"fid"]intValue];
    NSString *pengHave = [[NSUserDefaults standardUserDefaults]objectForKey:@"pengID"];
    int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(re) name:@"plantChange" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WonoStateChange) name:@"WonoStateChange" object:nil];
    
//    [self createNextBtn];
    if(userType == 1){
        
        [self createTabelview];
        _plantTableView.mj_footer.hidden = YES;
        // Do any additional setup after loading the view.
        [self requestData];
        [self createWork];
    }else{
        
        if(nongChangHave == 0){
            //            [self createWork];
            //            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有进入农场\n请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
            //            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            //            [alertC addAction:confirmAct];
            //            [self presentViewController:alertC animated:YES completion:nil];
            //
            //            leftBtn.alpha = 0.3;
            //            rightBtn.alpha = 0.3;
            //            _workBtn.alpha = 0.3;
            //
            //            leftBtn.enabled = NO;
            //            rightBtn.enabled = NO;
            //            _workBtn.enabled = NO;
            
        }else if ([pengHave isEqualToString:@""]){
            //            [self createWork];
            //            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有负责的大棚\n请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
            //            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            //            [alertC addAction:confirmAct];
            //            [self presentViewController:alertC animated:YES completion:nil];
            //
            //            leftBtn.alpha = 0.3;
            //            leftBtn.enabled = NO;
        }else{
            
            [self createTabelview];
            _plantTableView.mj_footer.hidden = YES;
            
            [self requestData];
            
            [self createWork];
            
            leftBtn.alpha = 0.3;
            leftBtn.enabled = NO;
        }
        
        
        
    }
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
        make.height.equalTo(@(SafeAreaTopRealHeight));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView2.mas_left).offset(15);
        make.top.equalTo(_headView2.mas_top).offset(24+SafeAreaTopHeight);
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


-(void)createNextBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"重置筛选" forState:UIControlStateNormal];
    //    [_nextBtn setTitle:@"取消编辑" forState:UIControlStateSelected];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_nextBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView2 addSubview:_nextBtn];
    //    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView2.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(26)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    
    _hubBtn = [[UIButton alloc]init];
    _hubBtn.backgroundColor = [UIColor clearColor];
    [_hubBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView2 addSubview:_hubBtn];
//    _headView.userInteractionEnabled = YES;
    [_hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView2.mas_right);
        make.height.equalTo(_headView2.mas_height);
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
}

-(void)SaveClick{
    _hubBtn.enabled = NO;
    _plantTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _plantTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    type = @"0";
    [_plantTableView.mj_header beginRefreshing];
    [leftBtn setTitle:@"按员工" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"按时间" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    Count = 1;
//    [self requestData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_plantTableView reloadData];
    
    if(orgRefMark == 10){
        orgRefMark = 1;
        [self SaveClick];
    }
    
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    _plantTableView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _plantTableView.alpha = 1;
    }];
    
    
    if(_plantTableView == nil){
        
        int nongChangHave = [[[NSUserDefaults standardUserDefaults]objectForKey:@"fid"]intValue];
        NSString *pengHave = [[NSUserDefaults standardUserDefaults]objectForKey:@"pengID"];
        int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
        
        
        
        if(userType == 1){
            
            [self createTabelview];
            _plantTableView.mj_footer.hidden = YES;
            // Do any additional setup after loading the view.
            [self requestData];
            [self createWork];
        }else{
            
            if(nongChangHave == 0){
                
                [self createWork];
                leftBtn.alpha = 0.3;
                rightBtn.alpha = 0.3;
                _workBtn.alpha = 0.3;
                
                leftBtn.enabled = NO;
                rightBtn.enabled = NO;
                _workBtn.enabled = NO;
                if(wonoAlertMark != 1){
                    return;
                }
                wonoAlertMark++;
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有进入农场\n请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertC addAction:confirmAct];
                [self presentViewController:alertC animated:YES completion:nil];
                
                
                
            }else if ([pengHave isEqualToString:@""]){
                [self createWork];
                leftBtn.alpha = 0.3;
                leftBtn.enabled = NO;
                if(wonoAlertMark != 1){
                    
                    return;
                }
                wonoAlertMark++;
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有负责的大棚\n请联系相关农场主" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertC addAction:confirmAct];
                [self presentViewController:alertC animated:YES completion:nil];
                
                
              
            }else{
                
                [self createTabelview];
                _plantTableView.mj_footer.hidden = YES;
                
                [self requestData];
                [self createWork];
                
            }
            
           
            
        }

        
    }
    
    
//    [_plantTableView.header beginRefreshing];
    
    
    
//    [self requestData];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)re{
//    if(NO == rightBtn.selected){
//        [_plantTableView.mj_header beginRefreshing];
//    }
    orgRefMark =10;
//    [self SaveClick];
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
   _plantTableView.showsVerticalScrollIndicator = YES;
   
    
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
        view.backgroundColor = [UIColor clearColor];
        
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
//    [_plantTableView.mj_header beginRefreshing];
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
    
    [cell reloadNeedV];
    
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
    
    PlantBaseModel *model = dataArr[section];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = model.name;
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
    
    NSString *need = model.deleteState;
    int ne = [need intValue];
    if(ne == 1){
        [MBProgressHUD showSuccess:@"所属大棚已删除"];
        return;
    }
    
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
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopRealHeight);
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
    rightBtn.selected = NO;
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
        rightBtn.selected = YES;
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
    
    
    int nongChangHave = [[[NSUserDefaults standardUserDefaults]objectForKey:@"fid"]intValue];
    if(nongChangHave == 0){
        return;
    }
    
    AddViewController *add = [[AddViewController alloc]init];
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
//    WorkViewController *wor = [[WorkViewController alloc]init];
//    [self.navigationController pushViewController:wor animated:YES];
    
}

-(void)toendRe{
    if(![_plantTableView.mj_header isRefreshing]){
        _hubBtn.enabled = YES;
    }else{
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.2/*延迟执行时间*/ * NSEC_PER_SEC);
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self toendRe];
        });
    }
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
    [self tableBackgroundWithTitle:@"加载数据中"];

    
    [[InterfaceSingleton shareInstance].interfaceModel getMainPlantWithModel:model WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_header endRefreshing];
        [_plantTableView.mj_footer endRefreshing];
        
        
        [self toendRe];
        
        int userType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userType"]intValue];
        
        
        if(state == 2000){
            NSLog(@"成功");
            

            NSArray *arr = data[@"data"];
            
            if(arr.count == 0){
                
                if(Count!=1){
                    Count--;
                    [_plantTableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
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
                    
                    PlantModel *model = [[PlantModel alloc]init];
                    model.dateStr = dic2[@"week"];
                    model.timeStr = dic2[@"time"];
                    model.nameStr = dic2[@"title"];
                    model.typeStr = dic2[@"plant_type_id"];
                    model.numberStr = dic2[@"total_amount"];
                    model.extraStr = dic2[@"variety_name"];
                    
                    model.pengID = dic2[@"gid"];
                    
                    model.deleteState = dic2[@"is_delete"];
                    
                    NSString *typeS = [NSString stringWithFormat:@"%@",dic2[@"plant_type_id"]];
                    if([typeS isEqualToString:@"1"]){
                        
                        NSString *needStr = [NSString stringWithFormat:@"%@株/粒",dic2[@"amount"]];
                        model.numberStr = needStr;
                    }
                    
                    [baseModel.arr addObject:model];
                }
                
                [dataArr addObject:baseModel];

            }
            
            _plantTableView.mj_footer.hidden = NO;
            [_plantTableView reloadData];
            
            if(alMark == false){
            
            _plantTableView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                _plantTableView.alpha = 1;
            }];
                alMark = true;
            }
        }else{
            
            if(userType == 1){
                [self tableBackgroundWithTitle:@"暂无数据,请添加相关大棚和员工"];
            }else{
                [self tableBackgroundWithTitle:@"暂无数据,请点击“开始干活”按钮添加记录"];
            }
            
        }
        if(state<2000){
            if(userType == 1){
                [self tableBackgroundWithTitle:@"暂无数据,请添加相关大棚和员工"];
            }else{
                [self tableBackgroundWithTitle:@"暂无数据,请点击“开始干活”按钮添加记录"];
            }
            [MBProgressHUD showSuccess:msg];
        }
    }];

}

-(void)tableBackgroundWithTitle:(NSString *)title{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.3/*延迟执行时间*/ * NSEC_PER_SEC);
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.view layoutIfNeeded];
        [_plantTableView layoutIfNeeded];
        [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
            //                [_plantTableView setScrollEnabled:NO];
            UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel *label = [[UILabel alloc]init];
            label.text = title;
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

-(void)selectWithDic:(NSDictionary *)dic{
    
    _plantTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    _plantTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    _plantTableView.mj_footer.hidden = YES;
    
    [rightBtn setTitleColor:UIColorFromHex(0x4db366) forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.backgroundColor = UIColorFromHex(0x4db366);
    rightBtn.selected = NO;
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
            
            if(arr.count == 0){
                if(Count!=1){
                    Count--;
                    [_plantTableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
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
                    
                    PlantModel *model = [[PlantModel alloc]init];
                    model.dateStr = dic2[@"week"];
                    model.timeStr = dic2[@"time"];
                    model.nameStr = dic2[@"title"];
                    model.typeStr = dic2[@"plant_type_id"];
                    model.numberStr = dic2[@"total_amount"];
                    model.extraStr = dic2[@"variety_name"];
                    
                    model.pengID = dic2[@"gid"];
                    model.deleteState = dic2[@"is_delete"];
                    
                    NSString *typeS = [NSString stringWithFormat:@"%@",dic2[@"plant_type_id"]];
                    if([typeS isEqualToString:@"1"]){
                        
                        NSString *needStr = [NSString stringWithFormat:@"%@株/粒",dic2[@"amount"]];
                        model.numberStr = needStr;
                    }
                    
                    [baseModel.arr addObject:model];
                }
                
                [dataArr addObject:baseModel];
                
            }
            
            if(dataArr.count>0){
                _plantTableView.mj_footer.hidden = NO;
            }
            
            [_plantTableView reloadData];
            
        }else{
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor clearColor];
                    
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
    
    SelTime = time;
    
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
            
            if(arr.count == 0){
                if(Count!=1){
                    Count--;
                    [_plantTableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
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
                    
                    PlantModel *model = [[PlantModel alloc]init];
                    model.dateStr = dic2[@"week"];
                    model.timeStr = dic2[@"time"];
                    model.nameStr = dic2[@"title"];
                    model.typeStr = dic2[@"plant_type_id"];
                    model.numberStr = dic2[@"total_amount"];
                    model.extraStr = dic2[@"variety_name"];
                    
                    model.pengID = dic2[@"gid"];
                    model.deleteState = dic2[@"is_delete"];
                    NSString *typeS = [NSString stringWithFormat:@"%@",dic2[@"plant_type_id"]];
                    if([typeS isEqualToString:@"1"]){
                        
                        NSString *needStr = [NSString stringWithFormat:@"%@株/粒",dic2[@"amount"]];
                        model.numberStr = needStr;
                    }
                    
                    [baseModel.arr addObject:model];
                }
                
                [dataArr addObject:baseModel];
                
            }
            
            [_plantTableView reloadData];
            
            upCount = 1;
            donwCount = 2;
            
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(Rrefresh)];
            
            [header setTitle:@"下拉可加载较新时间段内容" forState:MJRefreshStateIdle];
            [header setTitle:@"松开查看较新时间段内容" forState:MJRefreshStatePulling];
            [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];

            
            _plantTableView.mj_header = header;
            
            MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(RrefreshMore)];
                        [footer setTitle:@"上拉可查看以往时间段内容" forState:MJRefreshStateIdle];
            [footer setTitle:@"松开查看以往时间段内容" forState:MJRefreshStatePulling];
            [footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];

            _plantTableView.mj_footer = footer;
            
            
            
        }else{
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.3/*延迟执行时间*/ * NSEC_PER_SEC);
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor clearColor];
                    
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
           
            upCount = 1;
            donwCount = 2;
            
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(Rrefresh)];
            
            
            [header setTitle:@"下拉可查看较新时间段内容" forState:MJRefreshStateIdle];
            [header setTitle:@"松开查看较新时间段内容" forState:MJRefreshStatePulling];
            [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
            
            _plantTableView.mj_header = header;
            
            MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(RrefreshMore)];
            [footer setTitle:@"上拉可加载以往时间段内容" forState:MJRefreshStateIdle];
            [footer setTitle:@"松开查看以往时间段内容" forState:MJRefreshStatePulling];
            [footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
            _plantTableView.mj_footer = footer;
            [_plantTableView reloadData];
        }
        
        _plantTableView.mj_footer.hidden = NO;
        
    }];
    
}


-(void)RrefreshMore{
    NSLog(@"123");
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    MainPlantModel *model = [[MainPlantModel alloc]init];
    model.fid = str;
    model.page = upCount;
    model.date = SelTime;

    
    
    
    [[InterfaceSingleton shareInstance].interfaceModel getOldMainPlantWithModel:model WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_header endRefreshing];
        [_plantTableView.mj_footer endRefreshing];
        if(state == 2000){
            NSLog(@"成功");
            
//            NSMutableArray *needArr = [NSMutableArray array];
            NSArray *arr = data[@"data"];
            
            if(arr.count == 0){
                [_plantTableView.mj_footer endRefreshingWithNoMoreData];
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.3/*延迟执行时间*/ * NSEC_PER_SEC);
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.view layoutIfNeeded];
                    [_plantTableView layoutIfNeeded];
                    [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                        //                [_plantTableView setScrollEnabled:NO];
                        UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                        view.backgroundColor = [UIColor clearColor];
                        
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
                
                
                
                return;
                
            }
            
            PlantBaseModel *orgba = [dataArr lastObject];
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
                    model.deleteState = dic2[@"is_delete"];
                    NSString *typeS = [NSString stringWithFormat:@"%@",dic2[@"plant_type_id"]];
                    if([typeS isEqualToString:@"1"]){
                        
                        NSString *needStr = [NSString stringWithFormat:@"%@株/粒",dic2[@"amount"]];
                        model.numberStr = needStr;
                    }
                    
                    [baseModel.arr addObject:model];
                }
                
                if([orgba.name isEqualToString:baseModel.name]){
                    
                    [orgba.arr addObjectsFromArray:baseModel.arr];
                    
                }else{
                    [dataArr addObject:baseModel];
                }
                
           
            }
            
//            [needArr addObjectsFromArray:dataArr];
//            dataArr = needArr;
            
            
            [_plantTableView reloadData];
            
            upCount++;
            
        }else{
            
            if(upCount != 1){
                upCount --;
            }
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.3/*延迟执行时间*/ * NSEC_PER_SEC);
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor clearColor];
                    
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

-(void)Rrefresh{
    NSLog(@"234");
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    MainPlantModel *model = [[MainPlantModel alloc]init];
    model.fid = str;
    model.page = donwCount;
    model.date = SelTime;

    
    
    [[InterfaceSingleton shareInstance].interfaceModel getMainPlantWithModel:model WithCallBack:^(int state, id data, NSString *msg) {
        [_plantTableView.mj_header endRefreshing];
        [_plantTableView.mj_footer endRefreshing];
        if(state == 2000){
            NSLog(@"成功");
            
            NSMutableArray *needArr = [NSMutableArray array];
            
            NSArray *arr = data[@"data"];
            
            if(arr.count == 0){
                
//                if(donwCount != 2){
//                    donwCount --;
//                }
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.3/*延迟执行时间*/ * NSEC_PER_SEC);
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.view layoutIfNeeded];
                    [_plantTableView layoutIfNeeded];
                    [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                        //                [_plantTableView setScrollEnabled:NO];
                        UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                        view.backgroundColor = [UIColor clearColor];
                        
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
               
                
                return;
                
            }
            
            donwCount++;
            
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
                    model.deleteState = dic2[@"is_delete"];
                    NSString *typeS = [NSString stringWithFormat:@"%@",dic2[@"plant_type_id"]];
                    if([typeS isEqualToString:@"1"]){
                        
                        NSString *needStr = [NSString stringWithFormat:@"%@株/粒",dic2[@"amount"]];
                        model.numberStr = needStr;
                    }
                    
                    [baseModel.arr addObject:model];
                }
                
                [needArr addObject:baseModel];
                
            }
            
            int Con = needArr.count;
            
            [needArr addObjectsFromArray:dataArr];
            dataArr = needArr;
            
            [_plantTableView reloadData];
            
            [_plantTableView layoutIfNeeded];
            [self.view layoutIfNeeded];
            
            
            
            NSIndexPath * dayOne = [NSIndexPath indexPathForRow:NSNotFound inSection:Con];
//            [_plantTableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [_plantTableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [_plantTableView flashScrollIndicators];
           
            
        }else{
            donwCount--;
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.3/*延迟执行时间*/ * NSEC_PER_SEC);
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
                [_plantTableView layoutIfNeeded];
                [_plantTableView jr_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
                    //                [_plantTableView setScrollEnabled:NO];
                    UIView *view = [[UIView alloc]initWithFrame:_plantTableView.bounds];
                    view.backgroundColor = [UIColor clearColor];
                    
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
    

    
    
//    [_plantTableView.mj_header endRefreshing];
//    [_plantTableView.mj_footer endRefreshing];

}


@end
