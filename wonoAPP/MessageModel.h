//
//  MessageModel.h
//  wonoAPP
//
//  Created by IF on 2017/9/6.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic) int type;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *needID;


@end
