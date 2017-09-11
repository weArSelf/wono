//
//  WonoCircleTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WonoCircleModel.h"

@interface WonoCircleTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellBlock)(NSDictionary *dic);

@property (nonatomic,strong) WonoCircleModel *model;

@property (nonatomic,strong) NSString *changeMark;

@end
