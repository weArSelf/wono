//
//  MyZView.h
//  wonoAPP
//
//  Created by IF on 2017/8/1.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointModel.h"

@interface MyZView2 : UIView

@property (nonatomic,strong) NSMutableArray *dataArr;
- (instancetype)initWithFrame:(CGRect)frame AndData:(NSMutableArray *)arr;

-(void)changeTitle;

@property (nonatomic) float maxVal;
@property (nonatomic) float minVal;

@end
