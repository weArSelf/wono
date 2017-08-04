//
//  HDTimerBtn.m
//  udo_stu
//
//  Created by xiaoli on 16/6/27.
//  Copyright © 2016年 HowDo. All rights reserved.
//

#import "HDTimerBtn.h"

#define GetSMSWaitSecond      30

@interface HDTimerBtn()
{
    NSTimer * timer;
    NSInteger count;
}

@end
@implementation HDTimerBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.enabled = YES;
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)dealloc
{
    [timer invalidate];
    timer =nil;
}

-(void)addTimer
{
    [timer invalidate];
    count = GetSMSWaitSecond;
    timer = nil;
    if (timer == nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateBtnTitle) userInfo:nil repeats:YES];
        [timer fire];
    }
}

-(void)updateBtnTitle
{
    if (count > 0)
    {
        NSString * str = [NSString stringWithFormat:@"%ld秒后再次发送",(long)count];
        count --;
        [self setTitle:str forState:UIControlStateNormal];
        self.enabled = NO;
        [self setBackgroundColor:[UIColor colorWithRed:163.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1.0]];
    }
    else
    {
        [timer invalidate];
        timer = nil;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.enabled = YES;
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
}

@end
