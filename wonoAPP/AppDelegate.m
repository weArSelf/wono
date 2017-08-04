//
//  AppDelegate.m
//  wonoAPP
//
//  Created by IF on 2017/7/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "PlantControllViewController.h"
#import "StatisticsViewController.h"
#import "TempViewController.h"
#import "WonoCircleViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

#import "BaseNavViewController.h"

#define BMK_KEY @"SsZWbh9PGkXmhZReYQtbLBgFz06TBew8"//百度地图的key
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate ()<UIApplicationDelegate,BMKGeneralDelegate>

@property (nonatomic,strong)BaseTabBarController *base;

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate{
    bool loginMark;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    loginMark = false;
    self.LocatePermission = NO;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if(loginMark == false){
    
        self.base = [[BaseTabBarController alloc]init];
     
        self.window.rootViewController = self.base;
        
    }else{
    
        LoginViewController *login = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    //    self.window.rootViewController = base;
            
    }
    
//    //百度地图
//    _mapManager = [BMKMapManager new];
//    BOOL ret = [_mapManager start:BMK_KEY generalDelegate:nil];
//    if (!ret)
//    {
//        NSLog(@"百度地图启动失败");
//    }
//    else
//    {
//        NSLog(@"百度地图启动成功");
//    }
    [self setUpBaiMap];
    return YES;
}

-(void)setUpBaiMap {
    //百度地图
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BMK_KEY  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - 百度地图
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
//        self.isMapPermission = YES;
        self.LocatePermission = YES;
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
