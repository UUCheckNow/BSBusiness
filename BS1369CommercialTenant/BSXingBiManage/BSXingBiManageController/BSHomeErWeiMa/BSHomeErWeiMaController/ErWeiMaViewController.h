//
//  ErWeiMaViewController.h
//  bs1369
//
//  Created by bsmac1 on 15/11/3.
//  Copyright © 2015年 bsw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *showText);

@interface ErWeiMaViewController : UIViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
