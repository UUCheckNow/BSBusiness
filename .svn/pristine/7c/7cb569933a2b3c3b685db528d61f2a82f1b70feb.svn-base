//
//  BSSetNavigationView.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/16.
//  Copyright © 2015年 UU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSSetNavigationView : UIView

@property (nonatomic,strong)UIViewController *delegateVC;

@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) UILabel *titleLabel;

//左边返回和中间title
+ (instancetype)navigationWithLeftImageName:(NSString *)leftImageName centerTitleName:(NSString *)titleName andFrame:(CGRect)frame;

//左边返回和中间title和右边按钮
+ (instancetype)navigationWithLeftImageName:(NSString *)leftImageName centerTitleName:(NSString *)titleName RightImageName:(NSString *)RightImageName andFrame:(CGRect)frame;

//只有中间title
+ (instancetype)navigationWithcenterTitleName:(NSString *)titleName andFrame:(CGRect)frame;

@end
