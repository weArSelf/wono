//
//  MoreTempViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/25.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MoreTempViewController.h"
//#import <JHChart/JHChartHeader.h>
#import <GLChart/GLChartData.h>
#import <GLChart/GLLineChart.h>
#import "ZXView.h"

static NSString *const kHeWeatherAPI   = @"https://api.heweather.com/x3/weather?cityid=CN101210106&key=162e571b6ea446dba9c99d6d4cbbdf18";

@interface MoreTempViewController ()


@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UIImageView *posiImageView;
@property (nonatomic,strong) UILabel *posiLabel;
@property (nonatomic,strong) UILabel *posiContLabel;

@property (nonatomic,strong) UILabel *nowTempLabel;
@property (nonatomic,strong) UILabel *tempLabel;
@property (nonatomic,strong) UILabel *qualityWindLabel;


@property (nonatomic, strong) NSURLRequest  *request;
@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) GLChartData   *chartData;
@property (nonatomic, strong) GLLineChart   *lineChart;

@property (nonatomic, strong) ZXView *zxView;

@end

@implementation MoreTempViewController{
    NSArray *tempArr;
    NSMutableArray *realDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBackImage];
    [self createBack];
    [self createPosition];
    [self createLabel];
    
    [self futureTemperRequest];
    
//    [self requestData];
}




//-(void)setModel:(TempModel *)model{
//
//    self.model = model;
//    
//}

-(void)createBackImage{
    _backImageView = [[UIImageView alloc]init];
    NSString *str = [NSString stringWithFormat:@"BW%@",self.model.icon];
    _backImageView.image = [UIImage imageNamed:str];
    _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
-(void)createBack{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_backBtn setBackgroundImage:[UIImage imageNamed:@"温湿度返回"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"温湿度返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-HDAutoHeight(60));
        make.width.equalTo(@(HDAutoWidth(120)));
        make.height.equalTo(@(HDAutoWidth(120)));
    }];
    UIButton *hubBtn = [[UIButton alloc]init];
    hubBtn.backgroundColor = [UIColor clearColor];
    [hubBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hubBtn];
    
    [hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backBtn.mas_left).offset(-HDAutoWidth(40));
        make.right.equalTo(_backBtn.mas_right).offset(HDAutoWidth(30));
        make.top.equalTo(_backBtn.mas_top).offset(-HDAutoHeight(20));
        make.bottom.equalTo(_backBtn.mas_bottom).offset(HDAutoHeight(20));;
    }];
    
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createPosition{
    _posiImageView = [[UIImageView alloc]init];
    _posiImageView.image = [UIImage imageNamed:@"1-温湿度-地点"];
    _posiImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_posiImageView];
    
    _posiLabel = [[UILabel alloc]init];
    _posiLabel.text = @"当前定位:";
    _posiLabel.font = [UIFont systemFontOfSize:14];
    _posiLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_posiLabel];
    
    _posiContLabel = [[UILabel alloc]init];
    _posiContLabel.text = self.model.nowPosi;
    _posiContLabel.font = [UIFont systemFontOfSize:13];
    _posiContLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_posiContLabel];
    
    
    [_posiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(HDAutoWidth(32));
        make.top.equalTo(self.view.mas_top).offset(HDAutoHeight(60));
        make.width.equalTo(@(HDAutoWidth(42)));
        make.height.equalTo(@(HDAutoHeight(45)));
    }];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
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

}

-(void)createLabel{
    _nowTempLabel = [[UILabel alloc]init];
    _nowTempLabel.text = self.model.nowTemp;
    _nowTempLabel.textColor = [UIColor whiteColor];
    _nowTempLabel.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:_nowTempLabel];
    _tempLabel = [[UILabel alloc]init];
    _tempLabel.text = @"";
    
    _tempLabel.textColor = [UIColor whiteColor];
    _tempLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_tempLabel];
    _qualityWindLabel = [[UILabel alloc]init];
    
    NSString *windStr = [NSString stringWithFormat:@"%@  %@级  %@",self.model.tempQuality,self.model.windLevel,self.model.windName];
    
    _qualityWindLabel.text = windStr;
    _qualityWindLabel.textColor = [UIColor whiteColor];
    _qualityWindLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_qualityWindLabel];
    [_nowTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posiLabel.mas_left);
        make.top.equalTo(_posiLabel.mas_bottom).offset(HDAutoHeight(32));
        make.width.equalTo(@(APP_CONTENT_WIDTH));
        make.height.equalTo(@(HDAutoHeight(64)));
    }];
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posiLabel.mas_left);
        make.top.equalTo(_nowTempLabel.mas_bottom).offset(HDAutoHeight(24));
        make.width.equalTo(@(APP_CONTENT_WIDTH));
        make.height.equalTo(@(HDAutoHeight(38)));
    }];
    [_qualityWindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posiLabel.mas_left);
        make.top.equalTo(_tempLabel.mas_bottom).offset(HDAutoHeight(24));
        make.width.equalTo(@(APP_CONTENT_WIDTH));
        make.height.equalTo(@(HDAutoHeight(38)));
    }];
    
}




