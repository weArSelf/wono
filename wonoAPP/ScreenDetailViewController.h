//
//  ScreenDetailViewController.h
//  wonoAPP
//
//  Created by IF on 2017/8/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenDetailModel.h"

@protocol ScreenDetailDelegate <NSObject>

-(void)selectWithDic:(NSDictionary *)dic;

@end


@interface ScreenDetailViewController : UIViewController

@property (nonatomic,weak) id<ScreenDetailDelegate> delegate;

@end
