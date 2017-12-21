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

#import "WonoCircleDetailViewController.h"
#import "WonoCircleViewController.h"


#define BMK_KEY @"kClOFMdxGkzAgIr6MEfGF8cgGWMjqx02"//百度地图的key
#define Statis_KEY @"18d240c73a"//百度统计key

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件



#import <GeTuiSdk.h>
#import <UserNotifications/UserNotifications.h>

//#import <UMMobClick/MobClick.h>
#import "WonoWebMessageViewController.h"
#import "UIDevice+DeviceModel.h"

//#import <BaiduMobStat/BaiduMobStat.h>

@interface AppDelegate ()<UIApplicationDelegate,BMKGeneralDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

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
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"loginMark"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *mark = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginMark"];
    NSLog(@"%@", mark);
//    if(mark == nil){
//        mark = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginMark"];
//    }
//    if(mark == nil){
//        mark = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginMark"];
//    }
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    if([mark isEqualToString:@"login"]){
    
        self.base = [[BaseTabBarController alloc]init];
     
        self.window.rootViewController = self.base;
        
    }else{
    
        LoginViewController *login = [[LoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        nav.navigationBar.hidden = YES;
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
    
#if !TARGET_OS_SIMULATOR
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册APNS
    [self registerRemoteNotification];
    
    [GeTuiSdk clearAllNotificationForNotificationBar];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
#endif

    
    
    
    
//    [[BaiduMobStat defaultStat] startWithAppId:Statis_KEY];
    
//        UMConfigInstance.appKey = @"599fdc4c4544cb433a0009e8";
//        UMConfigInstance.channelId = @"App Store";
    
//    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    
//        [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
    [self setUpBaiMap];
    
//    NSString *dev =  UIDevice.currentDevice.localizedModel;
//    NSLog(@"%@",dev);
    
//    UIDevice
//    NSString *phoneModel = [[UIDevice currentDevice] deviceModel];
    
    
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    
    if (sysVersion >= 10.0f) {
        // 动态添加快捷启动
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCloud];
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"fenxiang" localizedTitle:@"温湿度" localizedSubtitle:nil icon:icon userInfo:nil];
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
        UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"zhongzhi" localizedTitle:@"种植管理" localizedSubtitle:nil icon:icon2 userInfo:nil];
        UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
        UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"tongji" localizedTitle:@"数据统计" localizedSubtitle:nil icon:icon3 userInfo:nil];
        UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeMessage];
        UIApplicationShortcutItem *item4 = [[UIApplicationShortcutItem alloc] initWithType:@"zhidao" localizedTitle:@"农知道" localizedSubtitle:nil icon:icon4 userInfo:nil];
        UIApplicationShortcutIcon *icon5 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome];
        UIApplicationShortcutItem *item5 = [[UIApplicationShortcutItem alloc] initWithType:@"wode" localizedTitle:@"我的" localizedSubtitle:nil icon:icon5 userInfo:nil];
        [[UIApplication sharedApplication] setShortcutItems:@[item,item2,item3,item4,item5]];
    }
    
    
    
//    [self requsetNeed];
    
    return YES;
}


