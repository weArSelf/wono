//
//  BaseInterfaceModel.m
//  New Orient
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 nding. All rights reserved.
//

#import "BaseInterfaceModel.h"
#import <CommonCrypto/CommonDigest.h>

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

static NSString * const BaseURLString = BASE_URL;
static BaseInterfaceModel*              _interface;
static AFHTTPSessionManager             *_sessionManager;

@implementation BaseInterfaceModel

- (id)initWithDelegate:(id<BaseInterfaceModelDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;

}


-(id) allocWithZone:(struct _NSZone *)zone
{
    return [BaseInterfaceModel shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [BaseInterfaceModel shareInstance] ;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _interface = [[BaseInterfaceModel alloc] init];
        NSURL *baseURL = [NSURL URLWithString:BaseURLString];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//[NSSet setWithObject:@"text/html"];
        //请求超时时间
        _sessionManager.requestSerializer.timeoutInterval = TIMEOUTINTERRVAL;
       
        //AFNetWorking支持https
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //是否信任服务器无效或过期的SSL证书。
        securityPolicy.allowInvalidCertificates = YES;
        //是否在证书的“字段”字段中验证域名
        securityPolicy.validatesDomainName = NO;
        _sessionManager.securityPolicy = securityPolicy;
        
    });
    
    return _interface;
}

- (id)sendData:(NSString *)URLString
    parameters:(NSMutableDictionary *)parameters
          type:(ENUM_NetWorkRequestType)type
       success:(void (^)(id task, id responseObject))success
       failure:(void (^)(id task, NSError *error))failure
{
    //在header中添加token参数  Authorization:Bearer{你的token}
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
//    [parameters setObject:token forKey:@"token"];
    
    [_sessionManager.requestSerializer
     setValue:[NSString stringWithFormat:@"Bearer %@",token]
     forHTTPHeaderField:@"Authorization"];
    
    
    [_sessionManager.requestSerializer setValue:Base_Header forHTTPHeaderField:@"Host"];
    
    switch (type) {
        case ENRT_POST:
            return [self POST:URLString parameters:parameters success:success failure:failure];
        case ENRT_PUT:
            return [self PUT:URLString parameters:parameters success:success failure:failure];
        case ENRT_GET:
            return [self GET:URLString parameters:parameters success:success failure:failure];
        default:
            return [self POST:URLString parameters:parameters success:success failure:failure];
    }
}

- (id)POST:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
   success:(void (^)(id task, id responseObject))success
   failure:(void (^)(id task, NSError *error))failure
{
    NSDictionary* para = [self addRequiredParameter:parameters];
    [self logRequestUrl:URLString withParam:para];
    return [_sessionManager POST:URLString
                      parameters:para
                         success:success
                         failure:failure];
}

- (id)GET:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
  success:(void (^)(id task, id responseObject))success
  failure:(void (^)(id task, NSError *error))failure
{
    NSDictionary* para = [self addRequiredParameter:parameters];
    [self logRequestUrl:URLString withParam:para];
    return [_sessionManager GET:URLString
                      parameters:para
                         success:success
                         failure:failure];
}

- (id)PUT:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
  success:(void (^)(id task, id responseObject))success
  failure:(void (^)(id task, NSError *error))failure
{
    NSDictionary* para = [self addRequiredParameter:parameters];
    [self logRequestUrl:URLString withParam:para];
    return [_sessionManager PUT:URLString
                      parameters:para
                         success:success
                         failure:failure];
}

// 发送文件
- (id)POST:(NSString *)URLString
parameters:(NSMutableDictionary *)parameters
     block:(void (^)(id <AFMultipartFormData> formData))block
   success:(void (^)(id task, id responseObject))success
   failure:(void (^)(id task, NSError *error))failure {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [_sessionManager.requestSerializer
     setValue:[NSString stringWithFormat:@"Bearer{%@}",token]
     forHTTPHeaderField:@"Authorization"];
    
    NSDictionary* para = [self addRequiredParameter:parameters];
    [self logRequestUrl:URLString withParam:para];
    
    return [_sessionManager POST:URLString
                      parameters:[self addRequiredParameter:parameters]
       constructingBodyWithBlock:block
                         success:success
                         failure:failure];
}




- (id)POSTWithFullURL:(NSString *)URLString
           parameters:(NSMutableDictionary *)parameters
              success:(void (^)(id task, id responseObject))success
              failure:(void (^)(id task, NSError *error))failure
{
    return [_sessionManager POSTByFullURL:URLString
                               parameters:[self addRequiredParameter:parameters]
                                  success:success
                                  failure:failure];
}



- (id)GETWithFullURL:(NSString *)URLString
          parameters:(NSMutableDictionary *)parameters
             success:(void (^)(id task, id responseObject))success
             failure:(void (^)(id task, NSError *error))failure
{
    return [_sessionManager GETByFullURL:URLString
                              parameters:[self addRequiredParameter:parameters]
                                 success:success
                                 failure:failure];
}

#pragma mark - md5加密
- (NSString *)md5:(NSString *)str
{
    const char * cStr = [str UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [Mstr appendFormat:@"%02X",result[i]];
    }
    return Mstr;
}

- (NSDictionary*) addRequiredParameter:(NSMutableDictionary*) param
{
    if (param == nil) {
        param = [NSMutableDictionary dictionary];
    }
    //get token from usrdefault
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [param setObject:token forKey:@"token"];
//    NSString* timestamp = [NSString stringWithFormat:@"%d",(int)[NSDate date].timeIntervalSince1970];
//    [param setObject:timestamp forKey:@"random"];
//    [param setObject:[self md5:[timestamp stringByAppendingString:HDAppKey]] forKey:@"sign"];
    return param;
}

-(void) logRequestUrl:(NSString*)url withParam:(NSDictionary*) param
{
    NSString* fullUrl = [BaseURLString stringByAppendingString:url];
    fullUrl = [fullUrl stringByAppendingString:@"?"];
    NSArray* keys = param.allKeys;
    for (int i = 0; i<keys.count; ++i) {
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keys[i],[param objectForKey:keys[i]]]];
    }
    NSLog(@"%@", [fullUrl substringToIndex:fullUrl.length-1]);
}

@end
