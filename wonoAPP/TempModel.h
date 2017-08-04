//
//  TempModel.h
//  wonoAPP
//
//  Created by IF on 2017/7/25.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>
//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


@interface TempModel : NSObject

@property (nonatomic,strong) NSString *nowPosi;
@property (nonatomic,strong) NSString *nowTemp;

@property (nonatomic,strong) NSString *highTemp;
@property (nonatomic,strong) NSString *lowTemp;

@property (nonatomic,strong) NSString *nowClimate;

@property (nonatomic,strong) NSString *tempQuality;
@property (nonatomic,strong) NSString *windLevel;
@property (nonatomic,strong) NSString *windName;
@property (nonatomic) CLLocationCoordinate2D Locate;

@property (nonatomic,strong) NSString *icon;

@end
