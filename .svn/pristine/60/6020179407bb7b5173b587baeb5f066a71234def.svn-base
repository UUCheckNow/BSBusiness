//
//  AlipayRequestConfig.m
//  ytx
//
//  Created by valor on 15/11/16.
//  Copyright © 2015年 Valor. All rights reserved.
//

#import "AlipayRequestConfig.h"
#import "MBProgressHUD+MJ.h"

@implementation AlipayRequestConfig


// 仅含有变化的参数
+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL{
    [self alipayWithPartner:partner seller:seller tradeNO:tradeNO productName:productName productDescription:productDescription amount:amount notifyURL:notifyURL service:@"mobile.securitypay.pay" paymentType:@"1" inputCharset:@"utf-8" itBPay:@"30m" privateKey:kPrivateKey appScheme:kAppScheme];
}

+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                  service:(NSString *)service
              paymentType:(NSString *)paymentType
             inputCharset:(NSString *)inputCharset
                   itBPay:(NSString *)itBPay
               privateKey:(NSString *)privateKey
                appScheme:(NSString *)appScheme{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    //商品标题
    order.productName = productName;
    //商品描述
    order.productDescription = productDescription;
    //商品价格
    order.amount = amount;
    
#pragma mark 疑问1.
    order.notifyURL =  notifyURL; //回调URL
    
    //以下配置信息是默认信息,不需要更改.
    order.service = service;
    order.paymentType = paymentType;
    order.inputCharset = inputCharset;
    order.itBPay = itBPay;
    
    // 将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"%@",orderSpec);
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    NSString *signedString = [self genSignedStringWithPrivateKey:kPrivateKey OrderSpec:orderSpec];
    
    // 调用支付接口
    [self payWithAppScheme:appScheme orderSpec:orderSpec signedString:signedString];
}

// 生成signedString
+ (NSString *)genSignedStringWithPrivateKey:(NSString *)privateKey OrderSpec:(NSString *)orderSpec {
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    return [signer signString:orderSpec];
}

// 支付
+ (void)payWithAppScheme:(NSString *)appScheme orderSpec:(NSString *)orderSpec signedString:(NSString *)signedString {

    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = -----------------%@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [MBProgressHUD showError:@"订单支付成功"];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
                [MBProgressHUD showError:@"正在处理中"];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                [MBProgressHUD showError:@"订单支付失败"];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                [MBProgressHUD showError:@"用户中途取消"];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                [MBProgressHUD showError:@"网络连接出错"];
            }
        }];
    }
    
}

@end

@implementation AlipayToolKit

+ (NSString *)genTradeNoWithTime {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    //字符串的转化并且拼接
    NSString *yearstr=[NSString stringWithFormat:@"%ld",(long)year];
    NSString *monthstr=[NSString stringWithFormat:@"%02ld",(long)month];
    NSString *daystr=[NSString stringWithFormat:@"%02ld",(long)day];
    NSString *hourstr=[NSString stringWithFormat:@"%02ld",(long)hour];
    NSString *minutestr=[NSString stringWithFormat:@"%02ld",(long)minute];
    NSString *secondstr=[NSString stringWithFormat:@"%02ld",(long)second];
    NSInteger number5 = arc4random()%99999 + 10000;
    //字符串开始拼接
    NSString *allstr=[yearstr stringByAppendingString:monthstr];
    NSString *allstr1=[allstr stringByAppendingString:daystr];
    NSString *allstr2=[allstr1 stringByAppendingString:hourstr];
    NSString *allstr3=[allstr2 stringByAppendingString:minutestr];
    NSString *DateTime=[allstr3 stringByAppendingString:secondstr];
    NSString *lastTime=[DateTime stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)number5]];
    return lastTime;
}

@end
