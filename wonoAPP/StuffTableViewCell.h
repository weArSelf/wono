//
//  StuffTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/8/3.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StuffTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellClickBlock)(StuffTableViewCell *cell);

@property (nonatomic) BOOL changeMark;

@end
