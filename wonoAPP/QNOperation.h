//
//  QiniuTool.h
//  New Orient2
//
//  Created by niezhiqiang on 15-1-7.
//  Copyright (c) 2014年 HowDo. All rights reserved.
//
#import <QiNiu/QiniuSDK.h>

typedef NS_ENUM(NSInteger,ENUM_QiNiuTokenType)  //QiNiuToken类型
{
    EQTT_Pic = 1,
    EQTT_Video,
};

typedef NS_ENUM(NSInteger, ENUM_QiNiuDownloadStatus)
{
    EQNDS_None,
    //被动状态
    EQNDS_Waiting,
    EQNDS_Downloading,
    EQNDS_Finished,
    EQNDS_Failed,
    //主动状态
    EQNDS_Start,
    EQNDS_Pause,
    EQNDS_Resume,
    EQNDS_Stop,
};

@class QNOperation;
@protocol QNOperationlDelegate<NSObject>

//上传状态更新
- (void)uploadTaskStatusChanged:(QNOperation*) oper taskId:(int)taskId status:(ENUM_QiNiuDownloadStatus)status;
//上传进度更新
- (void)uploadProgress:(QNOperation*) oper taskId:(int)taskId progress:(int)progress;

@end

//考虑,将任务封装成一个类，任务列表的管理会轻松一些
@interface QNTask : NSObject
@property (nonatomic, assign) int           taskId;
@property (nonatomic, strong) NSString*     filePath;
@property (nonatomic, assign) long long     totalSize;
@property (nonatomic, assign) long long     uploadedSize;
@property (nonatomic, assign) int           downloadProgress;   //x%*100
@property (nonatomic, assign) ENUM_QiNiuDownloadStatus    status;
@property (nonatomic, assign) ENUM_QiNiuTokenType       type;
 
-(instancetype) initWithPath:(NSString*) path;
@end

@interface QNOperation : NSObject

@property (nonatomic, weak) id<QNOperationlDelegate> delegate;

/**
 *  添加一个任务
 *
 *  @param taskPath full file path
 *
 *  @return taskId -1 means failure
 */
- (int)addTask:(NSString *)taskPath withType:(ENUM_QiNiuTokenType)type;
/**
 *  删除一个任务
 *
 *  @param  task ID
 *
 *  @return YES if success otherwise failed
 */
- (BOOL)removeTask:(int)taskId;

/**
 *  根据 taskId 获取下载状态
 *
 *  @param taskId taskId -1表示所有状态
 *
 *  @return status
 */
- (ENUM_QiNiuDownloadStatus)getDownloadStatus:(int) taskId;

/**
 *  获取当前队列下载个数
 *
 *  @return return value description
 */
- (int)getTaskCount;

/**
 *  设置下载状态
 *
 *  @param taskId -1表示全部状态
 *  @param status status description
 */
- (void)setDownloadStatus:(int) taskId status:(ENUM_QiNiuDownloadStatus) status;

/**
 *  根据 TaskId 获取 Task 信息
 *
 *  @param taskId taskId description
 *  @return return value description
 */
- (QNTask*) getTaskInfo:(int) taskId;

/**
 *  根据 TaskPath 获取 Task 信息
 *
 *  @param taskId taskId description
 *  @return return value description
 */
- (QNTask*) getTaskInfoWithPath:(NSString*) filePath;

/**
 *  获取 TaskList
 *
 *  @param taskId taskId description
 *  @return return value description
 */
- (NSArray*) getTaskList;

@end


