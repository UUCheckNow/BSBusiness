//
//  BSToorbarViewController.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/16.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "BSToorbarViewController.h"

#import "BSHomePageViewController.h"
#import "BSXingBiManageViewController.h"
#import "BSGoodsManageVC.h"
#import "BSMyAccountViewController.h"

#import "UIImage+Image.h"

@interface BSToorbarViewController ()

@end

@implementation BSToorbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  setUpAllChildViewController];
    
}
//添加子控制器
-(void)setUpAllChildViewController{
    BSHomePageViewController *HomePageController = [[BSHomePageViewController alloc]init ];
    [self setUpOneChildViewcontroller:HomePageController image:[UIImage imageNamed:@"home_n"] selectedImage:[UIImage imageWithOriginalName:@"home_s"] title:@"主页"];
    
    BSXingBiManageViewController *AlwaysSendViewController =[[BSXingBiManageViewController alloc]init];
    
    [self setUpOneChildViewcontroller:AlwaysSendViewController image:[UIImage imageNamed:@"send_n"] selectedImage:[UIImage imageWithOriginalName:@"send_s"] title:@"星币管理"];
    
    BSGoodsManageVC *BSGoodsManageViewController =[[BSGoodsManageVC alloc]init];
    
    [self setUpOneChildViewcontroller:BSGoodsManageViewController image:[UIImage imageNamed:@"shop_n"] selectedImage:[UIImage imageWithOriginalName:@"shop_s"] title:@"商品管理"];
    
    BSMyAccountViewController *BSUserCenterViewController =[[BSMyAccountViewController alloc]init];
    
    [self setUpOneChildViewcontroller:BSUserCenterViewController image:[UIImage imageNamed:@"user_n"] selectedImage:[UIImage imageWithOriginalName:@"user_s"] title:@"我的账户"];
    
    
    //
}
//添加所有的子控制器
-(void)setUpOneChildViewcontroller:(UIViewController *)controller image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    
    
    
    controller.tabBarItem.title = title;
    
    controller.tabBarItem.image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    controller.tabBarItem.badgeValue=@"10";
    controller.tabBarItem.selectedImage = selectedImage;
    
    UINavigationController *bsnvc = [[UINavigationController alloc]initWithRootViewController:controller];
    [self addChildViewController:bsnvc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
