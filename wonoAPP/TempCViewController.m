//
//  TempCViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/31.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "TempCViewController.h"
#import "MyZView.h"
#import "PlantModel.h"

@interface TempCViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;


@end

@implementation TempCViewController{
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createZXview];
    [self createZXview2];
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
    
    NSArray *array = [NSArray arrayWithObjects:@"最近",@"近七天",@"近一个月", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
//    segment.backgroundColor = [UIColor whiteColor];
    segment.tintColor = UIColorFromHex(0xefefef);
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} forState:UIControlStateSelected];
    //设置选中的选项卡
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];
    //设置frame
//    segment.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    //添加到视图
    [_headView addSubview:segment];

    
//    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.text = @"";
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.font = [UIFont systemFontOfSize:18];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_headView addSubview:_titleLabel];
    
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
    
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView.mas_centerX);
        make.centerY.equalTo(_backBtn.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(510)));
        make.height.equalTo(@(HDAutoHeight(60)));
    }];
}

- (void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    //这里实现点击事件的方法
    
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
//        [self createZXview3];
        //记得remove对应tag的view再重新添加
        
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }
    
  
}

-(void)BackClick{
    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createZXview{
    MyZView *Zview = [[MyZView alloc]initWithFrame:CGRectMake(0, 64, APP_CONTENT_WIDTH, (APP_CONTENT_HEIGHT-128)/2)];
    
    Zview.tag = 201;
    
    PointModel *model = [[PointModel alloc]init];
    model.Height = 34;
    
    model.firstBottomStr = @"描述";
    
    model.Height2 = 20;
    
    model.nextBottomStr = @"描述";
    
    model.lineName = @"时间";
    
    PointModel *model2 = [[PointModel alloc]init];
    model2.Height = 30;
    
    model2.Height2 = 20;
    
    model2.firstBottomStr = @"唉唉";
    
    model2.nextBottomStr = @"问问";
    
    model2.lineName = @"时间";

    
    dataArr = [NSMutableArray array];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    
    Zview.dataArr = dataArr;
    
//    NSMutableArray *arr2 = [NSMutableArray array];
//    model.Height = 0;
//    [arr2 addObject:model];
//    [arr2 addObject:model];
//    [arr2 addObject:model];
//    [arr2 addObject:model];
//    [arr2 addObject:model];
//    [arr2 addObject:model];
//    [arr2 addObject:model];
//    Zview.dataArr2 = arr2;
    
    [self.view addSubview:Zview];
    
}

-(void)createZXview2{
    
    
    PointModel *model = [[PointModel alloc]init];
    
    
    model.Height = 34;
    
    model.firstBottomStr = @"描述";
    
    model.Height2 = 20;
    
    model.nextBottomStr = @"描述";
    
    model.lineName = @"时间";
    
    PointModel *model2 = [[PointModel alloc]init];
    model2.Height = 30;
    
    model2.Height2 = 20;
    
    model2.firstBottomStr = @"唉唉";
    
    model2.nextBottomStr = @"问问";
    
    model2.lineName = @"时间";
    
    
    dataArr = [NSMutableArray array];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    [dataArr addObject:model2];
    [dataArr addObject:model];
    
    
    MyZView *Zview = [[MyZView alloc]initWithFrame:CGRectMake(0, 64 +(APP_CONTENT_HEIGHT-128)/2, APP_CONTENT_WIDTH, (APP_CONTENT_HEIGHT-128)/2) AndData:dataArr];
    
    
    Zview.tag = 202;
    
    //    NSMutableArray *arr2 = [NSMutableArray array];
    //    model.Height = 0;
    //    [arr2 addObject:model];
    //    [arr2 addObject:model];
    //    [arr2 addObject:model];
    //    [arr2 addObject:model];
    //    [arr2 addObject:model];
    //    [arr2 addObject:model];
    //    [arr2 addObject:model];
    //    Zview.dataArr2 = arr2;
    
    [self.view addSubview:Zview];
    
}






@end
