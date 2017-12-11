//
//  BSLoginVC.m
//  BS1369
//
//  Created by nyhz on 15/11/24.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#import "BSLoginVC.h"

#import "MyMD5.h"
#import "BSparam.h"

#import "BSHttpTool.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "SVProgressHUD.h"

#import "UIImageView+WebCache.h"

#import "Common.h"

#import "BSToorbarViewController.h"

#import "AppDelegate.h"

#import "BSchangePwyPasswd.h"

#define MJAutoLoginKey @"btnKey"

#define kAlphaNum @".,/!'-/:@$()&[]{}%~=+ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface BSLoginVC ()<UITextFieldDelegate>
/**
 *注册的电话
 */
@property(nonatomic,weak) UITextField *telField;
/**
 *密码
 */
@property(nonatomic,weak) UITextField *pwdField;
/**
 * 记住密码
 */
@property(nonatomic,weak) UIButton *savBtn;
/**
 * 忘记密码
 */
@property(nonatomic,weak) UIButton *forgetBtn;
/**
 * 登录
 */
@property(nonatomic,weak) UIButton *loginBtn;

/**
 * 登录的param
 */
@property(nonatomic,strong) BSparam *bsparam;

@end

@implementation BSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    登陆页面顶部图片
    [self createImageView];
//    添加退出键盘的手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.view addGestureRecognizer:tap];
    
    //注册的电话
    UITextField *telField = [[UITextField alloc] init];
    _telField=telField;
    _telField.borderStyle=UITextBorderStyleRoundedRect;
    self.telField.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:telField];
    telField.placeholder=@"请输入商户账号";
    telField.textColor=[UIColor blackColor];
    telField.keyboardType = UIKeyboardTypeNumberPad;
    telField.delegate=self;
    telField.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    [telField addTarget:self action:@selector(modifyLength) forControlEvents:UIControlEventAllEditingEvents];
    //密码
    UITextField *pwdview=[[UITextField alloc] init];
    _pwdField=pwdview;
    self.pwdField.returnKeyType=UIReturnKeyDone;
    self.pwdField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:pwdview];
    pwdview.placeholder=@"请输入密码";
    [pwdview addTarget:self action:@selector(modifyLength) forControlEvents:UIControlEventAllEditingEvents];
    pwdview.textColor=[UIColor blackColor];
    pwdview.backgroundColor=[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    pwdview.secureTextEntry=YES;
    //右视图
    UIButton *vieww = [UIButton buttonWithType:0];
    vieww.frame = CGRectMake(0, 0, 50, 50);
    [vieww addTarget:self action:@selector(xiaoyanjing:) forControlEvents:UIControlEventTouchUpInside];
    
    pwdview.rightView = vieww;
    pwdview.borderStyle=UITextBorderStyleRoundedRect;
    
    pwdview.rightViewMode = UITextFieldViewModeAlways;
    [vieww setImage:[UIImage imageNamed:@"see_n"] forState:UIControlStateNormal];
    pwdview.delegate=self;
    
    //记住密码
    UIButton *savBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _savBtn=savBtn;
    [self.view addSubview:savBtn];
    [savBtn addTarget:self action:@selector(savePwd:) forControlEvents:UIControlEventTouchUpInside];
    [savBtn setImage:[UIImage imageNamed:@"login_pwd_s"] forState:UIControlStateSelected];
    [savBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [savBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [savBtn setImage:[UIImage imageNamed:@"login_pwd_n"] forState:UIControlStateNormal];
    [savBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 5)];//上左下右
    [savBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    self.savBtn.selected=[userDefaults boolForKey:@"btnKey"];
    if (self.savBtn.selected) {
        self.telField.text=[userDefaults objectForKey:@"loginTel"];
        self.pwdField.text=[userDefaults objectForKey:@"loginPwd"];
    }
    //忘记密码
    UIButton *forgetBtn=[UIButton buttonWithType:0];
    _forgetBtn=forgetBtn;
    [self.view addSubview:forgetBtn];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    
    //登录
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn=loginBtn;
    [self.view addSubview:loginBtn];
    loginBtn.backgroundColor=REDCOLOR;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];
    [loginBtn addTarget:self action:@selector(loginVC:) forControlEvents:UIControlEventTouchUpInside];

    [self setUpFrame];
}

- (void)xiaoyanjing:(UIButton *)sender {
//    可选不可选~~~~~
    UIButton *btn=(UIButton *)sender;
    btn.selected=!btn.selected;
    if(btn.selected){
        [btn setImage:[UIImage imageNamed:@"see_y"] forState:UIControlStateSelected];
        self.pwdField.secureTextEntry = NO;
    }else{
        [btn setImage:[UIImage imageNamed:@"see_n"] forState:UIControlStateNormal];
        self.pwdField.secureTextEntry = YES;
    }
}

- (void)createImageView {
    UIImageView *loginImgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, ScreenWidth-100, (ScreenHeight-100)/2)];
    loginImgView.image = [UIImage imageNamed:@"loginImage"];
    [self.view addSubview:loginImgView];
}
-(void)setUpFrame{
    CGFloat telY = (ScreenHeight-20)/2 + 30;
    CGFloat telH=36;
    CGFloat telX=50;
    CGFloat telW=ScreenWidth-100;
    self.telField.frame=CGRectMake(telX, telY, telW, telH);
    self.pwdField.frame=CGRectMake(telX, CGRectGetMaxY(self.telField.frame)+19, telW, telH);
    self.savBtn.frame=CGRectMake(telX, CGRectGetMaxY(self.pwdField.frame)+26, 100, 26);
    CGFloat forgetBtnW=100;
    self.forgetBtn.frame=CGRectMake(CGRectGetMaxX(self.pwdField.frame)-forgetBtnW, CGRectGetMaxY(self.pwdField.frame)+26, forgetBtnW, 26);
    CGFloat loginBtnX=ScreenWidth/3;
    CGFloat loginBtnY=CGRectGetMaxY(self.savBtn.frame)+26;
    CGFloat loginBtnW=ScreenWidth/3;
    CGFloat loginBtnH=36;
    self.loginBtn.frame=CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);

}