#pragma mark - NSURLConnectionDataDelegate


- (void)loadData{
//    NSDictionary *data          = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
//    NSArray      *dailyForecast = data[@"HeWeather data service 3.0"][0][@"daily_forecast"];
    
    NSMutableArray *max  = [NSMutableArray array];
    NSMutableArray *min  = [NSMutableArray array];
    NSMutableArray *temp  = [NSMutableArray array];
    NSMutableArray *date = [NSMutableArray array];
    
    for (NSDictionary *item in tempArr) {
        if(max.count<=7){
        
            [max addObject:item[@"tempDay"]];
            [min addObject:item[@"tempNight"]];
    //        NSString *str = item[@"predictDate"];
    //        NSArray *newArr = [str componentsSeparatedByString:@" "];
    //        NSString *realStr = newArr[0];
            [date addObject:item[@"predictDate"]];
            [temp addObject:item[@"conditionIdDay"]];
        }
    }
    
    realDataArr = [NSMutableArray array];
    [realDataArr addObject:max];
    [realDataArr addObject:min];
    [realDataArr addObject:date];
    [realDataArr addObject:temp];
    
    float mincen = 100;
    for (int i=0; i<max.count; i++) {
        
        NSString *maxstr = max[0];
        NSString *minstr = min[0];
        
        int maxval = [maxstr intValue];
        int minval = [minstr intValue];
        
        float real = (float)(maxval + minval)/2;
        
        if(real <mincen){
            mincen = real;
        }
        
    }
    
    float res = 0;
    
    if (mincen < 15) {
        res = ((15-mincen)/15 )*HDAutoWidth(-90);
    }
    
    _zxView = [[ZXView alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width, 250)];
    _zxView.NedY = res;
    _zxView.dataArray = realDataArr;
    [self.view addSubview:_zxView];

    [_zxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(_backBtn.mas_top).offset(-HDAutoHeight(10));
        make.width.equalTo(@(self.view.width));
        make.height.equalTo(@(250));
    }];
//    _zxView.backgroundColor = [UIColor greenColor];
}

#pragma mark - private methods

- (void)requestData {
    
    
//    // 添加子类视图
//    [self.view addSubview:self.lineChart];
//    
//    self.chartData.visibleRangeMaxNum = 0;
//    self.chartData.isEnabledIndicator = YES;
//    //    self.chartData
//    
//    self.lineChart.backgroundColor = [UIColor clearColor];
//    [self.lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(@(HDAutoHeight(450)));
//        make.bottom.equalTo(_backBtn.mas_top).offset(-HDAutoHeight(100));
//    }];
    [self loadData];

}


- (GLChartData *)chartData {
    if (_chartData == nil) {
        _chartData = [[GLChartData alloc] init];
    }
    
    return _chartData;
}

- (GLLineChart *)lineChart {
    if (_lineChart == nil) {
        _lineChart = [[GLLineChart alloc] init];
        
//        _lineChart.frame = CGRectMake(0.0f, 10.0f, self.view.frame.size.width, 180.0f);
    }
    
    return _lineChart;
}

-(void)futureTemperRequest{
    NSString *appcode = TempCode;
    NSString *host = @"http://aliv8.data.moji.com";
    NSString *path = @"/whapi/json/aliweather/forecast15days";
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
//    NSString *bodys = @"lat=39.91488908&lon=116.40387397&token=7538f7246218bdbf795b329ab09cc524";
    CLLocationCoordinate2D loc = self.model.Locate;
    NSString *bodys = [NSString stringWithFormat:@"lat=%f&lon=%f&token=7538f7246218bdbf795b329ab09cc524",loc.latitude,loc.longitude];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    [request addValue: @"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       id obj = [NSJSONSerialization JSONObjectWithData:body options:0 error:NULL];
                                                       
                                                       NSDictionary *dict = obj[@"data"];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           tempArr = dict[@"forecast"];
                                                           NSDictionary *dic = tempArr[1];
                                                           NSString *tempDay = dic[@"tempDay"];
                                                           NSString *tempNight = dic[@"tempNight"];
                                                           
                                                           NSString *str = [NSString stringWithFormat:@"%@°/%@°  %@",tempNight,tempDay,self.model.nowClimate];
                                                           
                                                           _tempLabel.text = str;
                                                           
                                                           
                                                           [self requestData];
                                                           
                                                           
                                                       });                                                       NSLog(@"解析");
                                                       
                                                       
                                                       
                                                   }];
    
    
    
    [task resume];
}


@end
