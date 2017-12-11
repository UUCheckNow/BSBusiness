//
//  Common.h
//  BS1369
//
//  Created by 张玉 on 15/11/17.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#ifndef Common_h
#define Common_h


//定义屏幕的宽和高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//有关首页的背景
#define BgColor    [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]
//红色
#define REDCOLOR    [UIColor colorWithRed:247.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1]
//灰色
#define GRAYCOLOR   [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1]

//保存字典
//@{@"code":cityCode,
//@"name":cityName};
#define kHomePageAddressCode    @"homePageAddressCode"

#endif /* Common_h */
