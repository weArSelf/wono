//
//  MapViewController.h
//  wonoAPP
//
//  Created by IF on 2017/7/19.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyLocationDelegate <NSObject>

//- (void)bannerImageClicked:(NSInteger)index ;
//- (void)confirmWithName:(NSString *)name AndLongitude:(NSString *)longitude AndLatitude:(NSString *)latitude;
- (void)confirmWithName:(NSString *)name AndLongitude:(NSString *)longitude AndLatitude:(NSString *)latitude AndCity:(NSString *)city AndAddress:(NSString *)address;
@end

@interface MapViewController : UIViewController

@property (nonatomic,weak) id<MyLocationDelegate> delegate;

@end
