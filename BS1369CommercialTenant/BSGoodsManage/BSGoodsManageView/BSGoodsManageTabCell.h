//
//  BSGoodsManageTabCell.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 16/3/16.
//  Copyright © 2016年 UU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsManageModel.h"

@interface BSGoodsManageTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconimageview;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *gavePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodsEffectiveTime;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *GoodsCount;
@property (weak, nonatomic) IBOutlet UILabel *sellCount;

@property (nonatomic,strong) GoodsManageModel *goodsmanagemodel;

@end
