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
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICETOKEN"];
    NSString *clientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"CLIENTID"];
    
    [param setObject:token forKey:@"device_token"];
    [param setObject:clientId forKey:@"client_id"];
    
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
//        [param setObject:model.area forKey:@"area"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.address forKey:@"detail"];
        [dic setObject:model.location forKey:@"gps"];
        NSString *resStr = [self DataTOjsonString:dic];
        
        [param setObject:resStr forKey:@"area"];
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

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


-(void)searchForUserPhone:(NSString *)phone WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"mobile"];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    [param setObject:str forKey:@"fid"];
    
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

-(void)getMainPengWithFid:(NSString *)fid AndCallBack:(AllCallBack)callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [[BaseInterfaceModel shareInstance] sendData:API_GreenHouse parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
        NSString *code = responseObject[@"code"];
        NSString *msg = responseObject[@"msg"];
        NSString *data = responseObject[@"data"];
        if (callback) {
            callback([code intValue], data, msg);
        }
        
        
    } failure:^(id task, NSError *error) {
        if (callback) {
            callback(3001, nil, @"网络错误");
        }
    }];
}

-(void)getFarmStuffWithFid:(NSString *)fid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [[BaseInterfaceModel shareInstance] sendData:API_FarmEmployees parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)farmDeleteEmployeeWithFid:(NSString *)fid AndUid:(NSString *)uid WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [param setObject:uid forKey:@"uid"];
    [[BaseInterfaceModel shareInstance] sendData:API_DeleteEmployees parameters:param type:ENRT_DELETE success:^(id task, id responseObject) {
        
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

-(void)farmAddStuffWithFid:(NSString *)fid AndUid:(NSString *)uid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [param setObject:uid forKey:@"uid"];
    [[BaseInterfaceModel shareInstance] sendData:API_AddEmployees parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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


-(void)getPengWithFid:(NSString *)fid AndCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [[BaseInterfaceModel shareInstance] sendData:API_GetPeng parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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


-(void)getPengWithCatPid:(NSString *)pid AndCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:pid forKey:@"pid"];
    [[BaseInterfaceModel shareInstance] sendData:API_GetPengCat parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getPengTypeCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetPengType parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)DeletePengWithFid:(NSString *)fid AndGid:(NSString *)gid WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [param setObject:gid forKey:@"gid"];
    [[BaseInterfaceModel shareInstance] sendData:API_DeletePeng parameters:param type:ENRT_DELETE success:^(id task, id responseObject) {
        
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

-(void)AddPengWithFid:(NSString *)fid AndImei:(NSString *)imei AndName:(NSString *)name AndType:(NSString *)type AndUids:(NSString *)arr AndVarID:(NSString *)varId WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [param setObject:imei forKey:@"imei"];
    [param setObject:name forKey:@"name"];
    [param setObject:type forKey:@"type"];
    [param setObject:arr forKey:@"uids"];
//    [param setObject:varId forKey:@"varieties_id"];
    [[BaseInterfaceModel shareInstance] sendData:API_AddPeng parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)getPengDetailWithGid:(NSString *)gid AndType:(NSString *)type WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:gid forKey:@"gid"];
    [param setObject:type forKey:@"type"];
    [[BaseInterfaceModel shareInstance] sendData:API_GetGreenDetail parameters:param type:ENRT_GET success:^(id task, id responseObject) {
    
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

-(void)updatePengAlertWithModel:(SetModel *)model WithCallBack:(AllCallBack)callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:model.needID forKey:@"gid"];
    
    [param setObject:model.airMax forKey:@"high_air_temp"];
    [param setObject:model.airMin forKey:@"low_air_temp"];
    
    [param setObject:model.air2Max forKey:@"high_air_humidity"];
    [param setObject:model.air2Min forKey:@"low_air_humidity"];
    
    [param setObject:model.landMax forKey:@"high_ground_temp"];
    [param setObject:model.landMin forKey:@"low_ground_temp"];
    
    [param setObject:model.land2Max forKey:@"high_ground_humidity"];
    [param setObject:model.land2Min forKey:@"low_ground_humidity"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_UpdateAlert parameters:param type:ENRT_PUT success:^(id task, id responseObject) {
        
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

-(void)getMainPlantWithModel:(MainPlantModel *)model WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:model.date forKey:@"date"];
    
    [param setObject:model.fid forKey:@"fid"];
    NSString *page = [NSString stringWithFormat:@"%d",model.page];
    [param setObject:page forKey:@"page"];
    NSString *perPage = [NSString stringWithFormat:@"%d",model.per_page];
    [param setObject:perPage forKey:@"per_page"];
    
    [param setObject:model.uid forKey:@"uid"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetPlant parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getPengDetailWithPengID:(NSString *)needID WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:needID forKey:@"id"];
    [[BaseInterfaceModel shareInstance] sendData:API_getPengDetail parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getPengPayWithGid:(NSString *)gid AndCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:gid forKey:@"gid"];
    [[BaseInterfaceModel shareInstance] sendData:API_GetPengPay parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getPengListWithGid:(NSString *)gid AndPage:(int)page WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString *pa = [NSString stringWithFormat:@"%d",page];
    
    
    [param setObject:gid forKey:@"gid"];
    [param setObject:pa forKey:@"page"];
    [param setObject:@"10" forKey:@"per_page"];
//    [pa setValue:@"10" forKey:@"per_page"];
    [[BaseInterfaceModel shareInstance] sendData:API_GetPengList parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)PostPlantWithModel:(PlantAddModel *)model WithCallBack:(AllCallBack)callback{
    
     NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    [param setObject:model.resTime forKey:@"time"];//待定
    
    
    
    if([model.type isEqualToString:@"1"]){
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.amount forKey:@"amount"];
        [param setObject:model.gid forKey:@"gid"];
        [param setObject:model.note forKey:@"note"];
        [param setObject:model.type forKey:@"type"];
        [param setObject:model.price forKey:@"unit_price"];
        [param setObject:model.varId forKey:@"variety_id"];
    }else if([model.type isEqualToString:@"2"]){
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.totalAmount forKey:@"total_amount"];
        [param setObject:model.gid forKey:@"gid"];
        [param setObject:model.note forKey:@"note"];
        [param setObject:model.type forKey:@"type"];
        [param setObject:model.varId forKey:@"variety_id"];
    }else if([model.type isEqualToString:@"3"]){
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.totalAmount forKey:@"total_amount"];
        [param setObject:model.gid forKey:@"gid"];
        [param setObject:model.note forKey:@"note"];
        [param setObject:model.type forKey:@"type"];
        [param setObject:model.varId forKey:@"variety_id"];
    }else if([model.type isEqualToString:@"4"]){
       
        [param setObject:model.amount forKey:@"amount"];
        [param setObject:model.gid forKey:@"gid"];
        [param setObject:model.note forKey:@"note"];
        [param setObject:model.type forKey:@"type"];
        [param setObject:model.price forKey:@"unit_price"];
        [param setObject:model.unitType forKey:@"unit_type"];
        [param setObject:model.varId forKey:@"variety_id"];
    }
    
    [[BaseInterfaceModel shareInstance] sendData:API_PostPlant parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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


-(void)getPengWithCatPid:(NSString *)pid WithType:(NSString *)type AndCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:pid forKey:@"pid"];
    [param setObject:type forKey:@"type"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetPengCat parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)GetjiWithFid:(NSString *)fid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_Getji parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)GetNianWithFid:(NSString *)fid AndType:(NSString *)type WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    [param setObject:type forKey:@"type"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_Getnian parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)GetZongWithFid:(NSString *)fid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:fid forKey:@"fid"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_Getzong parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)forgetPwdWithMobile:(NSString *)mobile AndMessage:(NSString *)msg AndPwd:(NSString *)password WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:mobile forKey:@"mobile"];
    [param setObject:msg forKey:@"msg_code"];
    [param setObject:password forKey:@"password"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_ForgetPwd parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)getQiNiuTokenWithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetQiNiuToken parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)updateUserInfoWithAvatar:(NSString *)ava AndSex:(NSString *)sex AndName:(NSString *)name AndCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:ava forKey:@"avatar"];
    [param setObject:sex forKey:@"sex"];
    [param setObject:name forKey:@"username"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_RefreshUser parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)getUserInfoWithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetUser parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getOldMainPlantWithModel:(MainPlantModel *)model WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:model.date forKey:@"date"];
    
    [param setObject:model.fid forKey:@"fid"];
    NSString *page = [NSString stringWithFormat:@"%d",model.page];
    [param setObject:page forKey:@"page"];
    NSString *perPage = [NSString stringWithFormat:@"%d",model.per_page];
    [param setObject:perPage forKey:@"per_page"];
    
    [param setObject:model.uid forKey:@"uid"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_PlantOld parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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



-(void)GetRegWithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:fid forKey:@"fid"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetReg parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)SendFeedBackWithContent:(NSString *)content WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:content forKey:@"content"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_SendFeed parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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


