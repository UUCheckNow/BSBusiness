//
//  BSXingBiManageViewController.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/16.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "BSXingBiManageViewController.h"
#import "BSSetNavigationView.h"
#import "Common.h"

#import "XingbiRecordVC.h"
#import "XingbiRecordPresentVC.h"
#import "XingbiRechargeVC.h"
#import "XingbiRechargePresentVC.h"



@interface BSXingBiManageViewController ()

@end

@implementation BSXingBiManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self setView];
}

- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithcenterTitleName:@"星币管理" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [self.view addSubview:navg];
}

- (void)setView {
    CGFloat margin = 0;
    CGFloat margin1 = (ScreenWidth - 50*2)/3;
    CGFloat margin2 = (ScreenWidth - 100*2)/3;
    
    for (int i = 0; i < 4; i++) {
        
//        button
        UIButton *buttons = [UIButton buttonWithType:0];
        
        buttons.tag = 200+i;
        
        CGRect rect = {{margin + (margin + ScreenWidth/2)*(i%2),64 + (ScreenWidth/3+margin)*(i/2) }, {ScreenWidth/2, ScreenWidth/3}};
        
        buttons.frame = rect;
        
        buttons.layer.borderWidth = 0.4;
        
        buttons.layer.borderColor = [[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1] CGColor];
        
        [buttons addTarget:self action:@selector(touchActions:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:buttons];
        
//        imageView
        NSArray *nameArray = @[@"\U0000e60f",@"\U0000e60a",@"\U0000e60b",@"\U0000e60e"];
        UIButton *imageview = [UIButton buttonWithType:0];
        imageview.userInteractionEnabled = NO;
        CGRect rect1 = {{margin1-20 + (margin1+39 + 50)*(i%2), ScreenWidth/3-30  + (35+margin1)*(i/2)}, {50, 50}};
        
        imageview.frame = rect1;
        if (i == 0) {
            imageview.backgroundColor = [UIColor colorWithRed:185/255.0 green:166/255.0 blue:223/255.0 alpha:1];
        }else if (i == 1) {
        imageview.backgroundColor = REDCOLOR;
        }else if (i == 2){
            imageview.backgroundColor = [UIColor orangeColor];
        }else {
            imageview.backgroundColor = [UIColor colorWithRed:101/255.0 green:199/255.0 blue:209/255.0 alpha:1];
        }
        imageview.layer.cornerRadius = 25;
        
        imageview.clipsToBounds = YES;
        
        UIFont *iconfont = [UIFont fontWithName:@"IconFont" size: 30];
        imageview.titleLabel.font = iconfont;
        [imageview setTitle:nameArray[i] forState:0];
        [imageview setTitleColor:[UIColor whiteColor] forState:0];
        
        [self.view addSubview:imageview];
        
//        label
        NSArray *labelArr = @[@"星币赠送",@"星币充值",@"星币赠送记录",@"星币充值记录"];
        UILabel *titleLabs = [[UILabel alloc]init];
        
        CGRect rect2 = {{margin2-10 + (margin2+20 + 100)*(i%2), ScreenWidth/3 + 30 + (70+margin2)*(i/2) }, {100, 20}};
        
        titleLabs.frame = rect2;
        
        titleLabs.text = labelArr[i];
        
        titleLabs.textAlignment = NSTextAlignmentCenter;
        
        titleLabs.font = [UIFont systemFontOfSize:14];
        
        [self.view addSubview:titleLabs];
        
        
    }
}

- (void)touchActions:(UIButton *)buttons {
    
    UIButton *btns = [self.view viewWithTag:buttons.tag];
    switch (btns.tag - 200) {
        case 0:
        {
            XingbiRecordVC *xingbipresentvc = [[XingbiRecordVC alloc]init];
            xingbipresentvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xingbipresentvc animated:YES];
        }
            break;
        case 1:
        {
            XingbiRechargeVC *xingbipresentrecordvc = [[XingbiRechargeVC alloc]init];
            xingbipresentrecordvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xingbipresentrecordvc animated:YES];
        }
            break;
        case 2:
        {
            XingbiRecordPresentVC *xingbirechargevc = [[XingbiRecordPresentVC alloc]init];
            xingbirechargevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xingbirechargevc animated:YES];
        }
            break;
        case 3:
        {
            XingbiRechargePresentVC *xingbirechargepresentvc = [[XingbiRechargePresentVC alloc]init];
            xingbirechargepresentvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xingbirechargepresentvc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
