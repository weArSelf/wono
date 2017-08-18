//
//  MainTempModel.h
//  wonoAPP
//
//  Created by IF on 2017/8/14.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTempModel : NSObject

@property (nonatomic,strong) NSString *temp1;
@property (nonatomic) int temp1sign;

@property (nonatomic,strong) NSString *temp2;
@property (nonatomic) int temp2sign;

@property (nonatomic,strong) NSString *temp3;
@property (nonatomic) int temp3sign;

@property (nonatomic,strong) NSString *temp4;
@property (nonatomic) int temp4sign;

@property (nonatomic,strong) NSString *cat;
@property (nonatomic,strong) NSString *stuf;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *extra;
@property (nonatomic,strong) NSString *time;

@property (nonatomic) int state;

@property (nonatomic) int pengID;

@end
