//
//  StuffTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/8/3.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface StuffTableViewCell : UITableViewCell

@property (nonatomic,copy) void(^cellClickBlock)(StuffTableViewCell *cell);

@property (nonatomic) BOOL changeMark;

@property (nonatomic,strong) SearchModel *searchModel;

@property (nonatomic) BOOL selectMark;


-(void)changeColor;

-(void)changeColorBack;

@end
