//
//  MyMapTableViewCell.h
//  wonoAPP
//
//  Created by IF on 2017/12/8.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

typedef void (^AddressSelectBlock)(NSString *address);

@interface MyMapTableViewCell : UITableViewCell

@property(nonatomic,strong)BMKReverseGeoCodeResult *res;

@property (nonatomic,strong) UITextView *posiTextView;

-(float)needReturnHeight;

@property (nonatomic,copy) AddressSelectBlock addressBlock;

@end
