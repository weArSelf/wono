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

#import "PointModel.h"
#import "MyZview2.h"
#import "MyPieView.h"
//#import "UITableView+JRTableViewPlaceHolder.h"

@interface StatisticsViewController ()

//@property (strong, nonatomic) PieChartView *chartView;

@property (nonatomic,strong)UIView *headView2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIScrollView *mainScroll;

@property (nonatomic,strong) UILabel *secTitleLabel;


@end

@implementation StatisticsViewController{

//    NSMutableDictionary *resDic;
    NSMutableArray *lineData;
    NSMutableArray *inDataArr;
    NSMutableArray *outDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    inDataArr = [NSMutableArray array];
    outDataArr = [NSMutableArray array];
    lineData = [NSMutableArray array];
    // Do any additional setup after loading the view.
    
//    resDic = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createScroll];
    [self requestCircleData];
    
    [self createYueNian];
    
    [self RequestYueNian];
    [self RequestYueNian2];
    [self requestTotalData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self requestData];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
   
}


-(void)creatTitleAndBackBtn{
    
    _headView2 = [[UIView alloc]init];
    _headView2.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView2.alpha = 0.8;
    [self.view addSubview:_headView2];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"数据统计";
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

-(void)createScroll{
    _mainScroll = [[UIScrollView alloc]init];
//    _mainScroll.backgroundColor = [UIColor redColor];
    _mainScroll.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    [self.view addSubview:_mainScroll];
}

-(void)requestCircleData{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [[InterfaceSingleton shareInstance].interfaceModel GetjiWithFid:str WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSLog(@"成功");
            
            lineData = [NSMutableArray array];
            
            float maxVal = -1;
            float minVal = -1;
            NSArray *arr = data;
            for(int i=0;i<arr.count;i++){
                NSDictionary *dic = arr[i];
                PointModel *mo = [[PointModel alloc]init];
                mo.Height = [dic[@"in_total_amount"]floatValue];
                mo.Height2 = [dic[@"out_total_amount"]floatValue];
                mo.firstBottomStr = dic[@"in_total_amount"];
                mo.nextBottomStr = dic[@"out_total_amount"];
                mo.lineName = dic[@"month"];
                [lineData addObject:mo];
                
                if(mo.Height>mo.Height2){
                    if(maxVal == -1){
                        maxVal = mo.Height;
                        minVal = mo.Height2;
                    }
                    if(mo.Height>maxVal){
                        maxVal = mo.Height;
                    }
                    if(mo.Height2<minVal){
                        minVal = mo.Height2;
                    }
                    
                }else{
                    if(maxVal == -1){
                        minVal = mo.Height;
                        maxVal = mo.Height2;
                    }
                    
                    if(mo.Height2>maxVal){
                        maxVal = mo.Height2;
                    }
                    if(mo.Height<minVal){
                        minVal = mo.Height;
                    }
                }
                
            }
            
//            float cen = maxVal - minVal;
            
            
            MyZView2 *zView = [[MyZView2 alloc]initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 250)];
            zView.maxVal = maxVal;
            zView.minVal = minVal;
            zView.dataArr = lineData;
            //    zView.backgroundColor = [UIColor orangeColor];
            [_mainScroll addSubview:zView];
            
            UIView *botView = [[UIView alloc]init];
            botView.backgroundColor = [UIColor grayColor];
            botView.alpha = 0.3;
            botView.frame = CGRectMake(0, 255, SCREEN_WIDTH, 1);
            [_mainScroll addSubview:botView];
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
}
-(void)createYueNian{

    _secTitleLabel = [[UILabel alloc]init];
    _secTitleLabel.text = @"当月总收入与支出";
    _secTitleLabel.textColor = [UIColor grayColor];
    _secTitleLabel.font = [UIFont systemFontOfSize:14];
    _secTitleLabel.frame = CGRectMake(HDAutoWidth(25), 255+HDAutoHeight(20), HDAutoWidth(250), HDAutoHeight(60));
    
    [_mainScroll addSubview:_secTitleLabel];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"月度收入与支出"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"年度收入与支出"] forState:UIControlStateSelected];
    btn.frame = CGRectMake(SCREEN_WIDTH-HDAutoWidth(265), 255+HDAutoHeight(20), HDAutoWidth(250), HDAutoHeight(64));
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.selected = NO;
    [_mainScroll addSubview:btn];
}
-(void)changeClick:(UIButton *)btn{
    
    MyPieView *pie1 = [_mainScroll viewWithTag:301];
    MyPieView *pie2 = [_mainScroll viewWithTag:302];
    MyPieView *pie3 = [_mainScroll viewWithTag:401];
    MyPieView *pie4 = [_mainScroll viewWithTag:402];
    
    if(pie1==nil||pie2==nil||pie3==nil||pie4==nil){
        [MBProgressHUD showSuccess:@"加载数据中,请稍后"];
        return;
    }
    
    if(btn.selected == NO){
        btn.selected = YES;
        _secTitleLabel.text = @"本年总收入与支出";
        [UIView animateWithDuration:0.5 animations:^{
            pie1.x-=SCREEN_WIDTH;
            pie2.x-=SCREEN_WIDTH;
            pie3.x-=SCREEN_WIDTH;
            pie4.x-=SCREEN_WIDTH;
        }];
        
    }else{
        btn.selected = NO;
         _secTitleLabel.text = @"当月总收入与支出";
        [UIView animateWithDuration:0.5 animations:^{
            pie1.x+=SCREEN_WIDTH;
            pie2.x+=SCREEN_WIDTH;
            pie3.x+=SCREEN_WIDTH;
            pie4.x+=SCREEN_WIDTH;
        }];
        
    }
   
}

