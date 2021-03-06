//
//  MapViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/19.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MapViewController.h"

#import "MyMapTableViewCell.h"
#import "MalLocateModel.h"



#import "MapSearchViewController.h"

#import "BBFlashCtntLabel.h"


@interface MapViewController ()<CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *rightBtn;


//百度地图
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *geocodesearch;
@property BOOL isGeoSearch;

@property (nonatomic,strong)BMKMapView *mapView;
@property (nonatomic,strong)BMKPointAnnotation *annotation;

@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UIButton *locationBtn;

@property(nonatomic,strong)BMKSuggestionSearch *searcher;

@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)UIButton *regionBtn;
@property(nonatomic,strong)UIButton *searchBtn;

@end

@implementation MapViewController{
    NSString *lat;
    NSString *lont;
    
    NSArray *dataArr;
    
    int selectItem;
    CLLocationCoordinate2D region;
    
    NSString *resName;
//    CLLocationCoordinate2D resSel;
    NSString *citiCode;
    
    NSString *resCity;
    
    NSString *resAddress;
    
    BMKReverseGeoCodeResult *nowPosiRes;
    
    float height;
    
    NSString *selectAdd;
    
    NSString *addResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOPen = YES;
    }else{
        [self showAlert];
    }
    
    
    addResult = @"";
    selectAdd = @"";
    citiCode = @"-1";
    // Do any additional setup after loading the view.
    resName = @"";
    lat = @"";
    lont = @"";
    selectItem = -1;
    dataArr = [NSArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTitleAndBackBtn];
    
    _mapView = [[BMKMapView alloc]init];
//    self.view = _mapView;
    
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.headView.mas_bottom).offset(50);
        make.height.equalTo(@(APP_CONTENT_HEIGHT/3));
    }];
    
    //百度地图
    //启动LocationService
    _locService = [[BMKLocationService alloc]init];//定位功能的初始化
    _locService.delegate = self;//设置代理位self
    [_locService startUserLocationService];//启动定位服务
    
//    [self createBottom];
    
    [self creatyRestView];
    [self setKayboard];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchChange:) name:@"searchChange" object:nil];
    
}

-(BOOL)isSystemVersioniOS8 {
    //check systemVerson of device
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}

- (void)showAlert
{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"当前未开启定位功能" message:@"是否前往设置？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([self isSystemVersioniOS8]){
            //跳入当前App设置界面,
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else{
            //适配iOS7 ,跳入系统设置界面
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:General&path=Reset"]];
        }
    }];
    [alertController addAction:maleAction];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertController addAction:femaleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)searchChange:(NSNotification *)noti{
    NSDictionary *dic = (NSDictionary *)[noti object];
    
    NSString *lat = dic[@"lat"];
    NSString *lont = dic[@"lont"];
   
    
    MalLocateModel *model = dic[@"sel"];
    
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        
        [self reverseGeoCodeWithLatitude:lat withLongitude:lont];
        
        dispatch_after(2, dispatch_get_main_queue(), ^{
            _mapView.centerCoordinate = model.loc;
            _annotation.coordinate = model.loc;
        });
        
    });
    
    
    
    
    
    selectItem = 100;
    selectAdd = dic[@"adress"];
    
    
    NSLog(@"%@  %@  %@", dic[@"name"],lat,lont);
    
}


-(void)setKayboard{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
    [_table layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
       
        _table.y = SCREEN_HEIGHT - height-_table.height;
        
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_table layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        
        _table.y = SCREEN_HEIGHT - _table.height;
        
    }];
    
}


