//
//  BSGoodsManageTabCell.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 16/3/16.
//  Copyright © 2016年 UU. All rights reserved.
//

#import "BSGoodsManageTabCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BSGoodsManageTabCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setGoodsmanagemodel:(GoodsManageModel *)goodsmanagemodel {
    _goodsmanagemodel = goodsmanagemodel;
    [self.iconimageview sd_setImageWithURL:[NSURL URLWithString:[_goodsmanagemodel valueForKey:@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"default"]];
    
    self.titleNameLab.text = [_goodsmanagemodel valueForKey:@"GoodName"];
    self.GoodsCount.text = [_goodsmanagemodel valueForKey:@"inventory"];
    self.gavePriceLabel.text = [NSString stringWithFormat:@"供应价：￥%@",[_goodsmanagemodel valueForKey:@"BuyingPrice"]];
    self.GoodsEffectiveTime.text = [_goodsmanagemodel valueForKey:@"GoodsValidity"];
    self.addTimeLab.text = [_goodsmanagemodel valueForKey:@"CreateTime"];
    self.sellCount.text = [_goodsmanagemodel valueForKey:@"SellCount"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
