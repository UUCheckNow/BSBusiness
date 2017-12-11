//
//  XingbiRechargeTabCell.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/18.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "XingbiRechargeTabCell.h"

@implementation XingbiRechargeTabCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRechargepmodel:(RechargePresentModel *)rechargepmodel {
    self.dataLabel.text = [NSString stringWithFormat:@"充值日期：%@",[rechargepmodel valueForKey:@"buyDate"]];
    self.moneyLabel.text = [NSString stringWithFormat:@"充值金额：%@",[rechargepmodel valueForKey:@"bookedDate"]];
    self.numLabel.text = [NSString stringWithFormat:@"星币数量：%@",[rechargepmodel valueForKey:@"buyXbCount"]];
    self.payStylLab.text = [NSString stringWithFormat:@"支付方式：%@",[rechargepmodel valueForKey:@"PayWay"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