-(void)creatyRestView{
    _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regionBtn setImage:[UIImage imageNamed:@"回原位"] forState:UIControlStateNormal];
    _regionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_regionBtn addTarget:self action:@selector(reginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regionBtn];
    [_regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setImage:[UIImage imageNamed:@"地址框"] forState:UIControlStateNormal];
    _searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(_regionBtn.mas_left).offset(-5);
        make.centerY.equalTo(_regionBtn.mas_centerY);
        make.height.equalTo(@(40));
    }];

    
}
-(void)searchClick{
    NSLog(@"调到搜索页面");
    int re = [citiCode intValue];
    if(re<0){
        [MBProgressHUD showSuccess:@"加载数据中，请重试"];
        return;
    }
    MapSearchViewController *con = [[MapSearchViewController alloc]init];
    con.city = citiCode;
    [self.navigationController pushViewController:con animated:YES];
    
//    [MBProgressHUD showSuccess:@"敬请期待"];
}
-(void)reginClick{
    
//    _annotation.coordinate = region;
    _mapView.centerCoordinate = region;
    _annotation.coordinate = region;
    
    NSString *latitude = [NSString stringWithFormat:@"%f",region.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",region.longitude];
    [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
    

    
}

-(void)SearchWithCLLocationCoordinate2D:(CLLocationCoordinate2D)locate{
//    _searcher =[[BMKSuggestionSearch alloc]init];
//    _searcher.delegate = self;
//    //发起检索
//    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc]init];
////    option.pageIndex = 1;
////    option.pageCapacity = 10;
////    
////    option.location = locate;
//    option.cityname = @"北京";
//    option.keyword = @"中关村";
//    BOOL flag = [_searcher suggestionSearch:option];
//    
//    if(flag)
//    {
//        NSLog(@"周边检索发送成功");
//    }
//    else
//    {
//        NSLog(@"周边检索发送失败");
//    }
    
    BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = @"海淀区上地10街10号";
    BOOL flag = [searcher geoCode:geoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _mapView.centerCoordinate = result.location;
        NSLog(@"%f",result.location.latitude);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}



-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"农场位置";
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
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_headView addSubview:_rightBtn];
    
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
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headView.mas_right).offset(-5);
        make.top.equalTo(_headView.mas_top).offset(24);
        make.width.equalTo(@(50));
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


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - BMK_LocationDelegate 百度地图
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"地图定位失败======%@",error);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    
    //从manager获取左边
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    //存储经纬度
//    [self.userLocationInfoModel SaveLocationCoordinate2D:coordinate];
    
    if ((userLocation.location.coordinate.latitude != 0 || userLocation.location.coordinate.longitude != 0))
    {
        
        
        //发送反编码请求
        //[self sendBMKReverseGeoCodeOptionRequest];
        
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
        
    }else{
        NSLog(@"位置为空");
    }
    
    //关闭坐标更新
    [self.locService stopUserLocationService];
}

