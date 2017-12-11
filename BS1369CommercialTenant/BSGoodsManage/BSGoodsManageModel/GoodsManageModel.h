//
//  GoodsManageModel.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 16/3/16.
//  Copyright © 2016年 UU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsManageModel : NSObject

//"2016-03-19 09:57:02",//有效期
@property (nonatomic,copy) NSString *GoodsValidity;
//"oio",//商品名
@property (nonatomic,copy) NSString *GoodName;
//"/bsimages/business/xbgoods/20160315095655_9868.png",//图片
@property (nonatomic,copy) NSString *imgsrc;
//"2016-03-15 09:57:08",//添加时间
@property (nonatomic,copy) NSString *CreateTime;
//"2",//库存
@property (nonatomic,copy) NSString *inventory;
//"5",//售出量
@property (nonatomic,copy) NSString *SellCount;
////供货价
@property (nonatomic,copy) NSString *BuyingPrice;
//"46",//商品ID
@property (nonatomic,copy) NSString *goodId;
// "2438"//商户ID
@property (nonatomic,copy) NSString *BusinessID;

@end
