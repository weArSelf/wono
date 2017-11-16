//
//  SetTempViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/26.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "SetTempViewController.h"
#import "SetModel.h"
#import "TempSetTableViewCell.h"
#import "CDZPicker.h"


@interface SetTempViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,strong)UILabel *setNumLabel;
@property (nonatomic,strong)UIView *setView;

@property (nonatomic,strong) UILabel *selectLabel;
@property (nonatomic,strong) UITableView *selectTableView;



@end


@implementation SetTempViewController{
    NSMutableArray *numberDataArr;
    NSMutableArray *dataArr;
    
    SetModel *SelModel;
    NSMutableDictionary *selDic;
    
    int a1;
    int a2;
    
    int b1;
    int b2;
    
    int c1;
    int c2;
    
    int d1;
    int d2;
    
    int firMark;
    
    int changedMark;
    
    NSMutableArray *numberDataArr2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    changedMark = 0;
    firMark = 0;
    
    a1 = -50;
    a2 = -50;
    
    b1 = -50;
    b2 = -50;
    
    c1 = -50;
    c2 = -50;
    
    d1 = -50;
    d2 = -50;
    
    selDic = [NSMutableDictionary dictionary];
    
    SelModel = [[SetModel alloc]init];
    
    dataArr = [NSMutableArray array];
    
    numberDataArr = [NSMutableArray array];
    numberDataArr2 = [NSMutableArray array];
    
    for(int i = -10;i<=60;i++){
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [numberDataArr addObject:str];
    }
    
    for(int i = 0;i<=100;i++){
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [numberDataArr2 addObject:str];
    }
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTitleAndBackBtn];
    [self createSaveBtn];
    [self createFirstHead];
    [self createNextHead];
    
    [self createDetail];
    [self requestData];
}

-(void)requestData{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];

    [[InterfaceSingleton shareInstance].interfaceModel getPengWithFid:str AndCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            NSLog(@"成功");
            
            dataArr = [NSMutableArray array];
            
            NSArray *arr = data;
            
            for(int i=0;i<arr.count;i++){
                
                NSDictionary *dic = arr[i];
                
                SetModel *model = [[SetModel alloc]init];
                
                model.name = dic[@"name"];
                model.needID = dic[@"id"];
                NSDictionary *dic1 = dic[@"monitor_threshold"];
                
                if([dic1[@"high_air_temp"]intValue]!=-1000){
                
                    model.airMax = dic1[@"high_air_temp"];
                }else{
                    model.airMax = @"暂无";
                }
                if([dic1[@"low_air_temp"]intValue]!=-1000){
                    

                model.airMin = dic1[@"low_air_temp"];
                }else{
                    model.airMin = @"暂无";
                }
                
                if([dic1[@"high_ground_temp"]intValue]!=-1000){
                    

                model.landMax = dic1[@"high_ground_temp"];
                }else{
                    model.landMax = @"暂无";
                }

                if([dic1[@"low_ground_temp"]intValue]!=-1000){
                    
                model.landMin = dic1[@"low_ground_temp"];
                }else{
                    model.landMin = @"暂无";
                }
                if([dic1[@"high_air_humidity"]intValue]!=-1000){
                    
                model.air2Max = dic1[@"high_air_humidity"];
                }else{
                    model.air2Max = @"暂无";
                }
                if([dic1[@"low_air_humidity"]intValue]!=-1000){
                    
                model.air2Min = dic1[@"low_air_humidity"];
                }else{
                    model.air2Min = @"暂无";
                }
                if([dic1[@"high_ground_humidity"]intValue]!=-1000){
                    
                model.land2Max = dic1[@"high_ground_humidity"];
                }else{
                    model.land2Max = @"暂无";
                }
                if([dic1[@"low_ground_humidity"]intValue]!=-1000){
                    
                model.land2Min = dic1[@"low_ground_humidity"];
                }else{
                    model.land2Min = @"暂无";
                }
                
                [dataArr addObject:model];
            }
            
            [_selectTableView reloadData];
            
            if(firMark == 0){
                
                firMark ++;
                _selectTableView.alpha = 0;
                [UIView animateWithDuration:0.5 animations:^{
                    _selectTableView.alpha = 1;
                }];
                
            }
            
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
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

-(void)createSaveBtn{
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setTitle:@"保存设置" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_saveBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_saveBtn];
//    _saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right).offset(-HDAutoWidth(20));
        make.height.equalTo(@(HDAutoHeight(26)));
        make.width.equalTo(@(HDAutoWidth(150)));
    }];
    UIButton *hubBtn = [[UIButton alloc]init];
    [hubBtn setBackgroundColor:[UIColor clearColor]];
    [hubBtn addTarget:self action:@selector(SaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:hubBtn];
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_headView.mas_right).offset(0);
        make.height.equalTo(@(HDAutoHeight(86)));
        make.width.equalTo(@(HDAutoWidth(220)));
    }];
}

