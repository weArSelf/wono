//
//  BaseTabBarController.m
//  wonoAPP
//
//  Created by IF on 2017/7/11.
//  Copyright © 2017年 IF. All rights reserved.
//

#import "BaseTabBarController.h"

#import "PlantControllViewController.h"
#import "StatisticsViewController.h"
#import "TempViewController.h"
#import "WonoCircleViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "BaseNavViewController.h"

#import "KBTabbar.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong)KBTabbar *tabbar;

@end

@implementation BaseTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.tabBar.tintColor = UIColorFromHex(0x5ab97e);
    
    self.tabBarController.delegate = self;
    
    self.delegate = self;
    
    PlantControllViewController *plant = [[PlantControllViewController alloc]init];
    
    
    BaseNavViewController *nav1 = [[BaseNavViewController alloc]initWithRootViewController:plant];
    nav1.tabBarItem.title = @"种植管理";
//    nav1.tabBarController.tabBar.tintColor = [UIColor greenColor];
    nav1.tabBarItem.image = [UIImage imageNamed:@"种植"];
    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"种植-selected"];
    
    //    plant.tabBarItem.image = [UIImage imageNamed:@""];
    //    plant.tabBarItem.selectedImage = [UIImage imageNamed:@""];
    
    StatisticsViewController *sta = [[StatisticsViewController alloc]init];
    
    
    BaseNavViewController *nav2 = [[BaseNavViewController alloc]initWithRootViewController:sta];
    nav2.tabBarItem.title = @"数据统计";
    nav2.tabBarItem.image = [UIImage imageNamed:@"数据统计"];
    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"数据统计-selected"];
    
    TempViewController *temp = [[TempViewController alloc]init];
    
    
    BaseNavViewController *nav3 = [[BaseNavViewController alloc]initWithRootViewController:temp];
    nav3.tabBarItem.title = @"";
//    nav3.tabBarItem.image = [UIImage imageNamed:@"种植"];
//    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"种植-selected"];
    
    
    WonoCircleViewController *wono = [[WonoCircleViewController alloc]init];
    
    
    BaseNavViewController *nav4 = [[BaseNavViewController alloc]initWithRootViewController:wono];
    nav4.tabBarItem.title = @"农知道";
    nav4.tabBarItem.image = [UIImage imageNamed:@"沃农圈"];
    nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"沃农圈-selected"];
    
    
    MineViewController *mine = [[MineViewController alloc]init];
    
    
    BaseNavViewController *nav5 = [[BaseNavViewController alloc]initWithRootViewController:mine];
    nav5.tabBarItem.title = @"我的";
    nav5.tabBarItem.image = [UIImage imageNamed:@"我的"];
    nav5.tabBarItem.selectedImage = [UIImage imageNamed:@"我的-selected"];
    
  
    
    self.viewControllers=@[nav1,nav2,nav4,nav5,nav3];
   
    //    base.viewControllers = @[plant,ta,temp,wono,mine];
    
    //    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = self;
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    //  设置tabbar
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [self setCustomtabbar];
}


- (void)setCustomtabbar{
    
    _tabbar = [[KBTabbar alloc]init];
    _tabbar.tintColor = UIColorFromHex(0x5ab97e);
    _tabbar.delegate = self;
    [self setValue:_tabbar forKeyPath:@"tabBar"];
    
    [_tabbar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectedIndex = 4;
    
    _tabbar.centerBtn.selected = YES;
    
    
}

- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }forState:UIControlStateSelected];
    
    UINavigationController* nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}

- (void)centerBtnClick:(UIButton *)btn{
    
    
    NSLog(@"点击了中间");
    
    self.selectedIndex = 4;
    
    btn.selected = YES;
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点击了中间按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //
    //    [alert show];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex==4) {
        _tabbar.centerBtn.selected=YES;
    }else
    {
        _tabbar.centerBtn.selected=NO;
    }
}




@end
