//
//  ViewController.m
//  折线图
//
//  Created by iOS on 16/6/28.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "ViewController.h"
#import "ZXView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    ZXView * zx = [[ZXView alloc]initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 250)];
    
    [self.view addSubview:zx];
    // Do any additional setup after loading the view, typically from a nib.
    zx.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
