//
//  MyTextViewController.m
//  wonoAPP
//
//  Created by IF on 2017/9/19.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "MyTextViewController.h"

@interface MyTextViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong)UIPageViewController *pageVC;

@end

@implementation MyTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

//-(void)createPage{
////    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey:UIPageViewControllerOptionSpineLocationKey];
//    _pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    _pageVC.dataSource = self;
//    _pageVC.delegate = self;
//    
//}
//
//- (void)setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion{
//    
//}
//
//- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
//    
//}
//- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
//    
//}

@end