-(void)SaveClick{
    NSLog(@"点击保存");
    
    
    NSArray *arr = [selDic allValues];
    
    if(arr.count==0){
        [MBProgressHUD showSuccess:@"请选择要设置的大棚"];
        return;
    }
    if(changedMark == 0){
        [MBProgressHUD showSuccess:@"请填写需要设置的内容"];
        return;
    }
    
    NSString *str = [self objArrayToJSON:arr];
    SelModel.needID = str;
    _saveBtn.enabled = NO;
    
    [[InterfaceSingleton shareInstance].interfaceModel updatePengAlertWithModel:SelModel WithCallBack:^(int state, id data, NSString *msg) {
        _saveBtn.enabled = YES;
        if(state == 2000){
            NSLog(@"成功");
            [MBProgressHUD showSuccess:@"设置成功"];
            
            [self requestData];
            
            selDic = [NSMutableDictionary dictionary];
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}


//把多个json字符串转为一个json字符串
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        
        int a = [array[i]intValue];
        NSString *str = [NSString stringWithFormat:@"%d",a];
        
        jsonStr = [jsonStr stringByAppendingString:str];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"设置预警值";
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

-(void)createFirstHead{
    _setNumLabel = [[UILabel alloc]init];
    _setNumLabel.text = @"设置数值";
    _setNumLabel.font = [UIFont systemFontOfSize:13];
    _setNumLabel.textColor = UIColorFromHex(0x727171);
    [self.view addSubview:_setNumLabel];
    
    [_setNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backBtn.mas_left);
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(APP_CONTENT_WIDTH/2));
    }];
    
    _setView = [[UIView alloc]init];
    _setView.backgroundColor = [UIColor whiteColor];
    _setView.layer.shadowColor = [UIColor blackColor].CGColor;
    _setView.layer.shadowOpacity = 0.3f;
    _setView.layer.shadowRadius =5;
    _setView.layer.shadowOffset = CGSizeMake(5,5);
//    _setView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _setView.layer.borderWidth = 0.6;
    //    _ConView.layer.masksToBounds = YES;
    _setView.layer.cornerRadius = 5;
    
    [self.view addSubview:_setView];
    
    [_setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setNumLabel.mas_bottom).offset(5);
        make.height.equalTo(@(HDAutoHeight(430)));
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
}

-(void)createDetail{
    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"最低值=          °C"];
    NSRange range1=[[title string]rangeOfString:@"         "];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range1];
    NSMutableAttributedString *title2 = [[NSMutableAttributedString alloc] initWithString:@"最高值=          °C"];
    NSRange range2=[[title2 string]rangeOfString:@"         "];
//    NSRange titleRange = {0,[title length]};
    [title2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range2];
    
    NSMutableAttributedString *title3 = [[NSMutableAttributedString alloc] initWithString:@"最低值=          %"];
//    NSRange range1=[[title string]rangeOfString:@"         "];
    [title3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range1];
    NSMutableAttributedString *title4 = [[NSMutableAttributedString alloc] initWithString:@"最高值=          %"];
//    NSRange range2=[[title2 string]rangeOfString:@"         "];
    //    NSRange titleRange = {0,[title length]};
    [title4 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range2];
    
    
    UILabel *tempLabel = [self myLabel];
    tempLabel.text = @"气温:";
    
    UILabel *tempMinLabel = [self myLabel2];
    tempMinLabel.attributedText = title;
    tempMinLabel.tag = 101;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel addGestureRecognizer:labelTapGestureRecognizer];
    tempMinLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel = [self myLabel2];
    tempMaxLabel.attributedText =title2;
