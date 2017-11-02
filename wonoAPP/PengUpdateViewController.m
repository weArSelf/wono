//
//  NeedSelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "PengUpdateViewController.h"
#import "CDZPicker.h"
#import "AddStuffViewController.h"
#import "StuffTableViewCell.h"
#import "PengTypeViewController.h"
#import "PengTypeModel.h"
#import "BBFlashCtntLabel.h"

#import <BabyBluetooth/BabyBluetooth.h>

@interface PengUpdateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UITextField *mainTextField;
@property (nonatomic,strong)UIButton *searchBtn;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UILabel *searchLabel;

@property (nonatomic,strong)UITextField *pengNameTextField;

@property (nonatomic,strong)UIButton *catSelBtn;

@property (nonatomic,strong)UILabel *typeLabel;

@property (nonatomic,strong)UIButton *addBtn;

@property (nonatomic,strong)UITableView *stuffTableView;

@property (nonatomic,strong) UILabel *catLabelContent;
@property (nonatomic,strong) UILabel *typeLabelContent;


@end

@implementation PengUpdateViewController{
    int count;
    BabyBluetooth *baby;
    
    NSMutableArray *typeArr;
    NSMutableArray *typeIDArr;
    
    NSString *titleStr;
    
    NSMutableArray *dataArr;
    
    NSString *nowType;
    
    NSMutableDictionary *stuffDic;
    
    NSString *nowPlantTypeId;
    
    NSArray *stuffArr;
    
    NSString *orginStuff;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    orginStuff = @"";
    nowPlantTypeId = @"";
    titleStr = @"";
    nowType = @"";
    stuffDic = [NSMutableDictionary dictionary];
    typeArr = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle:) name:@"catChange" object:nil];
    
    // Do any additional setup after loading the view.
    count = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTitleAndBackBtn];
    [self createConfirmBtn];
    
}


-(void)requestStuff{
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    
    [[InterfaceSingleton shareInstance].interfaceModel getFarmStuffWithFid:str WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSArray *arr = data;
            dataArr = [NSMutableArray array];
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                SearchModel *model = [[SearchModel alloc]init];
                model.imageUrl = dic[@"avatar"];
                model.name = dic[@"username"];
                model.phoneNum = dic[@"greenHouse"];
                model.stufID = dic[@"id"];
                
                [dataArr addObject:model];
                
            }
            int con = 0;
            for (int i=0; i<dataArr.count; i++) {
                SearchModel *model = dataArr[i];
                NSString *str = model.stufID;
                int instr = [str intValue];
                for (int j=0; j<stuffArr.count; j++) {
                    NSString *name = stuffArr[j];
                    int in2 = [name intValue];
                    if(instr == in2){
                        if(con !=i){
                            [dataArr exchangeObjectAtIndex:con withObjectAtIndex:i];
                            i--;
                            con++;
                        }
                    }
                }
            }
            
            [_stuffTableView reloadData];
            _stuffTableView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                _stuffTableView.alpha = 1;
            }];
            
        }
        
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
        
        
    }];
    
}



-(void)changeTitle:(NSNotification *)noti{
    
    //    UIColor *receiveColor=(UIColor *)[notification object];
    
    if([noti object] == nil){
        _catLabelContent.text = @"未选择品种";
        nowPlantTypeId = @"";
        return;
    }
    
    PengTypeModel *model = (PengTypeModel *)[noti object];
    
    NSString *newStr = model.typeName;
    
    NSString *reId = model.typeId;
    
    int re = [reId intValue];
    
    nowPlantTypeId = [NSString stringWithFormat:@"%d",re];
    
    
    if([titleStr isEqualToString:@""]){
        titleStr = newStr;
    }else{
        
        NSString *new = [NSString stringWithFormat:@"%@>%@",titleStr,newStr];
        titleStr = new;
    }
    _catLabelContent.text = titleStr;
    
}

-(void)createBlusTooth{
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    
    //    baby.scanForPeripherals().begin();
    
    //    __block BabyBluetooth *blTooth = baby;
    
    //示例：
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，开始扫描设备");
            //搜索设备
            //            blTooth.scanForPeripherals().begin();
            //            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            //每个service
            NSLog(@"qweqweqwe");
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
}

