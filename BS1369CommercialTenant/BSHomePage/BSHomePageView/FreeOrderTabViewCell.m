//
//  FreeOrderTabViewCell.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/18.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "FreeOrderTabViewCell.h"

@implementation FreeOrderTabViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setFreeordermodel:(GoodsManageModel *)freeordermodel {
    
    self.label1.text = [NSString stringWithFormat:@"消费密码:%@",[freeordermodel valueForKey:@"BuyBH"]];
    self.label2.text = [NSString stringWithFormat:@"商品名称:%@",[freeordermodel valueForKey:@"GoodName"]];
    self.label6.text = [NSString stringWithFormat:@"商品编号:%@",[freeordermodel valueForKey:@"GoodCode"]];
    self.label3.text = [NSString stringWithFormat:@"订单编号:%@",[freeordermodel valueForKey:@"OrderBH"]];
    self.label4.text = [NSString stringWithFormat:@"消费时间:%@",[freeordermodel valueForKey:@"BuyDate"]];
    self.label5.text = [NSString stringWithFormat:@"购买用户:%@",[freeordermodel valueForKey:@"Moblie"]];

    self.bgImageView.layer.cornerRadius = 15;
    
    self.bgImageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
