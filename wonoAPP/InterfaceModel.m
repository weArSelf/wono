//
//  InterfaceModel.m
//  New Orient
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 nding. All rights reserved.
//

#import "InterfaceModel.h"

#import "CompleteModel.h"

@implementation InterfaceModel


#pragma mark - HowToUse

//-(void) getHowToUsewithCallBack:(AllCallBack) callback
//{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@"get" forKey:@"use"];
//    [[BaseInterfaceModel shareInstance] sendData:API_GetUse
//                                      parameters:param
//                                            type:ENRT_GET
//                                         success:^(id task, id responseObject) {
//                                             NSString *code = responseObject[@"code"];
//                                             NSString *msg = responseObject[@"msg"];
//                                             NSString *data = responseObject[@"data"];
//                                             if (callback) {
//                                                 callback([code intValue], data, msg);
//                                             }
//                                             
//                                         } failure:^(id task, NSError *error) {
//                                             if (callback) {
//                                                 callback(2001, nil, nil);
//                                             }
//                                         }];
//}

-(void) userLoginWithPhone:(NSString *)phone AndSecret:(NSString *)secret WithCallBack:(AllCallBack) callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"mobile"];
    [param setObject:secret forKey:@"password"];
    [[BaseInterfaceModel shareInstance] sendData:API_Login
                                      parameters:param
                                            type:ENRT_POST
                                         success:^(id task, id responseObject) {
                                             NSString *code = responseObject[@"code"];
                                             NSString *msg = responseObject[@"msg"];
                                             NSString *data = responseObject[@"data"];
                                             if (callback) {
                                                 callback([code intValue], data, msg);
                                             }
                                             
                                         } failure:^(id task, NSError *error) {
                                             if (callback) {
                                                 callback(2001, nil, nil);
                                             }
                                         }];
}

-(void)userRegisWithUserMobile:(NSString *)phoneNum AndPsw:(NSString *)psw AndMessageReceive:(NSString *)msgRec WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phoneNum forKey:@"mobile"];
    [param setObject:psw forKey:@"password"];
    [param setObject:msgRec forKey:@"msg_code"];
    [[BaseInterfaceModel shareInstance] sendData:API_Reges parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
        NSString *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if (callback) {
            callback([code intValue], data, msg);
        }

        
    } failure:^(id task, NSError *error) {
        if (callback) {
            callback(2001, nil, @"网络错误");
        }
    }];
    
}

-(void)getMsgWithPhoneNumber:(NSString *)phone WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"mobile"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_getMsg parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
        NSString *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if (callback) {
            callback([code intValue], data, msg);
        }
        
        
    } failure:^(id task, NSError *error) {
        if (callback) {
            callback(2001, nil, @"网络错误");
        }
    }];
    
}

-(void)completeUserInfoWthModel:(CompleteModel *)model WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:phone forKey:@"mobile"];
    NSString *type = [NSString stringWithFormat:@"%d",model.type];
    NSString *sex = [NSString stringWithFormat:@"%d",model.sex];
    [param setObject:type forKey:@"type"];
    [param setObject:sex forKey:@"sex"];
    [param setObject:model.birth forKey:@"birth"];
    [param setObject:model.name forKey:@"name"];
    if(model.type == 1){
        [param setObject:model.farmName forKey:@"farmName"];
        [param setObject:model.area forKey:@"area"];
        
    }
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_CopleteInfo parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
        NSString *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if (callback) {
            callback([code intValue], data, msg);
        }
        
        
    } failure:^(id task, NSError *error) {
        if (callback) {
            callback(2001, nil, @"网络错误");
        }
    }];
}

-(void)searchForUserPhone:(NSString *)phone WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"mobile"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_SearchPhone parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
        NSString *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if (callback) {
            callback([code intValue], data, msg);
        }
        
        
    } failure:^(id task, NSError *error) {
        if (callback) {
            callback(2001, nil, @"网络错误");
        }
    }];
}

-(void)getMyFarmWithCallBack:(AllCallBack)callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[BaseInterfaceModel shareInstance] sendData:API_GetFarm parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
        NSString *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if (callback) {
            callback([code intValue], data, msg);
        }
        
        
    } failure:^(id task, NSError *error) {
        if (callback) {
            callback(2001, nil, @"网络错误");
        }
    }];
    
    
}

@end
