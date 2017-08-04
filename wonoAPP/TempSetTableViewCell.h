//
//  TempSetTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/7/26.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SetModel.h"

@interface TempSetTableViewCell : UITableViewCell

@property (nonatomic,strong) SetModel *model;

-(void)changeColor;
-(void)changeBackColor;

@property (nonatomic,strong) UIView *ConView;

@property (nonatomic) BOOL selectMark;

@end