//地图定位
- (BMKLocationService *)locService
{
    if (!_locService)
    {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}

//检索对象
- (BMKGeoCodeSearch *)geocodesearch
{
    if (!_geocodesearch)
    {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;
}

#pragma mark ----反向地理编码
- (void)reverseGeoCodeWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude
{
    
    //发起反向地理编码检索
//    lat = latitude;
//    lont = longitude;
    
    CLLocationCoordinate2D coor;
    coor.latitude = [latitude doubleValue];
    coor.longitude = [longitude doubleValue];
    
       if(_annotation == nil){
           
        region = coor;
        _mapView.centerCoordinate = coor;
        _mapView.zoomLevel = 20;
        _annotation = [[BMKPointAnnotation alloc]init];
        _annotation.coordinate = coor;
        [_mapView addAnnotation:_annotation];
    }
//    [self SearchWithCLLocationCoordinate2D:coor];

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coor;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];;
    if (flag)
    {
        NSLog(@"反地理编码成功");//可注释
    }
    else
    {
        NSLog(@"反地理编码失败");//可注释
    }
}

//发送反编码请求
- (void)sendBMKReverseGeoCodeOptionRequest{
    
    self.isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};//初始化
    if (_locService.userLocation.location.coordinate.longitude!= 0
        && _locService.userLocation.location.coordinate.latitude!= 0) {
        //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
        pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude,
            _locService.userLocation.location.coordinate.longitude};
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = pt;//设置反编码的店为pt
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


//发送成功,百度将会返回东西给你
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                          result:(BMKReverseGeoCodeResult *)result
                       errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        citiCode = result.cityCode;
        
        nowPosiRes = result;
        
        if(_table !=nil){
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray *arr = [NSArray arrayWithObject:index];
            [_table reloadRowsAtIndexPaths:arr withRowAnimation:YES];
        }
        
//        BMKAddressComponent *detail = result.addressDetail;
        
        NSString *address1 = result.address; // result.addressDetail ///层次化地址信息
        NSLog(@"我的位置在 %@",address1);
//        _annotation.title = address1;
        _locationLabel.text = address1;
//        BMKPoiInfo
        
        //保存位置信息到模型
//        [self.userLocationInfoModel saveLocationInfoWithBMKReverseGeoCodeResult:result];
        
        //进行缓存处理，上传到服务器等操作
        
        
        dataArr = result.poiList;
        
        
        if(_table == nil){
            
            _table = [[UITableView alloc]init];
            //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
            _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//            _table.allowsSelection = NO;
            _table.dataSource = self;
            _table.delegate = self;
            //    _plantTableView.showsVerticalScrollIndicator = NO;
            _table.backgroundColor = [UIColor whiteColor];
            //    _plantTableView.frame = self.view.frame;
            _table.showsVerticalScrollIndicator = NO;
            
            [self.view addSubview:_table];
            [_table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
                make.right.equalTo(self.view.mas_right);
                make.top.equalTo(self.mapView.mas_bottom).offset(5);
            }];

            
        }else{
            selectItem = -1;
            [_table reloadData];
            [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            
            
        }
        
        
        
        
        
    }
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count+1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(indexPath.row == 0){
        
        NSString *iden = @"identify";
        
        MyMapTableViewCell *neCell = [tableView dequeueReusableCellWithIdentifier:iden];
        if(neCell == nil){
            neCell = [[MyMapTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            neCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        neCell.res = nowPosiRes;
        
        if(selectItem != -1){
            neCell.posiTextView.text = selectAdd;
        }
        addResult = neCell.posiTextView.text;
        
        neCell.addressBlock = ^(NSString *address) {
            addResult = address;
        };
//        cell.textLabel.text = @"将要开发的功能";
        
        return neCell;
    }else{
        
        NSString *ide = @"identyfy233";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
        if(1){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
            
            BBFlashCtntLabel *titleLabel = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 30)];
            titleLabel.speed = -1;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor grayColor];
            BBFlashCtntLabel *detailLabel = [[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH-39, 20)];
            detailLabel.speed = -1;
            detailLabel.font = [UIFont systemFontOfSize:12];
            detailLabel.textColor = [UIColor lightGrayColor];
            BMKPoiInfo *model = dataArr[indexPath.row-1];
            titleLabel.text = model.name;
            detailLabel.text = model.address;
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:detailLabel];
            
            
            
            
//            if(selectItem == indexPath.row){
//                UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对勾"]];
//                imgV.contentMode = UIViewContentModeScaleAspectFit;
//                [cell.contentView addSubview:imgV];
//
//                [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(cell.contentView.mas_centerY);
//                    make.right.equalTo(cell.contentView.mas_right).offset(-10);
//                    make.width.equalTo(@(30));
//                    make.height.equalTo(@(30));
//                }];
//
//            }
            
        }
        
