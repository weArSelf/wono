//
//  CompleteModel.h
//  wonoAPP
//
//  Created by IF on 2017/8/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompleteModel : NSObject

@property (nonatomic,strong) NSMutableArray *area;
@property (nonatomic,strong) NSString *birth;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *farmName;
@property (nonatomic) int  sex;
@property (nonatomic) int  type;

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *location;

@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;

@end
