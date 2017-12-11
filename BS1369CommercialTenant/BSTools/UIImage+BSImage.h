//
//  UIImage+BSImage.h
//  BS1369
//
//  Created by nyhz on 15/11/16.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BSImage)
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
