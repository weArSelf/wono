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

#endif /* key_h */
