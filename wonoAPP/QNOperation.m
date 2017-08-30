//
//  QiniuTool.m
//  New Orient2
//
//  Created by niezhiqiang on 15-1-7.
//  Copyright (c) 2014年 HowDo. All rights reserved.
//

#import "QNOperation.h"
#import <Qiniu/QNCrc32.h>
#include <sys/stat.h>
#include <dirent.h>
#import <CommonCrypto/CommonDigest.h>

@implementation QNTask
static int QNTaskID = -1;
-(instancetype) initWithPath:(NSString*) path
{
    self = [super init];
    if (self) {
        _totalSize = 0;
        _uploadedSize = 0;
        _downloadProgress = 0;
        _status = EQNDS_None;
        _taskId = ++QNTaskID;
        _filePath = path;
    }
    return self;
}

/*-(int) downloadProgress
{
    return _uploadedSize*100.0/_totalSize;
}*/

-(void) setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    //获取文件大小赋值
    _totalSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
}

@end

@interface QNOperation ()

@property (nonatomic, assign)ENUM_QiNiuDownloadStatus status;

@property (nonatomic, strong) NSMutableArray    *tasks;

@property (nonatomic, strong) QNUploadManager   *uploadManager;
@property (nonatomic, strong) QNUploadOption    *opt;

@property (nonatomic, strong) NSString          *token;

@end

@implementation QNOperation

