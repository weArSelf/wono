//
//  NeedSelectionViewController.h
//  wonoAPP
//
//  Created by IF on 2017/8/7.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef enum : NSUInteger {
    zhandiStyle,
    dapengStyle,
    yuangongStyle,
} FarmStyle;

@protocol SelectDelegate <NSObject>

-(void)clickConfirmWithType:(FarmStyle)type AndStr:(NSString *)str;

@end


@interface NeedSelectionViewController : UIViewController

-(void)changeStyle:(FarmStyle)style;

@property (nonatomic, weak) id<SelectDelegate> delegate;

@end
