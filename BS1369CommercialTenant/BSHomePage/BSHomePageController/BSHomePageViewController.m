//
//  BSHomePageViewController.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/16.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "BSHomePageViewController.h"
#import "BSSetNavigationView.h"
#import "Common.h"
#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD.h"

#import "MyMD5.h"
#import "BSparam.h"
#import "BSHttpTool.h"

#import "BSHomePageModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "FreeOrderVC.h"
#import "FreeCodeQueryVC.h"
#import "XingbiRechargeVC.h"

#import "BSLoginVC.h"

@interface BSHomePageViewController () {
    BOOL selected;
}

@property(nonatomic,strong) BSparam *bsparam;

@property(nonatomic,strong) BSHomePageModel *homepagemodel;

@end

@implementation BSHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    
    [self createView];
    
    [self getDataFromNet];
    
}

- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithcenterTitleName:@"首页" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navg.delegateVC = self;
    
    [self.view addSubview:navg];
}

- (void)getDataFromNet {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _bsparam = [[BSparam alloc]init];
    
    _bsparam.name = [userDefaults objectForKey:@"loginTel"];
    _bsparam.pwdUrlMd5 = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
    
    [BSHttpTool POST:@"login" parameters:_bsparam success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            _homepagemodel = responseObject[@"info"];
            UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+8, ScreenWidth, ((ScreenHeight-64-50)-3*8)/2)];
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:[_homepagemodel valueForKey:@"headImg"]] placeholderImage:[UIImage imageNamed:@"default"]];
            [self.view addSubview:headerImageView];
        }else{
            [MBProgressHUD showError:responseObject[@"code_text"]];
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            selected =[userDefaults boolForKey:@"btnKey"];
            //    NSLog(@"%d",selected);
            if (!selected) {
                [userDefaults removeObjectForKey:@"loginName"];
                [userDefaults removeObjectForKey:@"Password"];
            }
            
            BSLoginVC *loginController = [[BSLoginVC alloc]init];
            
            [self presentViewController:loginController animated:YES completion:^{
                
            }];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createView {
    CGFloat margin = 8;
    CGFloat Width = (ScreenWidth-3*8)/2;
    CGFloat Height = ((ScreenHeight-64-50)-3*margin)/2;
    CGFloat headerMargin = 64+8;
    
    //   免费订单管理
    UIButton *freeOrderManage = [UIButton buttonWithType:0];
    freeOrderManage.frame = CGRectMake(margin, headerMargin+Height+8, Width+2, Height);
    UIButton *whiteBtn = [UIButton buttonWithType:0];
    whiteBtn.userInteractionEnabled = NO;
    whiteBtn.layer.cornerRadius = 35;
    whiteBtn.clipsToBounds = YES;
    whiteBtn.frame = CGRectMake((Width-70)/2, (Height-70)/3, 70, 70);
    whiteBtn.backgroundColor = [UIColor whiteColor];
    [freeOrderManage addSubview:whiteBtn];
    UIFont *iconfont = [UIFont fontWithName:@"IconFont" size: 50];
    whiteBtn.titleLabel.font = iconfont;
    [whiteBtn setTitle:@"\U0000e60c" forState:0];
    [whiteBtn setTitleColor:REDCOLOR forState:0];
    
    UILabel *titlab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteBtn.frame), CGRectGetWidth(freeOrderManage.frame), 30)];
    titlab.textAlignment = NSTextAlignmentCenter;
    titlab.text = @"消费密码验证";
    titlab.font = [UIFont systemFontOfSize:14];
    titlab.textColor = [UIColor whiteColor];
    [freeOrderManage addSubview:titlab];
    
    freeOrderManage.backgroundColor = REDCOLOR;
    [freeOrderManage addTarget:self action:@selector(goTofreeOrderManage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:freeOrderManage];
    //    验证消费密码
    UIButton *freeCodeQuery = [UIButton buttonWithType:0];
    freeCodeQuery.frame = CGRectMake(Width+2*margin-2, headerMargin+Height+8,(ScreenWidth/2)-2*margin+6, Height/2-2);
    
    UIButton *white1Btn = [UIButton buttonWithType:0];
    white1Btn.userInteractionEnabled = NO;
    white1Btn.layer.cornerRadius = 20;
    white1Btn.clipsToBounds = YES;
    white1Btn.frame = CGRectMake(((ScreenWidth/2)-2*margin-40)/2, (Height/2-40)/4, 40, 40);
    white1Btn.backgroundColor = [UIColor whiteColor];
    [freeCodeQuery addSubview:white1Btn];
    UIFont *icon1font = [UIFont fontWithName:@"IconFont" size: 30];
    white1Btn.titleLabel.font = icon1font;
    [white1Btn setTitle:@"\U0000e610" forState:0];
    [white1Btn setTitleColor:[UIColor colorWithRed:170/255.0 green:144/255.0 blue:217/255.0 alpha:1] forState:0];
    
    UILabel *titlab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(white1Btn.frame), CGRectGetWidth(freeCodeQuery.frame), 30)];
    titlab1.textAlignment = NSTextAlignmentCenter;
    titlab1.text = @"星币购消费记录";
    titlab1.font = [UIFont systemFontOfSize:14];
    titlab1.textColor = [UIColor whiteColor];
    [freeCodeQuery addSubview:titlab1];
    
    freeCodeQuery.backgroundColor = [UIColor colorWithRed:170/255.0 green:144/255.0 blue:217/255.0 alpha:1];
    [freeCodeQuery addTarget:self action:@selector(goTofreeCodeQuery:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:freeCodeQuery];
    //    星币充值
    UIButton *XingbiRecharge = [UIButton buttonWithType:0];
    XingbiRecharge.frame = CGRectMake(Width+2*margin-2, headerMargin+Height+2*margin+Height/2-6,(ScreenWidth/2)-2*margin+6, Height/2-2);
    
    UIButton *white2Btn = [UIButton buttonWithType:0];
    white2Btn.userInteractionEnabled = NO;
    white2Btn.layer.cornerRadius = 20;
    white2Btn.clipsToBounds = YES;
    [white2Btn setImage:[UIImage imageNamed:@"星币"] forState:UIControlStateNormal];//给button添加image
    white2Btn.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8);
    white2Btn.frame = CGRectMake(((ScreenWidth/2)-2*margin-40)/2, (Height/2-40)/4, 40, 40);
    white2Btn.backgroundColor = [UIColor whiteColor];
    [XingbiRecharge addSubview:white2Btn];

    
    UILabel *titlab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(white2Btn.frame), CGRectGetWidth(XingbiRecharge.frame), 30)];
    titlab2.textAlignment = NSTextAlignmentCenter;
    titlab2.text = @"赚星币消费记录";
    titlab2.font = [UIFont systemFontOfSize:14];
    titlab2.textColor = [UIColor whiteColor];
    [XingbiRecharge addSubview:titlab2];
    
    XingbiRecharge.backgroundColor = [UIColor colorWithRed:101/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    [XingbiRecharge addTarget:self action:@selector(goToXingbiRecharge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:XingbiRecharge];
    
}
//跳转到消费密码验证
- (void)goTofreeOrderManage:(UIButton *)button {
    
    FreeCodeQueryVC *freecodequeryvc = [[FreeCodeQueryVC alloc]init];
    freecodequeryvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:freecodequeryvc animated:YES];
}
//跳转到星币购消费记录
- (void)goTofreeCodeQuery:(UIButton *)button {
    
    FreeOrderVC *freeordervc = [[FreeOrderVC alloc]init];
    freeordervc.hidesBottomBarWhenPushed = YES;
    freeordervc.title = @"星币购消费记录";
    freeordervc.positionnn = @"1";
    [self.navigationController pushViewController:freeordervc animated:YES];
}
//跳转到赚星币消费记录
- (void)goToXingbiRecharge:(UIButton *)button {
    
    FreeOrderVC *freeordervc = [[FreeOrderVC alloc]init];
    freeordervc.hidesBottomBarWhenPushed = YES;
    freeordervc.title = @"赚星币消费记录";
    freeordervc.positionnn = @"2";
    [self.navigationController pushViewController:freeordervc animated:YES];
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
