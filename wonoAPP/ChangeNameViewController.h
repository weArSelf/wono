//
//  ChangeNameViewController.h
//  wonoAPP
//
//  Created by IF on 2017/8/2.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeNameDelegate <NSObject>

-(void)nameChangedWithName:(NSString *)name;

@end

@interface ChangeNameViewController : UIViewController

@property (nonatomic,weak) id<changeNameDelegate>delegate;

@property (nonatomic,strong) NSString *needName;

@end
