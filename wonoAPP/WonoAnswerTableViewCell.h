//
//  WonoAnswerTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/9/5.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WonoAnswerModel.h"

@interface WonoAnswerTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellBlock)(NSDictionary *dic);

@property (nonatomic,strong) WonoAnswerModel *model;

@property (nonatomic,strong) NSString *changeMark;

@end
