//
//  SignInViewController.m
//  wonoAPP
//
//  Created by IF on 2017/11/15.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "SignInViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "SetDistanceViewController.h"


@interface SignInViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong) UIButton *hubBtn;

@property (nonatomic,strong) UILabel *setLabel;
@property (nonatomic,strong) UILabel *nowLabel;

@property (nonatomic,strong) UIButton *setBtn;

@property (nonatomic, strong) CLLocationManager* locationManager;

/** 地理编码 */
@property (nonatomic, strong) CLGeocoder *geoC;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTitleAndBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getLocate];
    [self createSetBtn];
}

-(void)creatTitleAndBackBtn{
    
    _headView = [[UIView alloc]init];
    _headView.backgroundColor = UIColorFromHex(0x3fb36f);
    _headView.alpha = 0.8;
    [self.view addSubview:_headView];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"沃农签到";
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

-(void)createSetBtn{
//    UIControlState
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn setTitle:@"设置初始点" forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _setBtn.titleLabel.font= [UIFont systemFontOfSize:16];
    _setBtn.layer.masksToBounds = YES;
    _setBtn.layer.cornerRadius = 5;
    _setBtn.layer.borderWidth = 1;
    _setBtn.layer.borderColor = MainColor.CGColor;
    
    _setBtn.frame = CGRectMake(20, 100, 200, 40);
    [self.view addSubview:_setBtn];
    
}
-(void)setClick{
    NSLog(@"点击设置初始点");
    SetDistanceViewController *setVC = [[SetDistanceViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)getLocate{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
    
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    // 反地理编码(经纬度---地址)
    [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            NSLog(@"%@",pl.name);
            NSLog(@"%@",pl.thoroughfare);
//            self.addressTV.text = pl.name;
//            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
//            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
        }else
        {
            NSLog(@"错误");
        }
    }];
    
    
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude:32.178722 longitude:119.508619];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:32.206340 longitude:119.425600];
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    
    NSLog(@"相距：%f",meters);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}


@end
