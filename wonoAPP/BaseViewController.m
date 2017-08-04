//
//  BaseViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/14.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)CreateTitleLabelWithText:(NSString *)text{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.text = text;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    CGSize size=[text sizeWithAttributes:attrs];
    _titleLabel.frame = CGRectMake((APP_CONTENT_WIDTH-size.width)/2, 0, size.width, 46);
    [self.navigationController.navigationBar addSubview:_titleLabel];
}


@end
