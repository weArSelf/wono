//
//  PlantCell.h
//  wonoAPP
//
//  Created by IF on 2017/7/14.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlantModel.h"

@interface PlantCell : UITableViewCell

-(void)creatConView;

-(void)setLeftColor:(UIColor *)color;

//-(void)setPlantModel:(PlantModel *)model;

@property (nonatomic,strong) PlantModel *model;

@end
