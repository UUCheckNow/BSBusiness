//
//  UITextField+BSRegistField.m
//  BS1369
//
//  Created by nyhz on 15/11/24.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#import "UITextField+BSRegistField.h"
#import "BSparam.h"
#import "Common.h"
#define  screenW [UIScreen mainScreen].bounds.size.width
@implementation UITextField (BSRegistField)
-(void)initWithplaceholder:(NSString *)placeholder{
    
        self.placeholder=placeholder;
        self.textColor=[UIColor blackColor];
        self.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
        self.borderStyle=UITextBorderStyleRoundedRect;
        
   
}
-(void)initWithtitle:(NSString *)placeholder{
    
    self.textColor=[UIColor blackColor];
    self.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    self.font=[UIFont systemFontOfSize:13];
    
    
}

-(void)initWithplaceholder:(NSString *)placeholder withBtn:(UIButton *)rightBtn WithTitle:(NSString *)codeTitle{
   
        self.placeholder=placeholder;
        self.textColor=[UIColor blackColor];
        self.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
        self.borderStyle=UITextBorderStyleRoundedRect;
        //左边带图片的
      CGFloat rightBtnW=212.0/720*screenW;
      rightBtn.frame=CGRectMake(self.frame.size.width-rightBtnW, 0, rightBtnW, 36);
    [rightBtn setTitle:codeTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    rightBtn.backgroundColor= REDCOLOR;
     self.rightViewMode=UITextFieldViewModeAlways;
     self.rightView=rightBtn;
    
}

-(void)initWithplaceholder:(NSString *)placeholder withBtn:(UIButton *)rightBtn WithImage:(NSString *)imagestr withSelectImage:(NSString *)selectImage{
  
        self.placeholder=placeholder;
        self.textColor=[UIColor blackColor];
        self.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
        self.borderStyle=UITextBorderStyleRoundedRect;
       CGFloat rightBtnW=18;
       rightBtn.frame=CGRectMake(0, 0, rightBtnW, rightBtnW);
        //左边带图片的
    [rightBtn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [rightBtn setImage:[UIImage imageNamed:imagestr] forState:UIControlStateNormal];
    
    self.rightViewMode=UITextFieldViewModeAlways;
       self.rightView=rightBtn;
    [rightBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)save:(UIButton *)btn{
    btn.selected=!btn.selected;
    if (btn.selected) {
        self.secureTextEntry=YES;
    }else{
        self.secureTextEntry=NO;
    }
    
}
@end
