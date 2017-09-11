//
//  WonoCircleModel.h
//  wonoAPP
//
//  Created by IF on 2017/7/17.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WonoCircleModel : NSObject

@property (nonatomic) int type;

//1 只有标题 2标题文字 3 标题图片 4 标题图片文字

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *positionStr;
@property (nonatomic,strong) NSString *answerCount;

@property (nonatomic,strong) NSString *askId;


@end
