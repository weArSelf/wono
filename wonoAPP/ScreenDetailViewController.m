//
//  ScreenDetailViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "ScreenDetailViewController.h"
#import "ScreenDetailModel.h"

@interface ScreenDetailViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *confirmBtn;


@end

@implementation ScreenDetailViewController{
    NSMutableArray *dataArr;
    int selTag;
    ScreenDetailModel *nowModel;
    
    NSMutableDictionary *selDic;
    
    BOOL mark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mark = false;
    selDic = [NSMutableDictionary dictionary];
    // Do any additional setup after loading the view.
    selTag = 0;
    dataArr = [NSMutableArray array];
    
//    NSArray *arr = [NSArray arrayWithObjects:@"aaa",@"aba",@"qwe",@"www",@"qtr",@"gff", nil];
//    
//    dataArr = [NSMutableArray arrayWithArray:arr];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    dataArr = [NSArray arrayWithObjects:@"蔬菜",@"花卉",@"水果",@"橘子",@"🍊",nil];
    
    [self creatTitleAndBackBtn];
    
//    [self createBtn];
    
    [self requestData];
    
    [self createConfirmBtn];
    
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
    _titleLabel.text = @"选择员工";
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
}

-(void)createBtn{
    
    for(int i=0;i<dataArr.count;i++){
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        ScreenDetailModel *model = dataArr[i];
        
        NSString *title = model.name;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(QbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
        btn.tag = 200+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorFromHex(0x9fa0a0).CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        
        int j = i/2;
        int k = i%2;
        
        btn.frame = CGRectMake(HDAutoWidth(30)+k*HDAutoWidth(365) , 64+HDAutoHeight(20)+ j*HDAutoHeight(100), HDAutoWidth(320),HDAutoHeight(80));
        
        [self.view addSubview:btn];
    }
    
}
-(void)QbtnClick:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    
    if(btn.tag == 200){
        [selDic removeAllObjects];
        mark = true;
        
        for (int i=1; i<dataArr.count; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:200+i];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
            btn.selected = NO;
        }
        
        [btn setBackgroundColor:MainColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        if(btn.selected == YES){
//            [selDic removeObjectForKey:str];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
            btn.selected = NO;
            mark = false;
            
            return;
        }
        
        btn.selected = YES;
        
        
        return;
    }
    
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:200];
    [btn3 setBackgroundColor:[UIColor whiteColor]];
    [btn3 setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
    btn3.selected = NO;
    mark = false;
    
    [btn setBackgroundColor:MainColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    if(selTag != 0){
//        UIButton *reBtn = (UIButton *)[self.view viewWithTag:selTag];
//        [reBtn setBackgroundColor:[UIColor whiteColor]];
//        [reBtn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
//    }
    
    
    
    ScreenDetailModel *model = dataArr[btn.tag-200];
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    [selDic setObject:model forKey:str];
    
    nowModel = model;
    
    if(btn.selected == YES){
        [selDic removeObjectForKey:str];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
        btn.selected = NO;
        return;
    }
    
//    if(selTag == btn.tag){
//        [selDic removeObjectForKey:str];
//    }
    
//    selTag = btn.tag;

    btn.selected = YES;
    
}

-(void)requestData{

    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [[InterfaceSingleton shareInstance].interfaceModel getFarmStuffWithFid:str WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSLog(@"成功");
            
            dataArr = [NSMutableArray array];
            
            ScreenDetailModel *Zmodel = [[ScreenDetailModel alloc]init];
            
            Zmodel.name = @"全部";
            Zmodel.needId = @"-10";
            
            [dataArr addObject:Zmodel];
            
            NSArray *arr = data;
            for (int i = 0 ; i<arr.count; i++) {
                
                NSDictionary *dic = arr[i];
                
                ScreenDetailModel *model = [[ScreenDetailModel alloc]init];
                
                model.name = dic[@"username"];
                model.needId = dic[@"id"];
                [dataArr addObject:model];
                
            }
            
            [self createBtn];
            
            
        }
        if(state == 2001){
            [MBProgressHUD showSuccess:@"暂无员工"];
        }
        if(state < 2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];

}

-(void)createConfirmBtn{

    UIButton *btn = [[UIButton alloc]init];
    
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:MainColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(ConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(100)));
    }];
}

-(void)ConfirmClick{
    NSLog(@"点击筛选");
    
    NSArray *arr = [selDic allValues];
    
    if(arr.count == 0){
        
        if(mark == false){
            [MBProgressHUD showSuccess:@"请选择筛选条件"];
            return;
        }
    }
    if([self.delegate respondsToSelector:@selector(selectWithDic:)]){
        [self.delegate selectWithDic:selDic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
