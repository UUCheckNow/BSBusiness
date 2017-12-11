//
//  BSUtils.h
//  BS1369
//
//  Created by nyhz on 15/11/25.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUtils : NSObject
#pragma mark 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma mark 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma  mark 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma  mark 正则匹配用户姓名,20位的中文或英文 全部汉字
+ (BOOL)checkname : (NSString *) userName;

#pragma mark 数字 汉子 字母
+ (BOOL)checkDetailname : (NSString *) userDetail;

#pragma  mark 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
@end