//    tempMaxLabel.textAlignment = NSTextAlignmentRight;
    tempMaxLabel.tag = 102;
    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMaxLabel addGestureRecognizer:labelTapGestureRecognizer2];
    tempMaxLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [_setView addSubview:tempLabel];
    [_setView addSubview:tempMinLabel];
    [_setView addSubview:tempMaxLabel];
    
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_setView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_setView.mas_top).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    [tempMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempLabel.mas_left);
        make.top.equalTo(tempLabel.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));

    }];
    
    [tempMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setView.mas_right).offset(-HDAutoWidth(24));
        make.top.equalTo(tempMinLabel.mas_top);
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(250)));
    }];
    
    UILabel *tempLabel2 = [self myLabel];
    tempLabel2.text = @"地温:";
    
    UILabel *tempMinLabel2 = [self myLabel2];
    tempMinLabel2.attributedText =title;
    tempMinLabel2.tag = 201;
    UITapGestureRecognizer *labelTapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel2 addGestureRecognizer:labelTapGestureRecognizer3];
    tempMinLabel2.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel2 = [self myLabel2];
    tempMaxLabel2.attributedText = title2;
//    tempMaxLabel2.textAlignment = NSTextAlignmentRight;
    tempMaxLabel2.tag = 202;
    UITapGestureRecognizer *labelTapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMaxLabel2 addGestureRecognizer:labelTapGestureRecognizer4];
    tempMaxLabel2.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [_setView addSubview:tempLabel2];
    [_setView addSubview:tempMinLabel2];
    [_setView addSubview:tempMaxLabel2];
    
    [tempLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_setView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(tempMaxLabel.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    [tempMinLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempLabel.mas_left);
        make.top.equalTo(tempLabel2.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
        
    }];
    
    [tempMaxLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setView.mas_right).offset(-HDAutoWidth(24));
        make.top.equalTo(tempMinLabel2.mas_top);
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(250)));
    }];
    
    UILabel *tempLabel3 = [self myLabel];
    tempLabel3.text = @"气湿:";
    
    UILabel *tempMinLabel3 = [self myLabel2];
    tempMinLabel3.attributedText = title3;
    tempMinLabel3.tag = 301;
    UITapGestureRecognizer *labelTapGestureRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel3 addGestureRecognizer:labelTapGestureRecognizer5];
    tempMinLabel3.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel3 = [self myLabel2];
    tempMaxLabel3.attributedText =title4;
//    tempMaxLabel3.textAlignment = NSTextAlignmentRight;
    tempMaxLabel3.tag = 302;
    UITapGestureRecognizer *labelTapGestureRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMaxLabel3 addGestureRecognizer:labelTapGestureRecognizer6];
    tempMaxLabel3.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [_setView addSubview:tempLabel3];
    [_setView addSubview:tempMinLabel3];
    [_setView addSubview:tempMaxLabel3];
    
    [tempLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_setView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(tempMaxLabel2.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    [tempMinLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempLabel.mas_left);
        make.top.equalTo(tempLabel3.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
        
    }];
    
    [tempMaxLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setView.mas_right).offset(-HDAutoWidth(24));
        make.top.equalTo(tempMinLabel3.mas_top);
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(250)));
    }];
    
    UILabel *tempLabel4 = [self myLabel];
    tempLabel4.text = @"地湿:";
    
    UILabel *tempMinLabel4 = [self myLabel2];
    tempMinLabel4.attributedText = title3;
    tempMinLabel4.tag = 401;
    UITapGestureRecognizer *labelTapGestureRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel4 addGestureRecognizer:labelTapGestureRecognizer7];
    tempMinLabel4.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel4 = [self myLabel2];
    tempMaxLabel4.attributedText = title4;
