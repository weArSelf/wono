//
//  QNUploader.m
//  New Orient2
//
//  Created by Coder on 15/11/10.
//  Copyright © 2015年 HowDo. All rights reserved.
//

#import "QNUploader.h"
#import <CommonCrypto/CommonDigest.h>
#import <Qiniu/QNCrc32.h>

@interface QNUploader ()
@property (nonatomic,assign) ENUM_QiNiuTokenType type;
@property (nonatomic, copy) NSString *uploadToken;
@property (nonatomic, copy) NSData *fileData;
@property (nonatomic, copy) NSString *fileName;

@end

@implementation QNUploader

-(instancetype)initWithUploadType:(ENUM_QiNiuTokenType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

-(void)getUploadTokenFromServer{
    //像服务器发请求获取Token
    [[InterfaceSingleton shareInstance].interfaceModel getQiNiuTokenWithCallBack:^(int state, id data, NSString *msg)
     {
         if (state == 2000) {
             self.uploadToken = data;
             [self startUpload];
         }
     }];
}

-(void)addTaskWithFileData:(NSData *)fileData FileName:(NSString *)fileName{
    self.fileName = fileName;
    self.fileData = fileData;
    [self getUploadTokenFromServer];
}

-(void)startUpload{
    QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
    QNUploadOption *opt = [QNUploadOption defaultOptions];
    
    [uploadManager putData:self.fileData key:self.fileName token:self.uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%d",info.statusCode);
        switch (info.statusCode) {
            case 200:  //上传成功
            {
                if ([self.delegate respondsToSelector:@selector(UploadSuccessWithFileName:)]) {
                    [self.delegate UploadSuccessWithFileName:self.fileName];
                }
                break;
            }
            default:{
                if ([self.delegate respondsToSelector:@selector(UploadSuccessWithFileName:)]) {
                    [self.delegate UploadFailedWithFileName:self.fileName];
                }
                break;
            }
        }
        
    } option:opt];
}
@end
