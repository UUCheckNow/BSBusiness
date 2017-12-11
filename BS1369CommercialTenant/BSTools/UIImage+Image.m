//
//  UIImage+Image.m
//  bs1369
//
//  Created by 张玉 on 15/10/13.
//  Copyright (c) 2015年 bsw. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage(Image)

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}



@end
