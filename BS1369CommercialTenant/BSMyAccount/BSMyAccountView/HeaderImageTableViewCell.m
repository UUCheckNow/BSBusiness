//
//  HeaderImageTableViewCell.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/17.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "HeaderImageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HeaderImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHomePageModel:(BSHomePageModel *)homePageModel {
    self.headerImageView.layer.cornerRadius = 35;
    self.headerImageView.clipsToBounds = YES;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[homePageModel valueForKey:@"headImg"]] placeholderImage:[UIImage imageNamed:@"icon_my"]];
    self.marchName.text = [homePageModel valueForKey:@"merchName"];
    self.marchPhone.text = [NSString stringWithFormat:@"联系方式：%@",[homePageModel valueForKey:@"tel"]];
    self.marchAddress.text = [homePageModel valueForKey:@"addr"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
