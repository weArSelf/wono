//
//  InterfaceSingleton.h
//  udo_stu
//
//  Created by Chris Ren on 15/5/21.
//  Copyright (c) 2015年 HowDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceModel.h"

@interface InterfaceSingleton : NSObject
{
    InterfaceModel *interfaceModel;
}
@property (nonatomic, copy) InterfaceModel *interfaceModel;

+ (InterfaceSingleton *)shareInstance;

@end