- (id)init
{
    if( self = [super init] )
    {
        _status = EQNDS_None;
        _tasks = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -- Implement Interface
- (int)addTask:(NSString *)taskPath withType:(ENUM_QiNiuTokenType)type
{
    if( !taskPath || !taskPath.length ){
        return -1;
    }
    if( ![[NSFileManager defaultManager] fileExistsAtPath:taskPath] ){
        return -1;
    }
    for (QNTask* each in _tasks) {
        if ([each.filePath isEqualToString:taskPath]) {
            return -1;
        }
    }
    //创建新的任务对象
    QNTask*  task = [[QNTask alloc] initWithPath:taskPath];
    task.type = type;
    if (task != nil)
    {
        //将任务加入到上传队列中
        [_tasks addObject:task];
        
        //若上传队伍只有此任务，则立即启动该上传任务
        if( _tasks.count == 1)
        {
            //@TODO: to start the upload task with taskId, if the status is uploading , return.
            [self startUploadTask:task.taskId];
        }
        return task.taskId;
    }
    else
    {
        return -1;
    }
}

- (BOOL)removeTask:(int)taskId
{
    if( taskId < 0 ){
        return NO;
    }

    QNTask* task = [self getTaskInfo:taskId];
    [self setDownloadStatus:task.taskId status:EQNDS_Stop];
    //从任务列表中删除当前任务
    [_tasks removeObject:task];
    //@TODO:更新本地存储记录

    return 1;
}

- (void)setDownloadStatus:(int) taskId status:(ENUM_QiNiuDownloadStatus) status
{
    switch (status) {
        case EQNDS_Start:
        {
            [self startUploadTask:taskId];
            break;
        }
        case EQNDS_Stop:
        {
            if( [self.delegate respondsToSelector:@selector(uploadTaskStatusChanged:taskId:status:)] ){
                [self.delegate uploadTaskStatusChanged:self taskId:taskId status:EQNDS_Pause];
            }
            break;
        }
        case EQNDS_Pause:
        {
            break;
        }
        case EQNDS_Resume:
        {
            break;
        }
        default:
            break;
    }
}

- (int)getTaskCount
{
    if( _tasks.count > 0)
    {
        return (int)_tasks.count;
    }
    return 0;
}

- (ENUM_QiNiuDownloadStatus)getDownloadStatus:(int) taskId
{
    if (taskId < 0) {
        return EQNDS_None;
    }
    else
    {
        QNTask* task = [self getTaskInfo:taskId];
        return (task==nil)?EQNDS_None:task.status;
    }
}

-(QNTask*) getTaskInfo:(int)taskId
{
    if (taskId < 0) {
        return nil;
    }
    for (QNTask* task in _tasks) {
        if (task.taskId == taskId) {
            return task;
            break;
        }
    }
    return nil;
}

- (QNTask*) getTaskInfoWithPath:(NSString*) filePath
{
    for (QNTask* task in _tasks) {
        if ([task.filePath isEqualToString:filePath]) {
            return task;
            break;
        }
    }
    return nil;
}

- (NSArray*) getTaskList
{
    return _tasks;
}

#pragma mark -- Upload Task

- (void)startUploadTask:(int)taskId
{
    if (taskId < 0)
        return;
    
    QNTask* task = [self getTaskInfo:taskId];
    if (task.status == EQNDS_Finished ||
        task.status == EQNDS_Downloading) {
        return;
    }
    [NSThread detachNewThreadSelector:@selector(getTokenForServerThread:) toTarget:self withObject:task];
}

- (void)getTokenForServerThread:(QNTask*) task
{
    [[InterfaceSingleton shareInstance].interfaceModel getQiNiuTokenWithCallBack:^(int state, id data, NSString *msg)
     {
         if (state == 2000) {
             _token = data;
             if( !_token || !_token.length )
             {
                 if( [self.delegate respondsToSelector:@selector(uploadTaskStatusChanged:taskId:status:)] ){
                     [self.delegate uploadTaskStatusChanged:self taskId:task.taskId status:EQNDS_Failed];
                 }
                 [_tasks removeObject:task];
                 //启动任务列表中的下一个任务
                 if( _tasks.count > 0 )
                 {
                     [self startUploadTask:((QNTask*)[_tasks objectAtIndex:0]).taskId];
                 }
                 //[_tasks addObject:task];
                 return ;
             }
             [self performSelectorOnMainThread:@selector(uploadTask:) withObject:task waitUntilDone:YES];
         }
     }];
}

- (void)uploadTask:(QNTask*)task
{
    NSLog(@"=======uploadTask========");
    task.status = EQNDS_Downloading;
    //生成七牛上传器
    if( [self.delegate respondsToSelector:@selector(uploadTaskStatusChanged:taskId:status:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate uploadTaskStatusChanged:self taskId:task.taskId status:EQNDS_Downloading];
        });
    }
    __block int interval = 0;
    self.opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: ^(NSString *key, float percent) {
        NSLog(@"-----------%f-------",percent);
        if (percent*100 > interval) {
            interval = percent*100;
            //单文件进度处理
            task.uploadedSize = task.totalSize*percent;
            task.downloadProgress = percent*100;
            //最终进度条
            if( [self.delegate respondsToSelector:@selector(uploadProgress:taskId:progress:)])
            {
                if( percent > 0.0 && percent <= 1.0 )
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate uploadProgress:self taskId:task.taskId progress:task.downloadProgress];
                    });
            }
            
        }
    } params:nil checkCrc:YES cancellationSignal: ^BOOL () {
        return ![_tasks containsObject:task];
    }];
    
    NSString* key = [self createGUID];
    QNConfiguration* config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];
    self.uploadManager = [[QNUploadManager alloc] initWithConfiguration:config];//[[QNUploadManager alloc] initWithRecorder:fileRecord];
    [self.uploadManager putFile:task.filePath key:key token:_token
                       complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
     {
         switch (info.statusCode) {
             case 200:  //上传成功
             {
                 task.status = EQNDS_Finished;
                 if( [self.delegate respondsToSelector:@selector(uploadTaskStatusChanged:taskId:status:)])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.delegate uploadTaskStatusChanged:self taskId:task.taskId status:EQNDS_Finished];
                         [_tasks removeObject:task];
                         if( _tasks.count > 0 )
                         {
                             [self startUploadTask:((QNTask*)[_tasks objectAtIndex:0]).taskId];
                         }
                     });
                 }
                 break;
             }
             default:
             {
                 task.status = EQNDS_Failed;
                 if( [self.delegate respondsToSelector:@selector(uploadTaskStatusChanged:taskId:status:)])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.delegate uploadTaskStatusChanged:self taskId:task.taskId status:EQNDS_Failed];
                         [_tasks removeObject:task];
                         //失败处理
                         if( _tasks.count > 0 )
                         {
                             [self startUploadTask:((QNTask*)[_tasks objectAtIndex:0]).taskId];
                         }
                         //[_tasks addObject:task];
                     });
                 }
                 break;
             }
         }
     } option:self.opt];
}

- (NSString *)createGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

@end
