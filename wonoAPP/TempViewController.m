//
//  TempViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "TempViewController.h"
#import "TempTableViewCell.h"
#import "MoreTempViewController.h"

#import "TempModel.h"

#import "SetTempViewController.h"
#import "TempCViewController.h"

//#import "LoadingView.h"

//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#define BMK_KEY @"kClOFMdxGkzAgIr6MEfGF8cgGWMjqx02"//百度地图的key

@interface TempViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIImageView *posiImageView;

@property (nonatomic,strong) UILabel *posiLabel;
@property (nonatomic,strong) UILabel *posiContLabel;
@property (nonatomic,strong) UILabel *tempLabel;
@property (nonatomic,strong) UILabel *weatherLabel;
@property (nonatomic,strong) UILabel *qualityLabel;

@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) UIButton *moreImgBtn;

@property (nonatomic,strong) UILabel *tempControlLabel;
@property (nonatomic,strong) UIButton *setTempBtn;
@property (nonatomic,strong) UIButton *setTempImgBtn;

@property (nonatomic,strong) UITableView *contentTabel;

//百度地图
@property (nonatomic, strong)BMKLocationService *locService;
@property (nonatomic, strong)BMKGeoCodeSearch *geocodesearch;
@property BOOL isGeoSearch;

@property (nonatomic, strong)UIActivityIndicatorView *indiView;

@property (nonatomic,strong) UIButton *hubBtn;

@end

@implementation TempViewController{
    CLLocationCoordinate2D needLocate;
    int loadMark;
    TempModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[TempModel alloc]init];
    // Do any additional setup after loading the view.
    loadMark = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreateTitleLabelWithText:@"WONO让数据驱动农业"];
    [self createHead];
    [self creatNextHead];
    [self createTabel];
    
    [_headView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    
//    [self createIndicator];
//    [self getLocate];
    
    
}


-(void)createHubBtn{
    _hubBtn = [[UIButton alloc]init];
    _hubBtn.backgroundColor = [UIColor clearColor];
    [_hubBtn addTarget:self action:@selector(moreTempClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hubBtn];
    [_hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left);
        make.right.equalTo(_headView.mas_right);
        make.top.equalTo(_headView.mas_top);
        make.bottom.equalTo(_headView.mas_bottom);
    }];
}

-(void)createIndicator{

    
    [MBProgressHUD showMessage:@"加载中" toView:_headView];
}

-(void)getLocate{
    
    if(appDelegate.LocatePermission == YES){
        _locService = [[BMKLocationService alloc]init];//定位功能的初始化
        _locService.delegate = self;//设置代理位self
        [_locService startUserLocationService];//启动定位服务
    }else{
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self getLocate];
        });

    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"我显示了");
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)createHead{
    _headView = [[UIView alloc]init];
    
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.height.equalTo(@(HDAutoHeight(150)));
    }];
    _headView.backgroundColor = [UIColor whiteColor];
    [_headView layoutIfNeeded];
    [self createRealHead];
}

