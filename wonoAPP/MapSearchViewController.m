//
//  NeedSelectionViewController.m
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MapSearchViewController.h"
#import "StuffTableViewCell.h"
#import "SearchModel.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "CompleteInfoViewController.h"

@interface MapSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIButton *rightBtn;

@property (nonatomic,strong)UITextField *mainTextField;
@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UITableView *stuffTableView;

@end

@implementation MapSearchViewController{
//    int count;
    NSTimer *nowNsTimer;
    NSTimer *newNsTimer;
    NSString *orginStr;
    NSArray *dataArr;
    
    
    BMKPoiSearch *_poiSearch;            //poi搜索
    
    BMKGeoCodeSearch  *_geocodesearch;   //geo搜索服务

    
    int selectItem;
    
    NSString *lat;
    NSString *lont;
    NSString *resName;
    
    NSString *resCity;
    
    NSString *resAddress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lont = @"";
    lat = @"";
    
    resName = @"";
    
    selectItem = -1;
    dataArr = [NSArray array];
    
    // Do any additional setup after loading the view.
//    count = 5;
//    dataArr = [NSMutableArray array];
    
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
    
    lont = @"";
    lat = @"";
    
    
    _poiSearch = [[BMKPoiSearch alloc]init];
    
    _poiSearch.delegate = self;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    
    citySearchOption.pageIndex = 0;
    
    citySearchOption.pageCapacity = 30;
    
    /***
     <此处的city属性需要定位城市传过来，我写了固定值>
     ***/
    int va = [self.city intValue];
    NSString *re = [NSString stringWithFormat:@"%d",va];
    citySearchOption.city= re;
    
    citySearchOption.keyword = _mainTextField.text;
    
    BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
    
    if(flag)
        
    {
        
        NSLog(@"城市内检索发送成功");
        
    }
    
    else
        
    {
        
        NSLog(@"城市内检索发送失败");
        
    }
    
    
    
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
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"搜索地点";
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
    
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_headView addSubview:_rightBtn];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headView.mas_right).offset(-5);
        make.top.equalTo(_headView.mas_top).offset(24);
        make.width.equalTo(@(50));
        make.height.equalTo(@(26));
    }];
}

-(void)locationClick{
    NSLog(@"点击确定");
    [_mainTextField resignFirstResponder];
    if([lont isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"请选择地点"];
        return;
    }
    if([lat isEqualToString:@""]){
        [MBProgressHUD showSuccess:@"请选择地点"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:resName forKey:@"name"];
    [dic setObject:lont forKey:@"lont"];
    [dic setObject:lat forKey:@"lat"];
    [dic setObject:resCity forKey:@"city"];
    [dic setObject:resAddress forKey:@"adress"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"searchChange" object:dic];
    
    for (UIViewController *controller in self.navigationController.viewControllers) { if ([controller isKindOfClass:[CompleteInfoViewController class]]) { CompleteInfoViewController *A =(CompleteInfoViewController *)controller; [self.navigationController popToViewController:A animated:YES]; } }
    
//    if ([self.delegate respondsToSelector:@selector(confirmWithName:AndLongitude:AndLatitude:)]) {
//        [self.delegate confirmWithName:resName AndLongitude:lont AndLatitude:lat];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)BackClick{
    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createMain{
    
    _mainTextField = [[UITextField alloc]init];
    _mainTextField.placeholder = @"请输入地名";
    _mainTextField.font = [UIFont systemFontOfSize:13];
    _mainTextField.textColor = UIColorFromHex(0x727171);
    _mainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mainTextField.layer.masksToBounds = YES;
    _mainTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mainTextField.layer.borderWidth = 0.4;
    _mainTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _mainTextField.leftViewMode = UITextFieldViewModeAlways;
//    _mainTextField.keyboardType = UIKeyboardTypeDefault;
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
        make.top.equalTo(_mainTextField.mas_bottom).offset(HDAutoHeight(30));
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
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor grayColor];
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.textColor = [UIColor lightGrayColor];
    BMKPoiInfo *model = dataArr[indexPath.row];
    titleLabel.text = model.name;
    detailLabel.text = model.address;
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:detailLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(15);
        make.top.equalTo(cell.contentView.mas_top).offset(5);
        make.width.equalTo(@(APP_CONTENT_WIDTH*2/3));
        make.height.equalTo(@(30));
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.equalTo(@(APP_CONTENT_WIDTH*2/3));
        make.height.equalTo(@(20));
    }];
    
    if(selectItem == indexPath.row){
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对勾"]];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
        }];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectItem = (int)indexPath.row;
    [tableView reloadData];
    BMKPoiInfo *model = dataArr[indexPath.row];
//    _mapView.centerCoordinate = model.pt;
//    _annotation.coordinate = model.pt;
    
    //    resSel = model.pt;
    
    CLLocationCoordinate2D re = model.pt;
    
    //    lont = re.longitude;
    lat = [NSString stringWithFormat:@"%f",re.latitude];
    lont = [NSString stringWithFormat:@"%f",re.longitude];
    resName = model.name;
    
    resCity = model.city;
    resAddress = model.address;
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}

#pragma mark --------- poi 代理方法

-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode

{
    
    if(errorCode == BMK_SEARCH_NO_ERROR)
        
    {
        
        dataArr = poiResult.poiInfoList;
        [_stuffTableView reloadData];
        /***
         <这一步很重要，清空装载数据数组>
         ***/
//        self.addressArray = [NSMutableArray array];
//        
//        [self.addressArray removeAllObjects];
//        
//        
//        for (BMKPoiInfo *info in poiResult.poiInfoList) {
//            
//            _model = [[TJAddressModel alloc] init];
//            
//            _model.titleStr = info.name;
//            
//            _model.detailStr = info.address;
//            
//            [self.addressArray addObject:_model];
//            
//        }
//        
//        [self.addressTableView reloadData];
        
    }
//    NSLog(@"self.addressArray === %@",self.addressArray);
}



@end