/** 注册APNS */
- (void)registerRemoteNotification {
    //    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    //    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}


-(void)setUpBaiMap {
    //百度地图
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
//        //由于IOS8中定位的授权机制改变 需要进行手动授权
//        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
//        //获取授权认证
//        [locationManager requestAlwaysAuthorization];
////        [locationManager requestWhenInUseAuthorization];
////        [locationManager startUpdatingLocation];
//    }
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
    UIViewController *currentVC = [self currentViewController];
    if([currentVC isKindOfClass:[WonoCircleViewController class]]){
        WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
        [noVC requestCount];
    }else{
        [self requestCount];
    }
    [GeTuiSdk clearAllNotificationForNotificationBar];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    //保存deviceToken登录时上传
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DEVICETOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0){
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}
/** 注: iOS7.0 以后支持APP后台刷新数据，会回调 performFetchWithCompletionHandler 接口，此处为保证个推数据刷新需调用[GeTuiSdk resume] 接口恢复个推SDK 运行刷新数据 */
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}
/** 处理APNs展示点击，统计有效用户点击数 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    
    if(state == UIApplicationStateBackground){
        return;
    }
    
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    if(payloadMsg == nil||[payloadMsg isEqual:[NSNull null]]){
        return;
    }
    
    NSData* xmlData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:xmlData options:0 error:NULL];
    
    NSDictionary *dic = obj;
    NSString *type;
    @try {
          type = [NSString stringWithFormat:@"%@",dic[@"type"]];
        
    } @catch (NSException *exception) {
        return;
        
    } @finally {
        
    }
   
    
//    2222222
//    [MBProgressHUD showLongSuccess:type toView:nil];
//    [self requsetNeed];
    if([type isEqualToString:@"1000"]){
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self alertWithTitle:dic[@"content"]];
            [self requsetNeed];
            UIViewController *currentVC = [self currentViewController];
            if([currentVC isKindOfClass:[WonoCircleViewController class]]){
                WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
                [noVC requestCount];
            }else{
                [self requestCount];
            }
        });
        
    }
    if([type isEqualToString:@"1001"]){
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            UIViewController *nowVC = [self currentViewController];
            
            if([nowVC isKindOfClass:[UIAlertController class]]){
                [nowVC dismissViewControllerAnimated:YES completion:nil];
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    UIViewController *nowVC = [self currentViewController];
                    
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"aaa");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            NSString *msgID = [NSString stringWithFormat:@"%@",dic[@"msg_id"]];
                            [self changeStateWithMsgID:msgID];
                            
                            
                            WonoCircleDetailViewController *detailVc = [[WonoCircleDetailViewController alloc]init];
                            detailVc.qid = dic[@"qid"];
                            detailVc.hidesBottomBarWhenPushed = YES;
                            [nowVC.navigationController pushViewController:detailVc animated:YES];
                        });
                        
                    }];
                    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"bbb");
                    }];
                    [alertVC addAction:cancelAct];
                    [alertVC addAction:confirmAct];
                    
                    [nowVC presentViewController:alertVC animated:YES completion:nil];
                    
                });
                
            }else{
                
                nowVC = [self currentViewController];
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"aaa");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *msgID = [NSString stringWithFormat:@"%@",dic[@"msg_id"]];
                        [self changeStateWithMsgID:msgID];
                        WonoCircleDetailViewController *detailVc = [[WonoCircleDetailViewController alloc]init];
                        detailVc.qid = dic[@"qid"];
                        detailVc.hidesBottomBarWhenPushed = YES;
                        [nowVC.navigationController pushViewController:detailVc animated:YES];
                    });
                    
                }];
                UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"bbb");
                }];
                [alertVC addAction:cancelAct];
                [alertVC addAction:confirmAct];
                
                [nowVC presentViewController:alertVC animated:YES completion:nil];
            }

        });
        
    }
    
    
    
    if([type isEqualToString:@"1003"]){
        UIViewController *currentVC = [self currentViewController];
        if([currentVC isKindOfClass:[WonoCircleViewController class]]){
            WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
            [noVC requestCount];
        }else{
            [self requestCount];
        }
        
        UIViewController *nowVC = [self currentViewController];

        if([nowVC isKindOfClass:[UIAlertController class]]){
            [nowVC dismissViewControllerAnimated:YES completion:nil];

            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));

            dispatch_after(delayTime, dispatch_get_main_queue(), ^{

                UIViewController *nowVC = [self currentViewController];

                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"aaa");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *msgID = [NSString stringWithFormat:@"%@",dic[@"msg_id"]];
                        [self changeStateWithMsgID:msgID];
                        WonoWebMessageViewController *detailVc = [[WonoWebMessageViewController alloc]init];
                        detailVc.needStr = dic[@"detail"];
                        detailVc.hidesBottomBarWhenPushed = YES;
                        [nowVC.navigationController pushViewController:detailVc animated:YES];
                    });

                }];
                UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"bbb");

                }];
                [alertVC addAction:cancelAct];
                [alertVC addAction:confirmAct];

                [nowVC presentViewController:alertVC animated:YES completion:nil];

            });

        }else{

            nowVC = [self currentViewController];

            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"aaa");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *msgID = [NSString stringWithFormat:@"%@",dic[@"msg_id"]];
                    [self changeStateWithMsgID:msgID];
                    WonoWebMessageViewController *detailVc = [[WonoWebMessageViewController alloc]init];
                    detailVc.needStr = dic[@"detail"];
                    detailVc.hidesBottomBarWhenPushed = YES;
                    [nowVC.navigationController pushViewController:detailVc animated:YES];
                });

            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"bbb");
            }];
            [alertVC addAction:cancelAct];
            [alertVC addAction:confirmAct];

            [nowVC presentViewController:alertVC animated:YES completion:nil];
        }

    }
    
    
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)requsetNeed{
    
//    [MBProgressHUD showMessage:@"加载中"];
    //    [MBProgressHUD showLongSuccess:@"加载用户数据..." toView:self.view];
    [[InterfaceSingleton shareInstance].interfaceModel getUserInfoWithCallBack:^(int state, id data, NSString *msg) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fid"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pengID"];
        
        
//        [MBProgressHUD hideHUD];
        if(state == 2000){
            
            NSLog(@"成功");
            
            NSDictionary *dic = data;
            
            NSString *fid = dic[@"fid"];
            NSString *pengID = dic[@"greenHouse"];
            NSString *type = dic[@"type"];
            
            [[NSUserDefaults standardUserDefaults] setObject:fid forKey:@"fid"];
            [[NSUserDefaults standardUserDefaults] setObject:pengID forKey:@"pengID"];
            [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"userType"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WonoStateChange" object:nil];
        }
        
        
    }];
    
}




/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"CLIENTID"];
    
    
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @"透传消息"];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
//    [self requsetNeed];
    if(offLine == NO){
        
        
        
        id obj = [NSJSONSerialization JSONObjectWithData:payloadData options:0 error:NULL];
        
        NSDictionary *dic =obj;
        
        NSString *type;
        @try {
            type = [NSString stringWithFormat:@"%@",dic[@"type"]];
            
        } @catch (NSException *exception) {
            return;
        } @finally {
            
        }
        
        if(type == nil||[type isEqual:[NSNull null]]){
            return;
        }
        
        NSString *pid = [NSString stringWithFormat:@"%@",dic[@"pid"]];
        
        NSLog(@"%@",pid);
        
        if([type isEqualToString:@"1000"]){
                [self alertWithTitle:dic[@"content"]];
                [self requsetNeed];
            UIViewController *currentVC = [self currentViewController];
            if([currentVC isKindOfClass:[WonoCircleViewController class]]){
                WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
                [noVC requestCount];
            }else{
                [self requestCount];
            }
          
        }
        
        if([type isEqualToString:@"1001"]){
            
            UIViewController *currentVC = [self currentViewController];
            if([currentVC isKindOfClass:[WonoCircleViewController class]]){
                WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
                [noVC requestCount];
            }else{
                [self requestCount];
            }
            
            
            
        }
        
        if([type isEqualToString:@"1003"]){
            UIViewController *currentVC = [self currentViewController];
            if([currentVC isKindOfClass:[WonoCircleViewController class]]){
                WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
                [noVC requestCount];
            }else{
                [self requestCount];
            }
            
            UIViewController *nowVC = [self currentViewController];
            
            if([nowVC isKindOfClass:[UIAlertController class]]){
                [nowVC dismissViewControllerAnimated:YES completion:nil];
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    UIViewController *nowVC = [self currentViewController];
                    
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"aaa");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *msgID = [NSString stringWithFormat:@"%@",dic[@"msg_id"]];
                            [self changeStateWithMsgID:msgID];
                            WonoWebMessageViewController *detailVc = [[WonoWebMessageViewController alloc]init];
                            detailVc.needStr = dic[@"detail"];
                            detailVc.hidesBottomBarWhenPushed = YES;
                            [nowVC.navigationController pushViewController:detailVc animated:YES];
                        });
                        
                    }];
                    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"bbb");
                        
                    }];
                    [alertVC addAction:cancelAct];
                    [alertVC addAction:confirmAct];
                    
                    [nowVC presentViewController:alertVC animated:YES completion:nil];
                    
                });
                
            }else{
                
                nowVC = [self currentViewController];
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"aaa");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *msgID = [NSString stringWithFormat:@"%@",dic[@"msg_id"]];
                        [self changeStateWithMsgID:msgID];
                        WonoWebMessageViewController *detailVc = [[WonoWebMessageViewController alloc]init];
                        detailVc.needStr = dic[@"detail"];
                        detailVc.hidesBottomBarWhenPushed = YES;
                        [nowVC.navigationController pushViewController:detailVc animated:YES];
                    });
                    
                }];
                UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"bbb");
                }];
                [alertVC addAction:cancelAct];
                [alertVC addAction:confirmAct];
                
                [nowVC presentViewController:alertVC animated:YES completion:nil];
            }
            
        }
        
        
    }
    
        
    id obj = [NSJSONSerialization JSONObjectWithData:payloadData options:0 error:NULL];
    
    
    NSDictionary *dic =obj;
    
    NSString *type;
    @try {
        type = [NSString stringWithFormat:@"%@",dic[@"type"]];
        
    } @catch (NSException *exception) {
        return;
    } @finally {
        
    }
    if(type == nil||[type isEqual:[NSNull null]]){
        return;
    }
    NSString *pid = [NSString stringWithFormat:@"%@",dic[@"pid"]];
    
    NSLog(@"%@",pid);
    
    if([type isEqualToString:@"1002"]){
        UIViewController *nowVC = [self currentViewController];
        
        if([nowVC isKindOfClass:[UIAlertController class]]){
            [nowVC dismissViewControllerAnimated:YES completion:nil];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                UIViewController *nowVC = [self currentViewController];
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
               
//                [alertVC addAction:cancelAct];
                [alertVC addAction:confirmAct];
                
                [nowVC presentViewController:alertVC animated:YES completion:nil];
                
            });
            
        }else{
            
            nowVC = [self currentViewController];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
//            [alertVC addAction:cancelAct];
            [alertVC addAction:confirmAct];
            
            [nowVC presentViewController:alertVC animated:YES completion:nil];
        }
        
    }
    
    

    
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    
    
    
    
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

////  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//
//
//
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//
//    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
//    NSData* xmlData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
//    id obj = [NSJSONSerialization JSONObjectWithData:xmlData options:0 error:NULL];
//
//    NSDictionary *dic = obj;
//
//    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
//
////    [MBProgressHUD showLongSuccess:type toView:nil];
//
//
//    if([type isEqualToString:@"1000"]){
//
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
//
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [self alertWithTitle:dic[@"content"]];
//            [self requsetNeed];
//
//        });
//
//    }
//
//
//    if([type isEqualToString:@"1001"]){
//
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
//
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//            UIViewController *nowVC = [self currentViewController];
//
//            if([nowVC isKindOfClass:[UIAlertController class]]){
//                [nowVC dismissViewControllerAnimated:YES completion:nil];
//
//                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//
//                    UIViewController *nowVC = [self currentViewController];
//
//                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
//
//                    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSLog(@"aaa");
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            WonoCircleDetailViewController *detailVc = [[WonoCircleDetailViewController alloc]init];
//                            detailVc.qid = dic[@"qid"];
//                            detailVc.hidesBottomBarWhenPushed = YES;
//                            [nowVC.navigationController pushViewController:detailVc animated:YES];
//                        });
//
//                    }];
//                    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        NSLog(@"bbb");
//                    }];
//                    [alertVC addAction:cancelAct];
//                    [alertVC addAction:confirmAct];
//
//                    [nowVC presentViewController:alertVC animated:YES completion:nil];
//
//                });
//
//            }else{
//
//                nowVC = [self currentViewController];
//
//                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"content"] preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    NSLog(@"aaa");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        WonoCircleDetailViewController *detailVc = [[WonoCircleDetailViewController alloc]init];
//                        detailVc.qid = dic[@"qid"];
//                        detailVc.hidesBottomBarWhenPushed = YES;
//                        [nowVC.navigationController pushViewController:detailVc animated:YES];
//                    });
//
//                }];
//                UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    NSLog(@"bbb");
//                }];
//                [alertVC addAction:cancelAct];
//                [alertVC addAction:confirmAct];
//
//                [nowVC presentViewController:alertVC animated:YES completion:nil];
//            }
//
//
//        });
//
//    }
//
//
//
//    // [ GTSdk ]：将收到的APNs信息传给个推统计
//    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
//
//    completionHandler();
//}

#endif

-(UIViewController *)currentViewController
{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }else if ([Rootvc isKindOfClass:[UIAlertController class]]){
            UIAlertController * tabVC = (UIAlertController *)Rootvc;
            currVC = tabVC;
            Rootvc = nil;
            continue;
        }
    } while (Rootvc!=nil);
    
    
    return currVC;
}

// //获取当前屏幕显示的viewcontroller
//- (UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//        {
//            NSArray *windows = [[UIApplication sharedApplication] windows];
//            for(UIWindow * tmpWin in windows)
//                {
//                    if (tmpWin.windowLevel == UIWindowLevelNormal)
//                        {
//                            window = tmpWin;
//                            break;
//                            }
//                    }
//            }
//
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//
//    return result;
//}

-(void)alertWithTitle:(NSString *)title{
    
    UIViewController *nowVC = [self currentViewController];
    
    if([nowVC isKindOfClass:[UIAlertController class]]){
        [nowVC dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            UIViewController *nowVC = [self currentViewController];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            
            [alertVC addAction:confirmAct];
            
            [nowVC presentViewController:alertVC animated:YES completion:nil];
            
        });
        
    }else{
        
        nowVC = [self currentViewController];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
//        [alertVC addAction:cancelAct];
        [alertVC addAction:confirmAct];
        
        [nowVC presentViewController:alertVC animated:YES completion:nil];
    }

    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    
//    if([shortcutItem.type isEqualToString:@"fenxiang"]){
////        NSArray *arr = @[@"hello 3D Touch"];
////        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
////        //设置当前的VC 为rootVC
////        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
////        }];
//        BaseTabBarController *baseTabVc = (BaseTabBarController *)appDelegate.window.rootViewController;
//        baseTabVc.selectedIndex = 4;
//
//    }
    
    NSString *mark = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginMark"];
    
    if([mark isEqualToString:@"login"]){
        
        [[InterfaceSingleton shareInstance].interfaceModel getUserInfoWithCallBack:^(int state, id data, NSString *msg) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fid"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pengID"];
            
            
            //        [MBProgressHUD hideHUD];
            if(state == 2000){
                
                NSLog(@"成功");
                
                NSDictionary *dic = data;
                
                NSString *fid = dic[@"fid"];
                NSString *pengID = dic[@"greenHouse"];
                NSString *type = dic[@"type"];
                
                [[NSUserDefaults standardUserDefaults] setObject:fid forKey:@"fid"];
                [[NSUserDefaults standardUserDefaults] setObject:pengID forKey:@"pengID"];
                [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"userType"];
                
                if([shortcutItem.type isEqualToString:@"fenxiang"]){
                    //        NSArray *arr = @[@"hello 3D Touch"];
                    //        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
                    //        //设置当前的VC 为rootVC
                    //        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
                    //        }];
                    BaseTabBarController *baseTabVc = (BaseTabBarController *)appDelegate.window.rootViewController;
                    baseTabVc.selectedIndex = 4;
                    
                }else if([shortcutItem.type isEqualToString:@"zhongzhi"]){
                    
                    BaseTabBarController *baseTabVc = (BaseTabBarController *)appDelegate.window.rootViewController;
                    baseTabVc.selectedIndex = 0;
                    
                }else if ([shortcutItem.type isEqualToString:@"tongji"]){
                    BaseTabBarController *baseTabVc = (BaseTabBarController *)appDelegate.window.rootViewController;
                    baseTabVc.selectedIndex = 1;
                }else if ([shortcutItem.type isEqualToString:@"zhidao"]){
                    BaseTabBarController *baseTabVc = (BaseTabBarController *)appDelegate.window.rootViewController;
                    baseTabVc.selectedIndex = 2;
                }else if ([shortcutItem.type isEqualToString:@"wode"]){
                    BaseTabBarController *baseTabVc = (BaseTabBarController *)appDelegate.window.rootViewController;
                    baseTabVc.selectedIndex = 3;
                }
                
            }
            
            
        }];
        
        
        
    }
    
    
}



-(void)requestCount{
    
    [[InterfaceSingleton shareInstance].interfaceModel getUnReadMsgCountWithCallBack:^(int state, id data, NSString *msg) {
        if(state == 2000){
            
            
            
            NSDictionary *dic = data;
            
            NSString *str = [NSString stringWithFormat:@"%@",dic[@"count"]];
            
            int val = [str intValue];
            if(val>100){
                str = @"99+";
            }
            if(val!=0){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"badgeChange" object:str];
            }

            
        }
    }];
    
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)changeCount{
    
    UIViewController *currentVC = [self currentViewController];
    if([currentVC isKindOfClass:[WonoCircleViewController class]]){
        WonoCircleViewController *noVC = (WonoCircleViewController *)currentVC;
        [noVC requestCount];
    }else{
        [self requestCount];
    }
    
}

-(void)changeStateWithMsgID:(NSString *)needID{
    
    [[InterfaceSingleton shareInstance].interfaceModel changeMsgStateWithMessageID:needID AndStatus:@"1" WithCallBack:^(int state, id data, NSString *msg) {
        
        if(state == 2000){
            //            [self refresh];
            [self changeCount];
            
        }
        
    }];
    
}



@end