-(void)createRealHead{
    
//    UIImage *image = [UIImage imageNamed:@"晴天图"];
//    image = [image TransformtoSize:_headView.size];
//    _headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"晴天图"]];
    
    _posiImageView = [[UIImageView alloc]init];
    _posiImageView.image = [UIImage imageNamed:@"1-温湿度-地点"];
    _posiImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_headView addSubview:_posiImageView];
    
    _posiLabel = [[UILabel alloc]init];
    _posiLabel.text = @"获取数据:";
    _posiLabel.font = [UIFont systemFontOfSize:14];
    _posiLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:_posiLabel];
    
    _posiContLabel = [[UILabel alloc]init];
    _posiContLabel.text = @"...";
    _posiContLabel.font = [UIFont systemFontOfSize:13];
    _posiContLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:_posiContLabel];
    
    _tempLabel = [[UILabel alloc]init];
    _tempLabel.text = @"...";
    _tempLabel.font = [UIFont systemFontOfSize:19];
    _tempLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:_tempLabel];
    
    _weatherLabel = [[UILabel alloc]init];
    _weatherLabel.text = @"...";
    _weatherLabel.font = [UIFont systemFontOfSize:14];
    _weatherLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:_weatherLabel];
    
    
    _qualityLabel = [[UILabel alloc]init];
    _qualityLabel.text = @"...";
    _qualityLabel.font = [UIFont systemFontOfSize:14];
    _qualityLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:_qualityLabel];
    
    [_posiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(HDAutoWidth(32));
        make.top.equalTo(_headView.mas_top).offset(HDAutoHeight(28));
        make.width.equalTo(@(HDAutoWidth(42)));
        make.height.equalTo(@(HDAutoHeight(45)));
    }];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
    CGSize size=[@"当前定位:" sizeWithAttributes:attrs];
    [_posiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_posiImageView.mas_centerY);
        make.left.equalTo(_posiImageView.mas_right).offset(HDAutoWidth(10));
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(HDAutoHeight(30)));
    }];
    [_posiContLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(HDAutoHeight(25)));
        make.left.equalTo(_posiLabel.mas_right).offset(HDAutoWidth(15));
        make.width.equalTo(@(HDAutoWidth(450)));
        make.bottom.equalTo(_posiLabel.mas_bottom);
    }];
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posiLabel.mas_left);
        make.top.equalTo(_posiLabel.mas_bottom).offset(HDAutoHeight(20));
        make.width.equalTo(@(HDAutoWidth(80)));
        make.bottom.equalTo(_headView.mas_bottom).offset(-HDAutoHeight(16));
    }];
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tempLabel.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(100)));
        make.left.equalTo(_tempLabel.mas_right);
        make.height.equalTo(@(HDAutoHeight(30)));
    }];
    [_qualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_weatherLabel.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(250)));
        make.left.equalTo(_weatherLabel.mas_right).offset(HDAutoHeight(10));
        make.height.equalTo(@(HDAutoHeight(30)));
    }];
    
    _moreBtn = [[UIButton alloc]init];
    [_moreBtn setTitle:@"更多天气" forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreBtn setBackgroundColor:[UIColor clearColor]];
    [_moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_moreBtn addTarget:self action:@selector(moreTempClick) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_moreBtn];
    _moreImgBtn = [[UIButton alloc]init];
    [_moreImgBtn setImage:[UIImage imageNamed:@"1-进入"] forState:UIControlStateNormal];
    [_moreImgBtn setBackgroundColor:[UIColor clearColor]];
//    [_moreImgBtn addTarget:self action:@selector(moreTempClick) forControlEvents:UIControlEventTouchUpInside];
    _moreImgBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_moreImgBtn];
    
    NSDictionary *attrs2 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]};
    CGSize size2=[@"更多天气" sizeWithAttributes:attrs2];
    
    
    [_moreImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_qualityLabel.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(40)));
        make.bottom.equalTo(_qualityLabel.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-HDAutoWidth(25));
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_qualityLabel.mas_centerY);
        make.width.equalTo(@(size2.width+HDAutoWidth(20)));
        make.right.equalTo(_moreImgBtn.mas_left);
        make.bottom.equalTo(_qualityLabel.mas_bottom);
    }];

}

-(void)moreTempClick{
    NSLog(@"点击更多天气");
    MoreTempViewController *Cont = [[MoreTempViewController alloc]init];
    Cont.model = model;
    [self.navigationController presentViewController:Cont animated:YES completion:nil];
    
    
}

