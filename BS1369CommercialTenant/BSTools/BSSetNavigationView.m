//
//  BSSetNavigationView.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/16.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "BSSetNavigationView.h"
#import "Common.h"
#import <Masonry.h>
#import "FreeCodeQueryVC.h"

@interface BSSetNavigationView ()




@end

@implementation BSSetNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backButton = [UIButton buttonWithType:0];
        [self.backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton = [UIButton buttonWithType:0];
        [self.rightButton addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = REDCOLOR;
        self.rightButton.userInteractionEnabled = NO;
        [self addSubview:self.backButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.leading.equalTo(self.mas_leading).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.backButton.mas_centerY).with.offset(0);
    }];
    

    [super layoutSubviews];
}

- (void)backClick:(UIButton *)button {
    [self.delegateVC.navigationController popViewControllerAnimated:YES];
}

- (void)touchClick:(UIButton *)buton {
    FreeCodeQueryVC *freeVC = [[FreeCodeQueryVC alloc]init];
    [self.delegateVC.navigationController pushViewController:freeVC animated:YES];
}

//红底 白字 左按钮 中间title
+ (instancetype)navigationWithLeftImageName:(NSString *)leftImageName centerTitleName:(NSString *)titleName andFrame:(CGRect)frame {
    BSSetNavigationView *navg = [[BSSetNavigationView alloc ] initWithFrame:frame];
    [navg.backButton setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];//给button添加image
    navg.backButton.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8);
    navg.titleLabel.text = titleName;
    navg.titleLabel.textColor = [UIColor whiteColor];
    return navg;
}
//红底 白字 中间title
+(instancetype)navigationWithcenterTitleName:(NSString *)titleName andFrame:(CGRect)frame {
    BSSetNavigationView *nav = [[BSSetNavigationView alloc]initWithFrame:frame];
    nav.titleLabel.text = titleName;
    nav.titleLabel.textColor = [UIColor whiteColor];
    return nav;
}
//白底 黑字 左按钮 中间title 右按钮
+(instancetype)navigationWithLeftImageName:(NSString *)leftImageName centerTitleName:(NSString *)titleName RightImageName:(NSString *)RightImageName andFrame:(CGRect)frame {
    BSSetNavigationView *navg = [[BSSetNavigationView alloc ] initWithFrame:frame];
    
    [navg.backButton setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];//给button添加image
    navg.backButton.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8);

    [navg.rightButton setImage:[UIImage imageNamed:RightImageName] forState:0];
    navg.rightButton.imageEdgeInsets = UIEdgeInsetsMake(8,8,8,8);
    navg.backgroundColor = [UIColor whiteColor];
    navg.titleLabel.text = titleName;
    return navg;
}

@end
