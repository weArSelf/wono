//
//  InterfaceSingleton.m
//  udo_stu
//
//  Created by Chris Ren on 15/5/21.
//  Copyright (c) 2015年 HowDo. All rights reserved.
//

#import "InterfaceSingleton.h"

@implementation InterfaceSingleton

static InterfaceSingleton *instance = nil;

@synthesize interfaceModel = interfaceModel;

+ (InterfaceSingleton *)shareInstance
{
    //CRLog(@"网络单例访问");
    @synchronized(self)
    {
        if ( instance == nil)
        {
            //CRLog(@"网络单利建立1");
            instance = [[self alloc] init];
        }
    }
    return  instance;
}

- (id)init
{
    self = [super init];
    if (self) {

        interfaceModel = [[InterfaceModel alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {

        if ( instance == nil )
            instance = [super allocWithZone:zone];
    }
    return instance;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