-(void)creatNextHead{
    _tempControlLabel = [[UILabel alloc]init];
    _tempControlLabel.text = @"温·湿度监控";
    _tempControlLabel.backgroundColor = [UIColor clearColor];
    _tempControlLabel.font = [UIFont systemFontOfSize:13];
    _tempControlLabel.textColor = UIColorFromHex(0x9fa0a0);
    [self.view addSubview:_tempControlLabel];
    _setTempBtn = [[UIButton alloc]init];
    [_setTempBtn setTitle:@"设置预警值" forState:UIControlStateNormal];
    [_setTempBtn setTitleColor:UIColorFromHex(0x9fa0a0) forState:UIControlStateNormal];
    _setTempBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_setTempBtn addTarget:self action:@selector(setTempClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setTempBtn];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
    CGSize size=[@"设置预警值" sizeWithAttributes:attrs];
    _setTempImgBtn = [[UIButton alloc]init];
    [_setTempImgBtn setImage:[UIImage imageNamed:@"1-设置预警值"] forState:UIControlStateNormal];
    _setTempImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_setTempImgBtn addTarget:self action:@selector(setTempClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setTempImgBtn];
    
    [_tempControlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(20));
        make.top.equalTo(_headView.mas_bottom).mas_offset(HDAutoHeight(5));
        make.width.equalTo(@(HDAutoWidth(250)));
        make.height.equalTo(@(HDAutoHeight(55)));
    }];
    [_setTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_moreImgBtn.mas_right);
        make.width.equalTo(@(size.width));
        make.bottom.equalTo(_tempControlLabel.mas_bottom);
        make.height.equalTo(@(HDAutoHeight(50)));
    }];
    [_setTempImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_setTempBtn.mas_left);
        make.centerY.equalTo(_setTempBtn.mas_centerY);
        make.width.equalTo(@(HDAutoWidth(40)));
        make.height.equalTo(@(HDAutoWidth(40)));
    }];

    
}

-(void)setTempClick{
    NSLog(@"点击设置预警值");
    SetTempViewController *cont = [[SetTempViewController alloc]init];
    [self.navigationController pushViewController:cont animated:YES];
    
}

-(void)createTabel{
    _contentTabel = [[UITableView alloc]init];
    //    [_plantTableView registerClass:[PlantCell class] forHeaderFooterViewReuseIdentifier:@"plantCell"];
    _contentTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _wonoTableView.allowsSelection = NO;
    _contentTabel.dataSource = self;
    _contentTabel.delegate = self;
    //    _plantTableView.showsVerticalScrollIndicator = NO;
    _contentTabel.backgroundColor = [UIColor whiteColor];
//    _contentTabel.frame = self.view.frame;
    
    [self.view addSubview:_contentTabel];
    
    [_contentTabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_tempControlLabel.mas_bottom).offset(HDAutoHeight(8));
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
    }];
    
    //    _wonoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //    _wonoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    TempTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TempTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        [cell setLeftColor:[UIColor blueColor]];
    }
    //    [cell creatConView];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HDAutoHeight(270);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
    
    TempCViewController *tempC = [[TempCViewController alloc]init];
    
    tempC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tempC animated:YES];
    
    
    
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
    
    CLLocationCoordinate2D coor;
    coor.latitude = [latitude doubleValue];
    coor.longitude = [longitude doubleValue];
    
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
        NSString *address1 = result.address; // result.addressDetail ///层次化地址信息
        NSLog(@"我的位置在 %@",address1);
        
        _posiLabel.text = @"当前定位:";
        
        _posiContLabel.text = address1;
        
        needLocate = result.location;
        model.nowPosi = address1;
        model.Locate = needLocate;
        
        [self getTemp];
        [self getQuality];
        
        //保存位置信息到模型
//        [self.userLocationInfoModel saveLocationInfoWithBMKReverseGeoCodeResult:result];
        
        //进行缓存处理，上传到服务器等操作
    }
}



