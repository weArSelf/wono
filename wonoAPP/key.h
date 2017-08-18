//
//  key.h
//  wonoAPP
//
//  Created by IF on 2017/8/8.
//  Copyright © 2017年 IF. All rights reserved.
//

#ifndef key_h
#define key_h

#import "InterfaceSingleton.h"

#define BASE_URL  @"http://api.wonotech.com:8000/ios/v1.0/"

#define Base_Header @"wono"

////获取使用教学视频
//#define API_GetUse                          @"tch/help/list"


#define API_Login                           @"auth/login"
#define API_Reges                           @"auth/register"
#define API_getMsg                          @"sms/send"
#define API_CopleteInfo                     @"user/perfect"
#define API_SearchPhone                     @"user/like/mobile"
#define API_GetFarm                         @"farm"

//首页数据
#define API_GreenHouse                      @"index/greenhouse"

#define API_FarmEmployees                   @"farm/employees"
#define API_DeleteEmployees                 @"farm/employee"
#define API_AddEmployees                    @"farm/employee"

#define API_GetPeng                         @"greenhouse"
#define API_AddPeng                         @"greenhouse/add"
#define API_DeletePeng                      @"greenhouse"

#define API_GetPengCat                      @"greenhouse/varieties"
#define API_GetPengType                     @"greenhouse/type"

#define API_GetGreenDetail                  @"greenhouse/monitor"

#define API_UpdateAlert                     @"greenhouse/threshold"

#define API_GetPlant                        @"plant"
#define API_getPengDetail                   @"greenhouse/detail"
#define API_GetPengPay                      @"greenhouse/bill"
#define API_GetPengList                     @"plant/detail"

#endif /* key_h */
