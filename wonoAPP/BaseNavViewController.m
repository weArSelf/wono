//
//  BaseNavViewController.m
//  wonoAPP
//
//  Created by IF on 2017/7/14.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "BaseNavViewController.h"
//#import "UIFont+Font.h"

@interface BaseNavViewController ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backColor"]];
    
    
    
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.barTintColor = UIColorFromHex(0x4cb566);
//    self.navigationBar.alpha = 1;
    
    
}

-(void)CreateTitleLabelWithText:(NSString *)text{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = text;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.frame = CGRectMake(150, 0, APP_CONTENT_WIDTH-300, 46);
    [self.navigationBar addSubview:_titleLabel];
}


@end