//设置蓝牙委托
-(void)babyDelegate{
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        //if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //    return YES;
        //}
        //return NO;
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_stuffTableView reloadData];
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


-(void)requestType{
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengTypeCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            typeArr = [NSMutableArray array];
            typeIDArr = [NSMutableArray array];
            NSArray *arr = data;
            
            for (int i=0; i<arr.count; i++) {
                NSString *str = arr[i][@"name"];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:arr[i][@"name"] forKey:@"name"];
                [dic setObject:arr[i][@"id"] forKey:@"id"];
                
                [typeIDArr addObject:dic];
                
                
                [typeArr addObject:str];
            }
            
            NSLog(@"成功");
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
}


-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"";
//    大棚详情
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
        make.width.equalTo(@(HDAutoHeight(500)));
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
    _mainTextField.delegate = self;
    _mainTextField.placeholder = @"请输入设备的识别号";
    _mainTextField.font = [UIFont systemFontOfSize:13];
    _mainTextField.textColor = UIColorFromHex(0x727171);
    _mainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextField.layer.masksToBounds = YES;
    _mainTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mainTextField.layer.borderWidth = 0.6;
    _mainTextField.layer.cornerRadius = 5;
    _mainTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _mainTextField.leftViewMode = UITextFieldViewModeAlways;
    //    _mainTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_mainTextField];
    [_mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(30));
        make.top.equalTo(_headView.mas_bottom).offset(HDAutoHeight(30));
        make.height.equalTo(@(HDAutoHeight(68)));
    }];
    
    _searchBtn = [[UIButton alloc]init];
    [_searchBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    [_searchBtn setTitle:@"搜索设备" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.cornerRadius = 5;
    [self.view addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainTextField.mas_right).offset(HDAutoWidth(30));
        make.top.equalTo(_mainTextField.mas_top);
        make.height.equalTo(_mainTextField.mas_height);
        make.width.equalTo(@(HDAutoWidth(225)));
    }];
    _searchBtn.alpha = 0;
    _searchLabel = [[UILabel alloc]init];
    _searchLabel.font = [UIFont systemFontOfSize:13];
    _searchLabel.textColor = UIColorFromHex(0x727171);
    _searchLabel.text = @"请确认设备号与实际匹配，否则无法收到数据。";
//    当前设备未被绑定，可连接
    _searchLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_searchLabel];
    
    [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainTextField.mas_left);
        make.top.equalTo(_mainTextField.mas_bottom).offset(HDAutoHeight(10));
        make.right.equalTo(_searchLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(45)));
    }];
    
}

-(void)searchClick{
    NSLog(@"点击搜索设备");
    baby.scanForPeripherals().begin();
    
}

-(void)createConfirmBtn{
    _confirmBtn = [[UIButton alloc]init];
    [_confirmBtn setTitle:@"修改" forState:UIControlStateNormal];
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

-(void)createPengNameAndOther{
    _pengNameTextField = [[UITextField alloc]init];
    _pengNameTextField.delegate = self;
    _pengNameTextField.placeholder = @"请输入大棚的占地面积（亩）";
    _pengNameTextField.font = [UIFont systemFontOfSize:13];
    _pengNameTextField.textColor = UIColorFromHex(0x727171);
    _pengNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pengNameTextField.layer.masksToBounds = YES;
    _pengNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pengNameTextField.layer.borderWidth = 0.6;
    _pengNameTextField.layer.cornerRadius = 5;
    _pengNameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _pengNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _pengNameTextField.leftViewMode = UITextFieldViewModeAlways;
    //    _pengNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pengNameTextField];
    [_pengNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(30));
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(30));
        make.top.equalTo(_searchLabel.mas_bottom).offset(HDAutoHeight(20));
        make.height.equalTo(@(HDAutoHeight(68)));
    }];
    
    
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"请选择大棚种植的品种"];
    [attri setAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]} range:NSMakeRange(0, attri.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attri.length)];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"1-进入"];
    // 设置图片大小
    attch.bounds = CGRectMake(HDAutoWidth(10), -HDAutoHeight(10.5), HDAutoHeight(35), HDAutoHeight(35));
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    
    
    
    
    _catSelBtn = [[UIButton alloc]init];
    [_catSelBtn setBackgroundColor:UIColorFromHex(0x3eb36e)];
    [_catSelBtn setAttributedTitle:attri forState:UIControlStateNormal];
    [_catSelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_catSelBtn addTarget:self action:@selector(catClick) forControlEvents:UIControlEventTouchUpInside];
    //    _catSelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _catSelBtn.layer.masksToBounds = YES;
    _catSelBtn.layer.cornerRadius = 5;
