//
//  XingbiRecordPreTabCell.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/18.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "XingbiRecordPreTabCell.h"

@implementation XingbiRecordPreTabCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecordpresentmodel:(RecordPresentModel *)recordpresentmodel {
    self.preUserNumLab.text = [NSString stringWithFormat:@"获赠用户账号：%@",[recordpresentmodel valueForKey:@"moblie"]];
    self.userPayMoneyNumLab.text = [NSString stringWithFormat:@"用户消费金额：￥%@.00",[recordpresentmodel valueForKey:@"cunsumeMoney"]];
    self.xingBiNumLab.text = [NSString stringWithFormat:@"赠送星币数量：%@.00",[recordpresentmodel valueForKey:@"xbcount"]];
    self.xingBiDateLab.text = [NSString stringWithFormat:@"星币赠送日期：%@",[recordpresentmodel valueForKey:@"createDate"]];
//    self.preUserNumLab.font = [UIFont systemFontOfSize:14];
    self.userPayMoneyNumLab.font = [UIFont systemFontOfSize:13];
    self.xingBiNumLab.font = [UIFont systemFontOfSize:13];
    self.xingBiDateLab.font = [UIFont systemFontOfSize:13];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