-(void)getTemp{
    
    NSString *appcode = TempCode;
    NSString *host = @"http://aliv8.data.moji.com";
    NSString *path = @"/whapi/json/aliweather/condition";
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
//    NSString *bodys = @"lat=39.91488908&lon=116.40387397&token=ff826c205f8f4a59701e64e9e64e01c4";
    NSString *bodys = [NSString stringWithFormat:@"lat=%f&lon=%f&token=ff826c205f8f4a59701e64e9e64e01c4",needLocate.latitude,needLocate.longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    [request addValue: @"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       NSLog(@"Response object: %@" , response);
//                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                                                       
                                                       // JSON格式转换成字典，IOS5中自带解析类NSJSONSerialization从response中解析出数据放到字典中
                                                       id obj = [NSJSONSerialization JSONObjectWithData:body options:0 error:NULL];
                                                       
                                                       NSDictionary *dict = obj[@"data"];
                                                       //打印应答中的body
//                                                       NSLog(@"Response body: %@" , bodyString);
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           loadMark++;
                                                           if(loadMark == 2){
                                                               UIImage *image = [UIImage imageNamed:@"晴天图"];
                                                               image = [image TransformtoSize:_headView.size];
                                                               _headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"晴天图"]];
                                                               [MBProgressHUD hideHUDForView:_headView];
                                                               [self createHubBtn];
                                                           }
                                                           NSDictionary *cond = dict[@"condition"];
                                                           NSString *nowClimate = cond[@"condition"];
                                                           _weatherLabel.text = nowClimate;
                                                           
                                                           NSString *now = cond[@"temp"];
                                                           
                                                           NSString *nowTemp = [NSString stringWithFormat:@"%@°",now];
                                                           
                                                           _tempLabel.text = nowTemp;
                                                           
                                                           model.nowTemp = nowTemp;
                                                           model.nowClimate = nowClimate;
                                                           model.windName = cond[@"windDir"];
                                                           model.windLevel = cond[@"windLevel"];
                                                           model.icon = cond[@"icon"];
                                                       });                                                       NSLog(@"解析");
                                                       
                                                       
                                                       
                                                   }];
    
    [task resume];
    
}


-(void)getQuality{
    NSString *appcode = TempCode;
    NSString *host = @"http://aliv8.data.moji.com";
    NSString *path = @"/whapi/json/aliweather/aqi";
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
//    NSString *bodys = @"lat=39.91488908&lon=116.40387397&token=6e9a127c311094245fc1b2aa6d0a54fd";
    NSString *bodys = [NSString stringWithFormat:@"lat=%f&lon=%f&token=6e9a127c311094245fc1b2aa6d0a54fd",needLocate.latitude,needLocate.longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    [request addValue: @"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       NSLog(@"Response object: %@" , response);
                                                       id obj = [NSJSONSerialization JSONObjectWithData:body options:0 error:NULL];
                                                       
                                                       NSDictionary *dict = obj[@"data"];
                                                       
                                                       NSDictionary *api = dict[@"aqi"];
                                                       
                                                       NSString *str = api[@"value"];
                                                       
                                                       int value = [str intValue];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           loadMark++;
                                                           if(loadMark == 2){
                                                               UIImage *image = [UIImage imageNamed:@"晴天图"];
                                                               image = [image TransformtoSize:_headView.size];
                                                               _headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"晴天图"]];
                                                               [self createHubBtn];
                                                               [MBProgressHUD hideHUDForView:_headView];
                                                              
                                                           }
                                                           if(value<=50){
                                                               _qualityLabel.text = @"空气质量:优";
                                                           }else if (value<=100){
                                                               _qualityLabel.text = @"空气质量:良";
                                                           }else if (value<=200){
                                                               _qualityLabel.text = @"空气质量:轻微污染";
                                                           }else if(value<=300){
                                                               _qualityLabel.text = @"空气质量:重度污染";
                                                           }else{
                                                               _qualityLabel.text = @"空气质量:重度污染";
                                                           }
                                                           model.tempQuality = _qualityLabel.text;
                                                           
                                                           
                                                           
                                                       });
                                                       
                                                       NSLog(@"解析");
                                                   }];
    
    [task resume];
}





@end