//    [self.view addSubview:_catSelBtn];
//    [_catSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_mainTextField.mas_left);
//        make.top.equalTo(_pengNameTextField.mas_bottom).offset(HDAutoHeight(15));
//        make.height.equalTo(_mainTextField.mas_height);
//        make.width.equalTo(@(HDAutoWidth(380)));
//    }];
    
    
}

-(void)catClick{
    
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengWithCatPid:@"0" AndCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            NSLog(@"");
            
            titleStr = @"";
            
            NSMutableArray *dataArr233 = [NSMutableArray array];
            
            NSArray *arr = data;
            
            for (int i=0; i<arr.count; i++) {
                PengTypeModel *model = [[PengTypeModel alloc]init];
                NSDictionary *dic = arr[i];
                model.typeName = dic[@"name"];
                model.typeId = dic[@"id"];
                [dataArr233 addObject:model];
            }
            
            
            
            PengTypeViewController *pengtype = [[PengTypeViewController alloc]init];
            pengtype.NowdataArr = dataArr233;
            
            [self.navigationController pushViewController:pengtype animated:YES];
            
        }
        if(state<2000){
            [MBProgressHUD showSuccess:msg];
        }
        
    }];
    
}

-(void)createTypeLabel{
    _typeLabel = [[UILabel alloc]init];
    _typeLabel.text = @"点击选择大棚类型";
    _typeLabel.textColor = UIColorFromHex(0x9fa0a0);
    _typeLabel.font = [UIFont systemFontOfSize:13];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeClick)];
    _typeLabel.userInteractionEnabled = YES;
    [_typeLabel addGestureRecognizer:tap];
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _typeLabel.layer.borderWidth = 0.6;
    _typeLabel.layer.cornerRadius = 5;
    
    
    [self.view addSubview:_typeLabel];
    
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainTextField.mas_left);
        make.top.equalTo(_pengNameTextField.mas_bottom).offset(HDAutoHeight(15));
        make.height.equalTo(_mainTextField.mas_height);
        make.width.equalTo(@(HDAutoWidth(380)));
    }];
}

-(void)typeClick{
    NSLog(@"点击选择类型");
    
    //    NSArray *arr = [NSArray arrayWithObjects:@"水果大棚",@"啊啊啊啊",@"呜呜呜呜",@"嗯嗯嗯嗯", nil];
    NSArray *arr = typeArr;
    if(arr.count == 0||arr == nil){
        return;
    }
    [CDZPicker showPickerInView:self.view withStrings:arr confirm:^(NSArray<NSString *> *stringArray) {
        
        NSString *str = stringArray.firstObject;
        
        _typeLabelContent.text = str;
        
        NSString *needId;
        
        for(int i=0;i<typeIDArr.count;i++){
            
            NSString *name = typeIDArr[i][@"name"];
            
            if([name isEqualToString:str]){
                needId = typeIDArr[i][@"id"];
            }
            
        }
        int re = [needId intValue];
        
        nowType = [NSString stringWithFormat:@"%d",re];
        
        
    } cancel:^{
        NSLog(@"点击取消了");
    }];
}



-(void)createAddBtn{
    
    _addBtn = [[UIButton alloc]init];
    [_addBtn setTitle:@"从上方列表中选择该大棚员工" forState:UIControlStateNormal];
    [_addBtn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
    //    [_addBtn setImage:[UIImage imageNamed:@"添加新员工"] forState:UIControlStateNormal];
    //    _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_addBtn];
    
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(HDAutoWidth(520)));
        make.height.equalTo(@(HDAutoHeight(128)));
        make.bottom.equalTo(_confirmBtn.mas_top);
        
    }];
    
}

