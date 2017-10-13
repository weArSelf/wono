//
//  InterfaceModel.h
//  New Orient
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 nding. All rights reserved.
//

#import "BaseInterfaceModel.h"
#import "CompleteModel.h"
#import "SetModel.h"
#import "MainPlantModel.h"
#import "PlantAddModel.h"

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



-(void)getMainPengWithFid:(NSString *)fid AndCallBack:(AllCallBack)callback;

-(void)getFarmStuffWithFid:(NSString *)fid WithCallBack:(AllCallBack)callback;

-(void)farmDeleteEmployeeWithFid:(NSString *)fid AndUid:(NSString *)uid WithCallBack:(AllCallBack)callback;

-(void)farmAddStuffWithFid:(NSString *)fid AndUid:(NSString *)uid WithCallBack:(AllCallBack)callback;


-(void)getPengWithFid:(NSString *)fid AndCallBack:(AllCallBack)callback;

-(void)getPengWithCatPid:(NSString *)pid AndCallBack:(AllCallBack)callback;

-(void)getPengTypeCallBack:(AllCallBack)callback;

-(void)DeletePengWithFid:(NSString *)fid AndGid:(NSString *)gid WithCallBack:(AllCallBack)callback;

-(void)AddPengWithFid:(NSString *)fid AndImei:(NSString *)imei AndName:(NSString *)name AndType:(NSString *)type AndUids:(NSString *)arr AndVarID:(NSString *)varId WithCallBack:(AllCallBack)callback;

-(void)getPengDetailWithGid:(NSString *)gid AndType:(NSString *)type WithCallBack:(AllCallBack)callback;

-(void)updatePengAlertWithModel:(SetModel *)model WithCallBack:(AllCallBack)callback;

-(void)getMainPlantWithModel:(MainPlantModel *)model WithCallBack:(AllCallBack)callback;

-(void)getPengDetailWithPengID:(NSString *)needID WithCallBack:(AllCallBack)callback;

-(void)getPengPayWithGid:(NSString *)gid AndCallBack:(AllCallBack)callback;

-(void)getPengListWithGid:(NSString *)gid AndPage:(int)page WithCallBack:(AllCallBack)callback;

-(void)PostPlantWithModel:(PlantAddModel *)model WithCallBack:(AllCallBack)callback;

-(void)getPengWithCatPid:(NSString *)pid WithType:(NSString *)type AndCallBack:(AllCallBack)callback;

-(void)GetjiWithFid:(NSString *)fid WithCallBack:(AllCallBack)callback;

-(void)GetNianWithFid:(NSString *)fid AndType:(NSString *)type WithCallBack:(AllCallBack)callback;

-(void)GetZongWithFid:(NSString *)fid WithCallBack:(AllCallBack)callback;

-(void)forgetPwdWithMobile:(NSString *)mobile AndMessage:(NSString *)msg AndPwd:(NSString *)password WithCallBack:(AllCallBack)callback;

-(void)getQiNiuTokenWithCallBack:(AllCallBack)callback;

-(void)updateUserInfoWithAvatar:(NSString *)ava AndSex:(NSString *)sex AndName:(NSString *)name AndCallBack:(AllCallBack)callback;

-(void)getUserInfoWithCallBack:(AllCallBack)callback;

-(void)getOldMainPlantWithModel:(MainPlantModel *)model WithCallBack:(AllCallBack)callback;

-(void)GetRegWithCallBack:(AllCallBack)callback;

-(void)SendFeedBackWithContent:(NSString *)content WithCallBack:(AllCallBack)callback;

-(void)GetAllAskWithCallBackWithPage:(int)page AndCallBack:(AllCallBack)callback;

-(void)WonoAskQuestionWithContent:(NSString *)content AndResources:(NSString *)resArrStr     WithTitle:(NSString *)title WithType:(NSString *)type WithCallBack:(AllCallBack)callback;

-(void)getWonoAllAnswerWithPage:(int)page AndQid:(NSString *)Qid WithCallBack:(AllCallBack)callback;

-(void)getAskDetailWithID:(NSString *)qid WithCallBack:(AllCallBack)callback;

-(void)wonoAnswerWithQid:(NSString *)qid AndContent:(NSString *)ansDic WithRepID:(NSString *)repID WithCallBack:(AllCallBack)callback;

-(void)MarkPointWithAction:(NSString *)act AndQid:(NSString *)qid WithCallBack:(AllCallBack)callback;

-(void)collectWithAction:(NSString *)act AndQid:(NSString *)qid WithCallBack:(AllCallBack)callback;

-(void)getUserLikeWithQid:(NSString *)qid WithCallBack:(AllCallBack)callback;

-(void)getUserCollectWithQid:(NSString *)qid WithCallBack:(AllCallBack)callback;

-(void)getUserCollectDetailWithPage:(int)page WithCallBack:(AllCallBack)callback;

-(void)ChangeUserDetailWithObject:(NSString *)obj AndKey:(NSString *)key WithCallBack:(AllCallBack)callback;

-(void)getMyMessageWithPage:(int)page WithCallBack:(AllCallBack)callback;

-(void)getUnReadMsgCountWithCallBack:(AllCallBack)callback;

-(void)changeMsgStateWithMessageID:(NSString *)needID AndStatus:(NSString *)status WithCallBack:(AllCallBack)callback;

-(void)changeuserPswWithOrgin:(NSString *)orgpsw AndNewPsw:(NSString *)newpsw WithCallBack:(AllCallBack)callback;

-(void)updatePengWithArea:(NSString *)area AndGid:(NSString *)gid AndImei:(NSString *)imei AndType:(NSString *)type AndUids:(NSString *)uids WithCallBack:(AllCallBack)callback;

-(void)userLogOutWithCallBack:(AllCallBack)callback;

@end
