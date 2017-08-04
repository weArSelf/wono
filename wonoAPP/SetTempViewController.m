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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    numberDataArr = [NSMutableArray array];
    
    for(int i = 0;i<=35;i++){
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [numberDataArr addObject:str];
    }
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTitleAndBackBtn];
    [self createSaveBtn];
    [self createFirstHead];
    [self createNextHead];
    
    [self createDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
}

-(void)SaveClick{
    NSLog(@"点击保存");
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
    
    UILabel *tempLabel = [self myLabel];
    tempLabel.text = @"气温:";
    
    UILabel *tempMinLabel = [self myLabel2];
    tempMinLabel.text = @"最低值=          °C";
    tempMinLabel.tag = 101;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel addGestureRecognizer:labelTapGestureRecognizer];
    tempMinLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel = [self myLabel2];
    tempMaxLabel.text = @"最高值=          °C";
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
    tempMinLabel2.text = @"最低值=          °C";
    tempMinLabel2.tag = 201;
    UITapGestureRecognizer *labelTapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel2 addGestureRecognizer:labelTapGestureRecognizer3];
    tempMinLabel2.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel2 = [self myLabel2];
    tempMaxLabel2.text = @"最高值=          °C";
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
    tempMinLabel3.text = @"最低值=          °C";
    tempMinLabel3.tag = 301;
    UITapGestureRecognizer *labelTapGestureRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel3 addGestureRecognizer:labelTapGestureRecognizer5];
    tempMinLabel3.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel3 = [self myLabel2];
    tempMaxLabel3.text = @"最高值=          °C";
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
    tempMinLabel4.text = @"最低值=          °C";
    tempMinLabel4.tag = 401;
    UITapGestureRecognizer *labelTapGestureRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [tempMinLabel4 addGestureRecognizer:labelTapGestureRecognizer7];
    tempMinLabel4.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *tempMaxLabel4 = [self myLabel2];
    tempMaxLabel4.text = @"最高值=          °C";
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
    [CDZPicker showPickerInView:self.view withStrings:numberDataArr confirm:^(NSArray<NSString *> *stringArray) {
//        self.label.text = stringArray.firstObject;
        NSLog(@"点击");
        
        NSString *str = stringArray.firstObject;
        NSString *str2 = label.text;
        str2 = [str2 substringToIndex:8];
        
        NSString *result = [NSString stringWithFormat:@"%@%@°C",str2,str];
        
        label.text = result;
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    TempSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TempSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    //    [cell creatConView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(160);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击");
    
//    static NSString *cellIdentifier = @"cellIdentifier";
//    TempSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TempSetTableViewCell * cell = (TempSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.selectMark == false){
        [cell changeColor];
    }else{
        [cell changeBackColor];
    }
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
//    TempSetTableViewCell * cell = (TempSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell changeBackColor];
//}

@end