-(void)addBtnClick{
    NSLog(@"点击添加新员工");
    AddStuffViewController *addStuff = [[AddStuffViewController alloc]init];
    [self.navigationController pushViewController:addStuff animated:YES];
}

-(void)createTable{
    
    _stuffTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _stuffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _stuffTableView.dataSource = self;
    _stuffTableView.delegate = self;
    _stuffTableView.backgroundColor = [UIColor clearColor];
    _stuffTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
    
    [self.view addSubview:_stuffTableView];
    
    [_stuffTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_typeLabel.mas_bottom).offset(HDAutoHeight(15));
        make.bottom.equalTo(_addBtn.mas_top).offset(-HDAutoHeight(0));
    }];
    
    
    
    
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
    
    
    for (int i=0; i<stuffArr.count; i++) {
        NSString *str = stuffArr[i];
        int needint = [str intValue];
        if([model.stufID intValue] == needint){
            [stuffDic setObject:model.stufID forKey:model.stufID];
            [cell changeColor];
        }
    }
    
    //    [cell creatConView];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_mainTextField resignFirstResponder];
    [_pengNameTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void)createOtherLabel{
    
    _catLabelContent = [[UILabel alloc]init];
    _catLabelContent.textColor = UIColorFromHex(0x9fa0a0);
    _catLabelContent.font = [UIFont systemFontOfSize:13];
    _catLabelContent.textAlignment = NSTextAlignmentCenter;
    _catLabelContent.text = @"未选择品种";
//    [self.view addSubview:_catLabelContent];
    
    _typeLabelContent = [[UILabel alloc]init];
    _typeLabelContent.textColor = UIColorFromHex(0x9fa0a0);
    _typeLabelContent.font = [UIFont systemFontOfSize:13];
    _typeLabelContent.textAlignment = NSTextAlignmentCenter;
    _typeLabelContent.text = @"未选择类型";
    [self.view addSubview:_typeLabelContent];
    
//    [_catLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_catSelBtn.mas_centerY);
//        make.height.equalTo(_catSelBtn.mas_height);
//        make.width.equalTo(@(HDAutoWidth(300)));
//        make.left.equalTo(_catSelBtn.mas_right).offset(HDAutoWidth(30));
//    }];
    [_typeLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_typeLabel.mas_centerY);
        make.height.equalTo(_typeLabel.mas_height);
        make.width.equalTo(@(HDAutoWidth(300)));
        make.left.equalTo(_typeLabel.mas_right).offset(HDAutoWidth(30));
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SearchModel *model = dataArr[indexPath.row];
    
    NSString *SelId = model.stufID;
    
    StuffTableViewCell * cell = (StuffTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.selectMark == false){
        
        [stuffDic setObject:SelId forKey:SelId];
        
        [cell changeColor];
    }else{
        
        [stuffDic removeObjectForKey:SelId];
        [cell changeColorBack];
    }
    
}

-(void)confirmClick{
    NSLog(@"点击添加");
//    NSString *fid = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    NSString *res;
    NSArray *arr = [stuffDic allValues];
    if(arr.count == 0){
        res = nil;
    }else{
        res = [self DataTOjsonString:arr];
    }
//
    if([_pengNameTextField.text isEqualToString:@""]&&[_mainTextField.text isEqualToString:@""]&&[nowType isEqualToString:@""]&&[res isEqualToString:orginStuff]){
        
        [MBProgressHUD showSuccess:@"请添加修改项"];
        return;
    }
    
    if(res == nil){
        
        [MBProgressHUD showSuccess:@"请预留员工"];
        return;
        
    }
//    arr;//现在的id们
//    stuffArr;//过去的id们
    NSDictionary *res233 = [self checkArrayWithArr1:stuffArr AndeArr2:arr];
    NSArray *jiegu = res233[@"jiegu"];
    NSArray *xinzeng = res233[@"xinzeng"];
    
    NSString *jiegustr = [self objArrayToJSON:jiegu];
    NSString *xinzengstr = [self objArrayToJSON:xinzeng];
    
    
//    return;
    [[InterfaceSingleton shareInstance].interfaceModel updatePengWithArea:_pengNameTextField.text AndGid:_pengID AndImei:_mainTextField.text AndType:nowType AndUids:res WithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            NSLog(@"成功");
            
            [[InterfaceSingleton shareInstance].interfaceModel jobChangeWithJob:xinzengstr AndUnJob:jiegustr WithGid:_pengID WithCallBack:^(int state, id data, NSString *msg) {
               
                if(state == 2000){
                    NSLog(@"成功");
                }
                
            }];
            
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:msg];
        }
    }];
    
}

