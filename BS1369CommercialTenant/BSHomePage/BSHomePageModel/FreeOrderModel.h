//
//  FreeOrderModel.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/18.
//  Copyright © 2015年 UU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreeOrderModel : NSObject
//"200112121372",
@property (nonatomic,copy) NSString *OrderFree;
//"蓝钻KTV",
@property (nonatomic,copy) NSString *MerchName;
//2015-12-08 10:58:30",
@property (nonatomic,copy) NSString *PublishTime;
//"2015-12-12 10:04:40",
@property (nonatomic,copy) NSString *OrderDate;
// "18625607355",
@property (nonatomic,copy) NSString *MemberName;
// "2015-12-15 02:45:10"
@property (nonatomic,copy) NSString *BuyDate;

@end