//    tempMaxLabel4.textAlignment = NSTextAlignmentRight;
    tempMaxLabel4.tag = 402;
    UITapGestureRecognizer *labelTapGestureRecognizer8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMaxLabel4 addGestureRecognizer:labelTapGestureRecognizer8];
    tempMaxLabel4.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [_setView addSubview:tempLabel4];
    [_setView addSubview:tempMinLabel4];
    [_setView addSubview:tempMaxLabel4];
    
    [tempLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_setView.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(tempMaxLabel3.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
    }];
    
    [tempMinLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempLabel.mas_left);
        make.top.equalTo(tempLabel4.mas_bottom).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(300)));
        
    }];
    
    [tempMaxLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setView.mas_right).offset(-HDAutoWidth(24));
        make.top.equalTo(tempMinLabel4.mas_top);
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(HDAutoWidth(250)));
    }];
  
    
}

-(void)labelClick:(UITapGestureRecognizer *)recognizer{
    UILabel *label=(UILabel*)recognizer.view;
    
    NSLog(@"%ld被点击了",(long)label.tag);
    
    if(numberDataArr.count == 0||numberDataArr == nil){
        return;
    }
    
    NSArray *needArr = [NSArray array];
    if(label.tag>=300){
        needArr = numberDataArr2;
    }else{
        needArr = numberDataArr;
    }
    
    
    [CDZPicker showPickerInView:self.view withStrings:needArr confirm:^(NSArray<NSString *> *stringArray) {
//        self.label.text = stringArray.firstObject;
        
//        int res = [stringArray.firstObject intValue];
        changedMark = 1;
        switch (label.tag) {
            case 101:{
                a1 = [stringArray.firstObject intValue];
                
                if(a2!=-50){
                    if(a1>a2){
                        
                        int qwe = a1;
                        a1 = a2;
                        a2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:102];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",a2];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;

                        
                        SelModel.airMax = [NSString stringWithFormat:@"%d",a2];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",a1];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;

                
                
                SelModel.airMin = [NSString stringWithFormat:@"%d",a1];
                 break;
            }
            case 102:{
                
                
                a2 = [stringArray.firstObject intValue];
                
                if(a1!=-50){
                    if(a1>a2){
                        
                        int qwe = a1;
                        a1 = a2;
                        a2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:101];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",a1];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        
                        SelModel.airMin = [NSString stringWithFormat:@"%d",a1];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",a2];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;
                
                
                
                SelModel.airMax = [NSString stringWithFormat:@"%d",a2];

                
                
                break;
            }
            case 201:{
                
                
                b1 = [stringArray.firstObject intValue];
                
                if(b2!=-50){
                    if(b1>b2){
                        
                        int qwe = b1;
                        b1 = b2;
                        b2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:202];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",b2];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        SelModel.landMax = [NSString stringWithFormat:@"%d",b2];
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",b1];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;

                
                SelModel.landMin = [NSString stringWithFormat:@"%d",b1];
                
                break;
            }
            case 202:{
                
                b2 = [stringArray.firstObject intValue];
                
                if(b1!=-50){
                    if(b1>b2){
                        
                        int qwe = b1;
                        b1 = b2;
                        b2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:201];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",b1];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        
                        SelModel.landMin = [NSString stringWithFormat:@"%d",b1];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",b2];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;
                
                
                
                SelModel.landMax = [NSString stringWithFormat:@"%d",b2];
                
                break;
            }
            case 301:{
                
                
                c1 = [stringArray.firstObject intValue];
                
                if(c2!=-50){
                    if(c1>c2){
                        
                        int qwe = c1;
                        c1 = c2;
                        c2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:302];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",c2];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        SelModel.air2Max = [NSString stringWithFormat:@"%d",c2];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",c1];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;

                
                SelModel.air2Min = [NSString stringWithFormat:@"%d",c1];
                
                break;
            }
            case 302:{
                
                c2 = [stringArray.firstObject intValue];
                
                if(c1!=-50){
                    if(c1>c2){
                        
                        int qwe = c1;
                        c1 = c2;
                        c2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:301];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",c1];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        
                        SelModel.air2Min = [NSString stringWithFormat:@"%d",a1];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",c2];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;
                
                
                
                SelModel.air2Max = [NSString stringWithFormat:@"%d",c2];
                
                break;
            }
            case 401:{
                
                
                d1 = [stringArray.firstObject intValue];
                
                if(d2!=-50){
                    if(d1>d2){
                        
                        int qwe = d1;
                        d1 = d2;
                        d2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:402];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",d2];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        SelModel.land2Max = [NSString stringWithFormat:@"%d",d2];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",d1];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;

                SelModel.land2Min = [NSString stringWithFormat:@"%d",d1];
                
                break;
            }
            case 402:{
                
                d2 = [stringArray.firstObject intValue];
                
                if(d1!=-50){
                    if(d1>d2){
                        
                        int qwe = d1;
                        d1 = d2;
                        d2 = qwe;
                        
                        UILabel *label2 = [self.view viewWithTag:401];
                        
                        NSString *str = [NSString stringWithFormat:@"%d",d1];
                        NSString *str2 = label2.text;
                        str2 = [str2 substringToIndex:8];
                        
                        NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                        
                        NSRange range = NSMakeRange(str2.length-2, str.length+4);
                        
                        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                        
                        
                        label2.attributedText = title;
                        
                        
                        SelModel.land2Min = [NSString stringWithFormat:@"%d",d1];
                        
                    }
                }
                
                
                NSString *str = [NSString stringWithFormat:@"%d",d2];
                NSString *str2 = label.text;
                str2 = [str2 substringToIndex:8];
                
                NSString *result = [NSString stringWithFormat:@"%@%@  %%",str2,str];
                
                NSRange range = NSMakeRange(str2.length-2, str.length+4);
                
                NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
                [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
                
                
                label.attributedText = title;
                
                
                
                SelModel.land2Max = [NSString stringWithFormat:@"%d",d2];
                
                break;
            }
                
               
                
            default:
                break;
        }
        
        
        NSLog(@"点击");
        
//        NSString *str = stringArray.firstObject;
//        NSString *str2 = label.text;
//        str2 = [str2 substringToIndex:8];
//        
//        NSString *result = [NSString stringWithFormat:@"%@%@  °C",str2,str];
//        
//        NSRange range = NSMakeRange(str2.length-2, str.length+4);
//        
//        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:result];
//        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
//        
//        
//        label.attributedText = title;
    }cancel:^{
        //your code
        NSLog(@"取消");
        
    }];
    
    
}
-(UILabel *)myLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x000000);
    return label;
}

-(UILabel *)myLabel2{
    UILabel * label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHex(0x727171);
    return label;
}

-(void)createNextHead{
    
    _selectLabel = [[UILabel alloc]init];
    _selectLabel.text = @"选择大棚";
    _selectLabel.font = [UIFont systemFontOfSize:13];
    _selectLabel.textColor = UIColorFromHex(0x727171);
    [self.view addSubview:_selectLabel];
    
    [_selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backBtn.mas_left);
        make.top.equalTo(_setView.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(30)));
        make.width.equalTo(@(APP_CONTENT_WIDTH/2));
    }];

    _selectTableView = [[UITableView alloc]init];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _wonoTableView.allowsSelection = NO;
    _selectTableView.dataSource = self;
    _selectTableView.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _selectTableView.backgroundColor = [UIColor whiteColor];
//    _wonoTableView.frame = self.view.frame;
    
    [self.view addSubview:_selectTableView];
    
    [_selectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_selectLabel.mas_bottom).offset(HDAutoHeight(10));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    TempSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
        cell = [[TempSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        [cell setLeftColor:[UIColor blueColor]];
//    }
    
    SetModel *model = dataArr[indexPath.row];
    
    cell.model = model;
    
    //    [cell creatConView];
    
    
    NSArray *arr = [selDic allValues];
    for(int i=0;i<arr.count;i++){
        NSString *str1 = [NSString stringWithFormat:@"%@",arr[i]];
        NSString *str2 = [NSString stringWithFormat:@"%@",model.needID];
        if([str1 isEqualToString:str2]){
            [cell changeColor];
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(160);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击");
    
    
    SetModel *nowModel = dataArr[indexPath.row];
    NSString *needID = nowModel.needID;
    
//    static NSString *cellIdentifier = @"cellIdentifier";
//    TempSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TempSetTableViewCell * cell = (TempSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.selectMark == false){
        [cell changeColor];
        
        [selDic setObject:needID forKey:needID];
    }else{
        [cell changeBackColor];
        
        [selDic removeObjectForKey:needID];
    }
    
    
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
//    TempSetTableViewCell * cell = (TempSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell changeBackColor];
//}

@end
