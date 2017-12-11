//
//  StaticChangeView.h
//  wonoAPP
//
//  Created by IF on 2017/11/20.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticChangeView : UIView

@property (nonatomic,strong) NSMutableDictionary *model;

-(float)needToReturnHeightWithModel:(NSString *)model;

-(void)changeScrollViewWithState:(int)state;

-(void)needtoreload;

@end
