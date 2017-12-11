//
//  HeaderImageTableViewCell.h
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/17.
//  Copyright © 2015年 UU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSHomePageModel.h"


@interface HeaderImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *marchName;
@property (weak, nonatomic) IBOutlet UILabel *marchAddress;
@property (weak, nonatomic) IBOutlet UILabel *marchPhone;

@property (nonatomic,strong)BSHomePageModel *homePageModel;

@end
