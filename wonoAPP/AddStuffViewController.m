//
//  NeedSelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "AddStuffViewController.h"
#import "StuffTableViewCell.h"
#import "SearchModel.h"

@interface AddStuffViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UITextField *mainTextField;
@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UITableView *stuffTableView;

@end

@implementation AddStuffViewController{
    int count;
    NSTimer *nowNsTimer;
    NSTimer *newNsTimer;
    NSString *orginStr;
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    count = 5;
    dataArr = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTitleAndBackBtn];
//    [self createConfirmBtn];
    [self createMain];
    [self createTable];
    orginStr = @"";
    //    newNsTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];

    
}

-(void)timerFired{
    NSLog(@"aa");
    
    [[InterfaceSingleton shareInstance].interfaceModel searchForUserPhone:_mainTextField.text WithCallBack:^(int state, id data, NSString *msg) {
        
//        if(state == 2000){
            NSArray *arr = data;
            
            [dataArr removeAllObjects];
            
            for(int i=0;i<arr.count;i++){
                SearchModel *model = [[SearchModel alloc]init];
                NSDictionary *dic = data[i];
                model.imageUrl = dic[@"avatar"];
                model.name = dic[@"username"];
                model.phoneNum = dic[@"mobile"];
                model.stufID = dic[@"id"];
                [dataArr addObject:model];
            }
            
            [_stuffTableView reloadData];
            
            NSLog(@"搜索成功");
            
//        }else{
//            [MBProgressHUD showSuccess:msg];
//        }
        
    }];
    

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
    _titleLabel.text = @"添加员工";
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

-(void)createMain{
    
    _mainTextField = [[UITextField alloc]init];
    _mainTextField.placeholder = @"请输入员工手机号";
    _mainTextField.font = [UIFont systemFontOfSize:13];
    _mainTextField.textColor = UIColorFromHex(0x727171);
    _mainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextField.layer.masksToBounds = YES;
    _mainTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mainTextField.layer.borderWidth = 0.4;
    _mainTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _mainTextField.leftViewMode = UITextFieldViewModeAlways;
    _mainTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mainTextField.delegate = self;
    [_mainTextField addTarget:self
                        action:@selector(textFieldEditChanged:)
              forControlEvents:UIControlEventEditingChanged];

    [self.view addSubview:_mainTextField];
    [_mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(-1);
        make.right.equalTo(self.view.mas_right).offset(1);
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(70)));
    }];
    
}

-(void)createConfirmBtn{
    _confirmBtn = [[UIButton alloc]init];
    [_confirmBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_confirmBtn];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(98)));
    }];
}

-(void)confirmClick{
    NSLog(@"点击修改");
    
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"输入改变");
    
    if([orginStr isEqualToString:@""]){
        orginStr = textField.text;
        [self timerFired];
        
    }else{
        if(nowNsTimer!=nil){
            [nowNsTimer invalidate];
        }
        
        newNsTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
        [newNsTimer fireDate];
        
        nowNsTimer = newNsTimer;

    }
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mainTextField resignFirstResponder];
    
}


-(void)createTable{
    
    _stuffTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _stuffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _stuffTableView.dataSource = self;
    _stuffTableView.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _stuffTableView.backgroundColor = [UIColor clearColor];
    _stuffTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
    //    _plantTableView.frame = self.view.frame;
    //    _stuffTableView.showsVerticalScrollIndicator = NO;
    //    _stuffTableView.scrollEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [_stuffTableView addGestureRecognizer:tap];
    
    
    [self.view addSubview:_stuffTableView];
    
    [_stuffTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_mainTextField.mas_bottom).offset(HDAutoHeight(40));
        make.bottom.equalTo(self.view.mas_bottom).offset(-HDAutoHeight(60));
    }];
    
    
    
}

-(void)tapClick{
    NSLog(@"点击了");
    [_mainTextField resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    StuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[StuffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    cell.tag = 300 +indexPath.row;
    
    SearchModel *model = dataArr[indexPath.row];
    
    cell.searchModel = model;
    
    //    [cell creatConView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_mainTextField resignFirstResponder];
    
    SearchModel *model = dataArr[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"是否添加员工%@?",model.name];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        NSString *fid = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
        [[InterfaceSingleton shareInstance].interfaceModel farmAddStuffWithFid:fid AndUid:model.stufID WithCallBack:^(int state, id data, NSString *msg) {
           
            if(state == 2000){
                [MBProgressHUD showSuccess:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if(state<2000){
                [MBProgressHUD showSuccess:msg];
            }
            
        }];
        
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertC addAction:cancel];
    [alertC addAction:confirm];
    [self presentViewController:alertC animated:YES completion:nil];
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}

@end
