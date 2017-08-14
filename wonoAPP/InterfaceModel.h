//
//  InterfaceModel.h
//  New Orient
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 nding. All rights reserved.
//

#import "BaseInterfaceModel.h"
#import "CompleteModel.h"

typedef void(^AllCallBack)(int state, id data, NSString *msg);


@interface InterfaceModel : NSObject


////获取用户使用教学视频
//-(void) getHowToUsewithCallBack:(AllCallBack) callback;

-(void) userLoginWithPhone:(NSString *)phone AndSecret:(NSString *)secret WithCallBack:(AllCallBack) callback;

-(void)userRegisWithUserMobile:(NSString *)phoneNum AndPsw:(NSString *)psw AndMessageReceive:(NSString *)msgRec WithCallBack:(AllCallBack)callback;

-(void)getMsgWithPhoneNumber:(NSString *)phone WithCallBack:(AllCallBack)callback;

-(void)completeUserInfoWthModel:(CompleteModel *)model WithCallBack:(AllCallBack)callback;

-(void)searchForUserPhone:(NSString *)phone WithCallBack:(AllCallBack)callback;

-(void)getMyFarmWithCallBack:(AllCallBack)callback;

@end
