//
//  WonoAskTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/9/4.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WonoAskModel.h"

@interface WonoAskTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellBlock)(NSDictionary *dic);

@property (nonatomic,strong) WonoAskModel *model;

@end
