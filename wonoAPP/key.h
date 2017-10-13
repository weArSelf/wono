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

#define API_PostPlant                       @"plant"

#define API_GetZhibao                       @"greenhouse/varieties"

#define API_Getji                           @"plant/bill/year"
#define API_Getnian                         @"plant/bill"
#define API_Getzong                         @"plant/bill/greens"

#define API_ForgetPwd                       @"auth/forget/password"

#define API_GetQiNiuToken                   @"qiniu/token"

#define API_RefreshUser                     @"user/update"
#define API_GetUser                         @"user"

#define API_PlantOld                        @"plant/old"


#define API_GetReg                          @"reg"

#define API_SendFeed                        @"feed"

//农知道模块相关



#define API_GetAllAsk                       @"known"
#define API_Ask                             @"known/question"
#define API_GetAllAnswer                    @"known/answer/detail"
#define API_GetDetail                       @"known/question/detail"
#define API_Answer                          @"known/answer"
#define API_Point                           @"known/like"
#define API_Collect                         @"known/collect"

#define API_GetCollect                      @"known/collect"
#define API_GetPoint                        @"known/like"

#define API_GetUserCollect                  @"user/collect"

#define API_ChangeFarmDetail                @"farm"


//消息模块

#define API_GetMyMessage                    @"user/message"
#define API_ChangeMyMessage                 @"user/message/status"
#define API_GetUnReadMessage                @"user/message/unread/count"


#define API_ChangePsw                       @"user/change/password"

#define API_UpdatePeng                      @"greenhouse/edit"

#define API_LogOut                          @"auth/logout"

#endif /* key_h */
