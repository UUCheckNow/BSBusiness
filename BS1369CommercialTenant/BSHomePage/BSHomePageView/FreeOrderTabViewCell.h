//
//  FreeOrderTabViewCell.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/18.
//  Copyright © 2015年 UU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsManageModel.h"

@interface FreeOrderTabViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic,strong) GoodsManageModel *freeordermodel;

@end
