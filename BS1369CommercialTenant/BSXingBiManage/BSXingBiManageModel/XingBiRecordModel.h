//
//  XingBiRecordModel.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/26.
//  Copyright © 2015年 UU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XingBiRecordModel : NSObject

//"345" --用户的ID
@property (nonatomic,copy) NSString *id;
//"24"  --用户密码
@property (nonatomic,copy) NSString *mobile;
//"M315710049736" 用户名称
@property (nonatomic,copy) NSString *mName;
//"卧龙玉液" -城市
@property (nonatomic,copy) NSString *city;
//"2015-09-29 03:33:46" --地址
@property (nonatomic,copy) NSString *address;


@end
