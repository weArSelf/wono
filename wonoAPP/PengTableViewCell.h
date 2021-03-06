//
//  PengTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/8/4.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PengModel.h"

@interface PengTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellClickBlock)(PengTableViewCell *cell);

@property (nonatomic) BOOL changeMark;

@property (nonatomic,strong) PengModel *model;

@end
