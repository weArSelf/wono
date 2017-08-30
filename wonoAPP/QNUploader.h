//
//  QNUploader.h
//  New Orient2
//
//  Created by Coder on 15/11/10.
//  Copyright © 2015年 HowDo. All rights reserved.
//
#import <QiNiu/QiniuSDK.h>
#import <Foundation/Foundation.h>

@class QNUploader;

typedef NS_ENUM(NSInteger,ENUM_QiNiuTokenType)  //QiNiuToken类型
{
    EQTT_Pic = 1,
    EQTT_Video,
};

@protocol QNUploaderDelegate <NSObject>
@optional
-(void)UploadSuccessWithFileName:(NSString *)fileName;

-(void)UploadFailedWithFileName:(NSString *)fileName;

@end

@interface QNUploader : NSObject

@property (nonatomic, weak) id<QNUploaderDelegate> delegate;

-(instancetype) initWithUploadType:(ENUM_QiNiuTokenType)type;

-(void)addTaskWithFileData:(NSData *)fileData FileName:(NSString *)fileName;

@end