//        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        
        return cell;

        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        
        NSString *iden = @"identify";
        
        MyMapTableViewCell *neCell = [tableView dequeueReusableCellWithIdentifier:iden];
        if(neCell == nil){
            neCell = [[MyMapTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            neCell.selectionStyle = UITableViewCellSelectionStyleNone;
            neCell.res = nowPosiRes;
        }
        
        
        
        return [neCell needReturnHeight];
    }else{
        return 60;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return;
    }
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [tableView setContentOffset:CGPointMake(0,0) animated:YES];
    
//    if(_table !=nil){
//        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//        NSArray *arr = [NSArray arrayWithObject:index];
//        [_table reloadRowsAtIndexPaths:arr withRowAnimation:YES];
//    }
    
    selectItem = (int)indexPath.row;
//    [tableView reloadData];
    BMKPoiInfo *model = dataArr[indexPath.row-1];
    
    selectAdd = model.address;
    
     _mapView.centerCoordinate = model.pt;
    _annotation.coordinate = model.pt;
    
//    resSel = model.pt;
    
    CLLocationCoordinate2D re = model.pt;
    
//    lont = re.longitude;
    lat = [NSString stringWithFormat:@"%f",re.latitude];
    lont = [NSString stringWithFormat:@"%f",re.longitude];
    resName = model.name;
    
    resCity = model.city;
    
    resAddress = model.address;
    
    [self reverseGeoCodeWithLatitude:lat withLongitude:lont];
    
}


















- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSLog(@"aaa");
    lont = @"";
    lat = @"";
    resName = @"";
    _locationLabel.text = @"检索中...";
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您点击了地图空白处(blank click).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    _annotation.coordinate = coordinate;
    
    NSString *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];

//    [_mapView addAnnotation:_annotation];
    
}
//
//- (void)addPointAnnotation
//{
//    pointAnnotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor（使用上面获取的）;
//    coor.latitude = 上面获取的;
//    coor.longitude = 上面获取的;
//    pointAnnotation.coordinate = coor;
//    pointAnnotation.title = @"test";
//    pointAnnotation.subtitle = @"此Annotation可拖拽!";
//    [_mapView addAnnotation:pointAnnotation];
//    [pointAnnotation release];
//}

-(void)createBottom{
    _locationLabel = [[UILabel alloc]init];
    _locationLabel.text = @"检索中...";
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.layer.masksToBounds = YES;
    _locationLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _locationLabel.layer.borderWidth = 1;
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.layer.cornerRadius = 6;
    _locationLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_locationLabel];
    
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
//    _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(APP_CONTENT_WIDTH/5,
//                                                           CGRectGetMaxY(_imaVerificationVLinePassWord.frame)+50,
//                                                           APP_CONTENT_WIDTH*3/5,
//                                                           38)];
    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _btnLogin.backgroundColor = [UIColor lightGrayColor];
    _locationBtn.layer.cornerRadius = 18;
    [_locationBtn setTitle:@"确定" forState:UIControlStateNormal];
    _locationBtn.backgroundColor = UIColorFromHex(0x3aa566);
    _locationBtn.layer.shadowColor = UIColorFromHex(0x3fb36f).CGColor;
    _locationBtn.layer.shadowOpacity = 0.3f;
    _locationBtn.layer.shadowRadius =18;
    _locationBtn.layer.shadowOffset = CGSizeMake(5,5);
    
    [self.view addSubview:_locationBtn];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.mapView.mas_bottom).offset(20);
        make.height.equalTo(@(40));
        make.width.equalTo(@(200));
    }];
    [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.equalTo(@(38));
        make.width.equalTo(@(APP_CONTENT_WIDTH*3/5));
    }];
    
}

-(void)locationClick{
    NSLog(@"点击确定");
    
//    if([lont isEqualToString:@""]){
//        [MBProgressHUD showSuccess:@"请选择地点"];
//        return;
//    }
//    if([lat isEqualToString:@""]){
//        [MBProgressHUD showSuccess:@"请选择地点"];
//        return;
//    }
//    UIAlertControllerStyle
//    UIAlertControllerStyle
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"地址将以下方内容为准,是否确定?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([self.delegate respondsToSelector:@selector(confirmWithName:AndLongitude:AndLatitude:AndCity: AndAddress:)]) {
//            [self.delegate confirmWithName:resName AndLongitude:lont AndLatitude:lat AndCity:resCity AndAddress:resAddress];
//        }
        
        if([self.delegate respondsToSelector:@selector(confirmWithobj:AndName:)]){
            [self.delegate confirmWithobj:nowPosiRes AndName:addResult];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:confirmAct];
    [self presentViewController:alertVC animated:YES completion:nil];
    
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