-(NSDictionary *)checkArrayWithArr1:(NSArray *)arr1 AndeArr2:(NSArray *)arr2{
    //arr1原数组 arr2结果数组
    NSMutableArray *org1 = [NSMutableArray array];//解雇的
    NSMutableArray *org2 = [NSMutableArray array];//新增的
    
    for (int i=0; i<arr1.count; i++) {
        int mark = 1;
        for (int j=0; j<arr2.count; j++) {
            NSString *str1 = [NSString stringWithFormat:@"%@",arr1[i]];
            NSString *str2 = [NSString stringWithFormat:@"%@",arr2[j]];
            if(![str1 isEqualToString:str2]){
                mark++;
            }
            
        }
        
        if(mark!=arr2.count){
            NSString *str = [NSString stringWithFormat:@"%@",arr1[i]];
            [org1 addObject:str];
        }
    }
    for (int i=0; i<arr2.count; i++) {
        int mark = 1;
        for (int j=0; j<arr1.count; j++) {
            
            NSString *str1 = [NSString stringWithFormat:@"%@",arr2[i]];
            NSString *str2 = [NSString stringWithFormat:@"%@",arr1[j]];
            if(![str1 isEqualToString:str2]){
                mark++;
            }
            
        }
        if(mark!=arr1.count){
            NSString *str = [NSString stringWithFormat:@"%@",arr2[i]];
            [org2 addObject:str];
        }
    }
    NSMutableDictionary *redDic = [NSMutableDictionary dictionary];
    [redDic setObject:org1 forKey:@"jiegu"];
    [redDic setObject:org2 forKey:@"xinzeng"];
    return redDic;
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//把多个json字符串转为一个json字符串
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        
        NSString *str = array[i];
        int qw = [str intValue];
        NSString *res = [NSString stringWithFormat:@"%d",qw];
        
        jsonStr = [jsonStr stringByAppendingString:res];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}


-(void)setPengID:(NSString *)pengID{
    
    _pengID = pengID;
    
    [[InterfaceSingleton shareInstance].interfaceModel getPengDetailWithPengID:_pengID WithCallBack:^(int state, id data, NSString *msg) {
       
        if(state == 2000){
            
            [self createMain];
            [self createPengNameAndOther];
            [self createTypeLabel];
            [self createAddBtn];
            [self createTable];
            
            [self requestType];
            
            //    [self createBlusTooth];
            
            [self createOtherLabel];
            
            
            
            

            NSDictionary *dic = data;
            _mainTextField.placeholder =[NSString stringWithFormat:@"当前设备号:%@",dic[@"imei"]];
//            _mainTextField.enabled = NO;
//            _searchBtn.alpha = 0;
            
            NSString *name = dic[@"name"];
            _titleLabel.text = name;
            
            
            int a = [dic[@"area"]intValue];
            if(a!=0){
                _pengNameTextField.placeholder = [NSString stringWithFormat:@"大棚占地面积:%@",dic[@"area"]];
            }
//            _pengNameTextField.enabled = NO;
            
//            int varID = [dic[@"varieties_id"]intValue];
            
//            _catLabelContent.text = dic[@"variety_name"];
            
            _typeLabelContent.text = dic[@"type_name"];
            
            NSString *str = dic[@"employee_name"];
            
            stuffArr = dic[@"employee_ids"];
            
//            stuffDic
            for(int i=0;i<stuffArr.count;i++){
                NSString *str233 = stuffArr[i];
                [stuffDic setObject:str233 forKey:str233];
            }
            NSArray *arr123 = [stuffDic allValues];
            orginStuff = [self DataTOjsonString:arr123];
            
            NSLog(@"%@",str);
            
            [self requestStuff];
            
        }else{
            [MBProgressHUD showSuccess:msg];
        }
        
        
    }];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return  YES;
}

@end
