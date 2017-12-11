//
//  MapViewController.h
//  wonoAPP
//
//  Created by IF on 2017/7/19.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@protocol MyLocationDelegate <NSObject>

//- (void)bannerImageClicked:(NSInteger)index ;
//- (void)confirmWithName:(NSString *)name AndLongitude:(NSString *)longitude AndLatitude:(NSString *)latitude;
//- (void)confirmWithName:(NSString *)name AndLongitude:(NSString *)longitude AndLatitude:(NSString *)latitude AndCity:(NSString *)city AndAddress:(NSString *)address;

-(void)confirmWithobj:(BMKReverseGeoCodeResult *)serRes AndName:(NSString *)name;

@end

@interface MapViewController : UIViewController

@property (nonatomic,weak) id<MyLocationDelegate> delegate;

@end
