//
//  WonoAnswerModel.h
//  wonoAPP
//
//  Created by IF on 2017/9/1.
//  Copyright © 2017年 IF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WonoAnswerModel : NSObject

@property (nonatomic) int type;

//1 只有内容 2只有语音 3只有图片 4内容+图片 5内容+语音 6语音+图片 7内容+语音+图片


//1 只有标题 2标题文字 3 标题图片 4 标题图片文字

//@property (nonatomic,strong) NSString *titleStr;


@property (nonatomic,strong) NSString *headUrl;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *time;
//@property (nonatomic,strong) NSString *sujjestCount;


@property (nonatomic,strong) NSString *contentStr;
//@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *positionStr;
//@property (nonatomic,strong) NSString *answerCount;

@property (nonatomic,strong) NSString *audioUrl;
@property (nonatomic,strong) NSString *audioLength;



@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,strong) NSString *answerId;

@property (nonatomic,strong) NSString *replyName;

@end


















































