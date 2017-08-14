//
//  BaseInterfaceModel.h
//  New Orient
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 nding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef NS_ENUM(NSInteger,ENUM_NetWorkRequestType)  //网络请求类型
{
    ENRT_POST,
    ENRT_GET,
    ENRT_PUT
};


@protocol BaseInterfaceModelDelegate <NSObject>

@optional

- (void)responseCode:(int)code actionId:(int)actionId info:(id)info requestInfo:(id)requestInfo;


@end

@interface AFHTTPSessionManager (MyExtend)

- (NSURLSessionDataTask *)POSTByFullURL:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)GETByFullURL:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

@interface BaseInterfaceModel : NSObject

@property (nonatomic, weak)id<BaseInterfaceModelDelegate> delegate;

+ (instancetype)shareInstance;

- (id)sendData:(NSString *)URLString
    parameters:(NSMutableDictionary *)parameters
          type:(ENUM_NetWorkRequestType)type
   success:(void (^)(id task, id responseObject))success
   failure:(void (^)(id task, NSError *error))failure;

/*
- (id)POST:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
   success:(void (^)(id task, id responseObject))success
   failure:(void (^)(id task, NSError *error))failure;

- (id)GET:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
  success:(void (^)(id task, id responseObject))success
  failure:(void (^)(id task, NSError *error))failure;

- (id)PUT:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
  success:(void (^)(id task, id responseObject))success
  failure:(void (^)(id task, NSError *error))failure;

- (id)POST:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
     block:(void (^)(id <AFMultipartFormData> formData))block
   success:(void (^)(id task, id responseObject))success
   failure:(void (^)(id task, NSError *error))failure;

- (id)POSTWithFullURL:(NSString *)URLString
           parameters:(NSMutableDictionary *)parameters
              success:(void (^)(id task, id responseObject))success
              failure:(void (^)(id task, NSError *error))failure;

- (id)GETWithFullURL:(NSString *)URLString
          parameters:(NSMutableDictionary *)parameters
             success:(void (^)(id task, id responseObject))success
             failure:(void (^)(id task, NSError *error))failure;

*/
- (id)POST:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
     block:(void (^)(id <AFMultipartFormData> formData))block
   success:(void (^)(id task, id responseObject))success
   failure:(void (^)(id task, NSError *error))failure;
@end