#pragma mark 结束编辑
-(void)hiddenView{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//记住密码
-(void)savePwd:(UIButton *)btn{
    btn.selected=!btn.selected;
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    if(btn.selected){
        if (!self.telField.text&&(!self.pwdField.text)) {
            self.telField.text=[userdefaults objectForKey:@"loginName"];
            self.pwdField.text=[userdefaults objectForKey:@"Password"];
        }
    }
}
//忘记密码
-(void)findPwd{
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"抱歉！" message:@"客户端暂不支持找回密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertV show];

}

//点击登录按钮
-(void)loginVC:(UIButton *)btn{
    [_telField resignFirstResponder];
    [_pwdField resignFirstResponder];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //记录密码用户名
    
    [userDefaults setObject:self.telField.text forKey:@"loginName"];
    [userDefaults setObject:self.pwdField.text forKey:@"Password"];
    [userDefaults setBool:self.savBtn.isSelected forKey:MJAutoLoginKey];
    
    if(!self.savBtn.selected && [userDefaults objectForKey:@"loginName"] && [userDefaults objectForKey:@"Password"]){
        [userDefaults removeObjectForKey:@"loginName"];
        [userDefaults removeObjectForKey:@"Password"];
    }
    _bsparam=[[BSparam alloc] init];
    _bsparam.name = self.telField.text;
    _bsparam.pwdUrlMd5 = [MyMD5 md5:self.pwdField.text];
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    
    [BSHttpTool POST:@"login" parameters:_bsparam success:^(id responseObject) {
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dic[@"code"] isEqualToString:@"1"]) {

            NSString *str=dic[@"code_text"];

            [SVProgressHUD showErrorWithStatus:str];
            
        }else if([dic[@"code"] isEqualToString:@"0"]){
            NSDictionary *infodic=dic[@"info"];
            //            归档
            [userDefaults setObject:self.telField.text forKey:@"loginTel"];
            
            [userDefaults setObject:self.pwdField.text forKey:@"loginPwd"];
            
            NSString *Conversion=infodic[@"Conversion"];//折算比
            
            [userDefaults setObject:Conversion forKey:@"Conversion"];
            
            NSString *id=infodic[@"id"];//biid
            
            [userDefaults setObject:id forKey:@"id"];
            
            [userDefaults synchronize];
            
            [SVProgressHUD dismiss];
            //隐藏tabbar
            [self setHidesBottomBarWhenPushed:YES];
            
            //    点击登录时换一下根控制器
            BSToorbarViewController *rootController = [[BSToorbarViewController alloc]init];
            rootController.tabBar.translucent = NO;
            rootController.tabBar.tintColor = REDCOLOR;
            [UIApplication sharedApplication].delegate.window.rootViewController = rootController;
        
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];

}
#pragma mark 协议方法结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_telField resignFirstResponder];
    [_pwdField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -100, ScreenWidth, ScreenHeight+100);
    }];
    return YES;
}
//账户只能是11位电话号码
//密码是6~20位数字字符字母
- (void)modifyLength
{
    if (self.telField.text.length > 11) {
        self.telField.text = [self.telField.text substringToIndex:11];
    }
    if (self.pwdField.text.length > 18) {
        self.pwdField.text = [self.pwdField.text substringToIndex:18];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.telField]) {
        self.pwdField.text = @"";
        return [self validateNumber:string];
    }
    if ([textField isEqual:self.pwdField]) {
        return [self validatePwdNumber:string];
    }
    return YES;
}


- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)validatePwdNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet *cs;
    
    cs = [NSCharacterSet characterSetWithCharactersInString:number];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:cs];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}




@end
