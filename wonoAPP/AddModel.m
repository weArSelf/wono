//
//  AddModel.m
//  wonoAPP
//
//  Created by IF on 2017/8/18.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "AddModel.h"

@implementation AddModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameArr = [NSMutableArray array];
        _needIDArr = [NSMutableArray array];
        _variName = [NSMutableArray array];
        _variID = [NSMutableArray array];
    }
    return self;
}

@end
