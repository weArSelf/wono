//
//  MainPlantModel.h
//  wonoAPP
//
//  Created by IF on 2017/8/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainPlantModel : NSObject

@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *fid;
@property (nonatomic)        int page;
@property (nonatomic)        int per_page;
@property (nonatomic,strong) NSString *uid;

@end
