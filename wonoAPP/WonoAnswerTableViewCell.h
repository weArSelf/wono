//
//  WonoAnswerTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/9/5.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WonoAnswerModel.h"

typedef void (^audioPlayBlock)(NSString *audioUrl);

@interface WonoAnswerTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellBlock)(NSDictionary *dic);

@property (nonatomic,strong) WonoAnswerModel *model;

@property (nonatomic,strong) NSString *changeMark;

@property (nonatomic,copy) audioPlayBlock audioBlo;

-(void)reloadTitle;

@end