-(void)GetAllAskWithCallBackWithPage:(int)page AndCallBack:(AllCallBack)callback{
    
    NSString *str = [NSString stringWithFormat:@"%d",page];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:str forKey:@"page"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetAllAsk parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)WonoAskQuestionWithContent:(NSString *)content AndResources:(NSString *)resArrStr     WithTitle:(NSString *)title WithType:(NSString *)type WithCallBack:(AllCallBack)callback{

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //    [param setObject:fid forKey:@"fid"];
    [param setObject:content forKey:@"content"];
    [param setObject:resArrStr forKey:@"resources"];
    [param setObject:title forKey:@"title"];
    [param setObject:type forKey:@"type"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_Ask parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)getWonoAllAnswerWithPage:(int)page AndQid:(NSString *)Qid WithCallBack:(AllCallBack)callback{
    
    NSString *str = [NSString stringWithFormat:@"%d",page];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:str forKey:@"page"];
    [param setObject:Qid forKey:@"qid"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetAllAnswer parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getAskDetailWithID:(NSString *)qid WithCallBack:(AllCallBack)callback{
    
   
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:str forKey:@"page"];
    [param setObject:qid forKey:@"qid"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetDetail parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)wonoAnswerWithQid:(NSString *)qid AndContent:(NSString *)ansDic WithRepID:(NSString *)repID WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:qid forKey:@"qid"];
    [param setObject:ansDic forKey:@"answer"];
    [param setObject:repID forKey:@"reply_id"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_Answer parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)MarkPointWithAction:(NSString *)act AndQid:(NSString *)qid WithCallBack:(AllCallBack)callback{
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:qid forKey:@"qid"];
    [param setObject:act forKey:@"action"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_Point parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)collectWithAction:(NSString *)act AndQid:(NSString *)qid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:qid forKey:@"qid"];
    [param setObject:act forKey:@"action"];
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_Collect parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)getUserLikeWithQid:(NSString *)qid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:qid forKey:@"qid"];

    [[BaseInterfaceModel shareInstance] sendData:API_GetPoint parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getUserCollectWithQid:(NSString *)qid WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:qid forKey:@"qid"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetCollect parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getUserCollectDetailWithPage:(int)page WithCallBack:(AllCallBack)callback{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *str = [NSString stringWithFormat:@"%d",page];
    [param setObject:str forKey:@"page"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetUserCollect parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)ChangeUserDetailWithObject:(NSString *)obj AndKey:(NSString *)key WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
    
    [param setObject:str forKey:@"fid"];
    [param setObject:obj forKey:key];
    
    [[BaseInterfaceModel shareInstance] sendData:API_ChangeFarmDetail parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)getMyMessageWithPage:(int)page WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *str = [NSString stringWithFormat:@"%d",page];
    [param setObject:str forKey:@"page"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetMyMessage parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)getUnReadMsgCountWithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[BaseInterfaceModel shareInstance] sendData:API_GetUnReadMessage parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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

-(void)changeMsgStateWithMessageID:(NSString *)needID AndStatus:(NSString *)status WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:needID forKey:@"id"];
    [param setObject:status forKey:@"status"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_ChangeMyMessage parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)changeuserPswWithOrgin:(NSString *)orgpsw AndNewPsw:(NSString *)newpsw WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:orgpsw forKey:@"old_password"];
    [param setObject:newpsw forKey:@"new_password"];
    
    [[BaseInterfaceModel shareInstance] sendData:API_ChangePsw parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)updatePengWithArea:(NSString *)area AndGid:(NSString *)gid AndImei:(NSString *)imei AndType:(NSString *)type AndUids:(NSString *)uids WithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if(![area isEqualToString:@""]){
        [param setObject:area forKey:@"area"];
    }
    if(![imei isEqualToString:@""]){
        [param setObject:imei forKey:@"imei"];
    }
    if(![type isEqualToString:@""]){
        [param setObject:type forKey:@"type"];
    }
    if(![uids isEqualToString:@""]){
        [param setObject:uids forKey:@"uids"];
    }
    
    [param setObject:gid forKey:@"gid"];
    
    
    
    
    [[BaseInterfaceModel shareInstance] sendData:API_UpdatePeng parameters:param type:ENRT_POST success:^(id task, id responseObject) {
        
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

-(void)userLogOutWithCallBack:(AllCallBack)callback{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   
    [[BaseInterfaceModel shareInstance] sendData:API_LogOut parameters:param type:ENRT_GET success:^(id task, id responseObject) {
        
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