-(void)RequestYueNian{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [[InterfaceSingleton shareInstance].interfaceModel GetNianWithFid:str AndType:@"1" WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSLog(@"成功");
            NSDictionary *dic = data;
            NSArray *arr1 = dic[@"in"];
            NSArray *arr2 = dic[@"out"];
            
            PercentModel *model = [[PercentModel alloc]init];
            NSMutableArray *nameArr = [NSMutableArray array];
            NSMutableArray *amountArr = [NSMutableArray array];
//            NSMutableArray *colorArr = [NSMutableArray array];
            
            float total = 0;
            
            for (int i=0; i<arr1.count; i++) {
                NSDictionary *dic = arr1[i];
                NSString *name = dic[@"variety_name"];
                [nameArr addObject:name];
                float value = [dic[@"total_amount"] floatValue];
                total+=value;
                [amountArr addObject:dic[@"total_amount"]];
            }
            model.title = @"";
            model.nameArr = nameArr;
            model.amountArr = amountArr;
            model.total = total;
            
            MyPieView *pieV = [[MyPieView alloc]init];
            
            pieV.tag = 301;
            
            pieV.frame = CGRectMake(0, 255+HDAutoHeight(80), SCREEN_WIDTH, HDAutoHeight(450));
            pieV.model = model;
            [_mainScroll addSubview:pieV];
            
            PercentModel *model2 = [[PercentModel alloc]init];
            nameArr = [NSMutableArray array];
            amountArr = [NSMutableArray array];
            total = 0;
            
            for (int i=0; i<arr2.count; i++) {
                NSDictionary *dic = arr2[i];
                NSString *name = dic[@"plant_name"];
                [nameArr addObject:name];
                float value = [dic[@"total_amount"] floatValue];
                total+=value;
                [amountArr addObject:dic[@"total_amount"]];
            }
            
            model2.nameArr = nameArr;
            model2.amountArr = amountArr;
            model2.total = total;

            NSMutableArray *mulColorArr = [NSMutableArray array];
            UIColor *color1 = UIColorFromHex(0x4db366);
            UIColor *color2 = UIColorFromHex(0x795548);
            UIColor *color3 = UIColorFromHex(0x2196f3);
            
            [mulColorArr addObject:color1];
            [mulColorArr addObject:color2];
            [mulColorArr addObject:color3];
            model2.colorArr = mulColorArr;
            
            MyPieView *pieV2 = [[MyPieView alloc]init];
            
            pieV2.tag = 302;
            
            pieV2.frame = CGRectMake(0, 255+HDAutoHeight(530), SCREEN_WIDTH, HDAutoHeight(450));
            pieV2.model = model2;
            [_mainScroll addSubview:pieV2];
            
            
            
            UIView *botView = [[UIView alloc]init];
            botView.backgroundColor = [UIColor grayColor];
            botView.alpha = 0.3;
            botView.frame = CGRectMake(0, 255+HDAutoHeight(530)+HDAutoHeight(450), SCREEN_WIDTH, 1);
            [_mainScroll addSubview:botView];
            
//            _mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 255+HDAutoHeight(530)+HDAutoHeight(450)+10);
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
    
}


-(void)RequestYueNian2{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [[InterfaceSingleton shareInstance].interfaceModel GetNianWithFid:str AndType:@"2" WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSLog(@"成功");
            NSDictionary *dic = data;
            NSArray *arr1 = dic[@"in"];
            NSArray *arr2 = dic[@"out"];
            
            PercentModel *model = [[PercentModel alloc]init];
            NSMutableArray *nameArr = [NSMutableArray array];
            NSMutableArray *amountArr = [NSMutableArray array];
            //            NSMutableArray *colorArr = [NSMutableArray array];
            
            float total = 0;
            
            for (int i=0; i<arr1.count; i++) {
                NSDictionary *dic = arr1[i];
                NSString *name = dic[@"variety_name"];
                [nameArr addObject:name];
                float value = [dic[@"total_amount"] floatValue];
                total+=value;
                [amountArr addObject:dic[@"total_amount"]];
            }
            model.title = @"";
            model.nameArr = nameArr;
            model.amountArr = amountArr;
            model.total = total;
            
            MyPieView *pieV = [[MyPieView alloc]init];
            pieV.tag = 401;
            
            pieV.frame = CGRectMake(SCREEN_WIDTH, 255+HDAutoHeight(80), SCREEN_WIDTH, HDAutoHeight(450));
            pieV.model = model;
            [_mainScroll addSubview:pieV];
            
            PercentModel *model2 = [[PercentModel alloc]init];
            nameArr = [NSMutableArray array];
            amountArr = [NSMutableArray array];
            total = 0;
            
            for (int i=0; i<arr2.count; i++) {
                NSDictionary *dic = arr2[i];
                NSString *name = dic[@"plant_name"];
                [nameArr addObject:name];
                float value = [dic[@"total_amount"] floatValue];
                total+=value;
                [amountArr addObject:dic[@"total_amount"]];
            }
            
            model2.nameArr = nameArr;
            model2.amountArr = amountArr;
            model2.total = total;
            
            NSMutableArray *mulColorArr = [NSMutableArray array];
            UIColor *color1 = UIColorFromHex(0x4db366);
            UIColor *color2 = UIColorFromHex(0x795548);
            UIColor *color3 = UIColorFromHex(0x2196f3);
            
            [mulColorArr addObject:color1];
            [mulColorArr addObject:color2];
            [mulColorArr addObject:color3];
            model2.colorArr = mulColorArr;
            
            MyPieView *pieV2 = [[MyPieView alloc]init];
            
            pieV2.tag = 402;
            
            pieV2.frame = CGRectMake(SCREEN_WIDTH, 255+HDAutoHeight(530), SCREEN_WIDTH, HDAutoHeight(450));
            pieV2.model = model2;
            [_mainScroll addSubview:pieV2];
            
//            _mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 255+HDAutoHeight(530)+HDAutoHeight(450));
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
    
}


-(void)requestTotalData{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [[InterfaceSingleton shareInstance].interfaceModel GetZongWithFid:str WithCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            NSLog(@"成功");
            
            NSDictionary *orDic = data;
            
            NSArray *dArr = orDic[@"greens"];
            
            PercentModel *dmodel = [[PercentModel alloc]init];
            NSMutableArray *dnameArr = [NSMutableArray array];
            NSMutableArray *damountArr = [NSMutableArray array];
            //            NSMutableArray *colorArr = [NSMutableArray array];
            
            float total = 0;
            
            
            for (int i=0; i<dArr.count; i++) {
                NSDictionary *dic = dArr[i];
                NSString *name = dic[@"variety_name"];
                [dnameArr addObject:name];
                float value = [dic[@"greenhouse_num"] floatValue];
                total+=value;
                [damountArr addObject:dic[@"greenhouse_num"]];
            }
            dmodel.title = @"种植棚数:";
            dmodel.nameArr = dnameArr;
            dmodel.amountArr = damountArr;
            dmodel.total = total;
            
            MyPieView *dpieV = [[MyPieView alloc]init];
            dpieV.tag = 401;
            
            dpieV.frame = CGRectMake(0, 255+HDAutoHeight(530)+HDAutoHeight(460), SCREEN_WIDTH, HDAutoHeight(450));
            dpieV.model = dmodel;
            [_mainScroll addSubview:dpieV];
            
            UIView *botView = [[UIView alloc]init];
            botView.backgroundColor = [UIColor grayColor];
            botView.alpha = 0.3;
            botView.frame = CGRectMake(0, 255+HDAutoHeight(530)+HDAutoHeight(460)+HDAutoHeight(450), SCREEN_WIDTH, 1);
            [_mainScroll addSubview:botView];
            
            
            
            
            NSDictionary *dic = orDic[@"bills"];
            NSArray *arr1 = dic[@"in"];
            NSArray *arr2 = dic[@"out"];
            
            PercentModel *model = [[PercentModel alloc]init];
            NSMutableArray *nameArr = [NSMutableArray array];
            NSMutableArray *amountArr = [NSMutableArray array];
            //            NSMutableArray *colorArr = [NSMutableArray array];
            
            total = 0;
            
            for (int i=0; i<arr1.count; i++) {
                NSDictionary *dic = arr1[i];
                NSString *name = dic[@"variety_name"];
                [nameArr addObject:name];
                float value = [dic[@"total_amount"] floatValue];
                total+=value;
                [amountArr addObject:dic[@"total_amount"]];
            }
            model.title = @"总收入(按品类划分)";
            model.nameArr = nameArr;
            model.amountArr = amountArr;
            model.total = total;
            
            MyPieView *pieV = [[MyPieView alloc]init];
            pieV.tag = 401;
            
            pieV.frame = CGRectMake(0, 255+HDAutoHeight(530)+HDAutoHeight(460)+HDAutoHeight(460), SCREEN_WIDTH, HDAutoHeight(450));
            pieV.model = model;
            [_mainScroll addSubview:pieV];
            
            PercentModel *model2 = [[PercentModel alloc]init];
            nameArr = [NSMutableArray array];
            amountArr = [NSMutableArray array];
            total = 0;
            
            for (int i=0; i<arr2.count; i++) {
                NSDictionary *dic = arr2[i];
                NSString *name = dic[@"variety_name"];
                [nameArr addObject:name];
                float value = [dic[@"total_amount"] floatValue];
                total+=value;
                [amountArr addObject:dic[@"total_amount"]];
            }
            
            model2.nameArr = nameArr;
            model2.amountArr = amountArr;
            model2.total = total;
            model2.title = @"总支出(按品类划分)";
//            NSMutableArray *mulColorArr = [NSMutableArray array];
//            UIColor *color1 = UIColorFromHex(0x4db366);
//            UIColor *color2 = UIColorFromHex(0x795548);
//            UIColor *color3 = UIColorFromHex(0x2196f3);
//            
//            [mulColorArr addObject:color1];
//            [mulColorArr addObject:color2];
//            [mulColorArr addObject:color3];
//            model2.colorArr = mulColorArr;
            
            MyPieView *pieV2 = [[MyPieView alloc]init];
            
            pieV2.tag = 402;
            
            pieV2.frame = CGRectMake(0, 255+HDAutoHeight(530)+HDAutoHeight(460)+HDAutoHeight(450)+HDAutoHeight(460), SCREEN_WIDTH, HDAutoHeight(450));
            pieV2.model = model2;
            [_mainScroll addSubview:pieV2];
            
            _mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH,255+HDAutoHeight(530)+HDAutoHeight(460)+HDAutoHeight(450)+HDAutoHeight(460)+HDAutoHeight(500));
            

            
        }
        
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
    
}



@end
