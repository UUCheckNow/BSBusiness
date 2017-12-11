//
//  BSchangPwyPwd.m
//  BS1369
//
//  Created by nyhz on 15/12/5.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#import "BSchangPwyPwd.h"
#import "UITextField+BSRegistField.h"
#import "MBProgressHUD+MJ.h"
#import "BSHttpTool.h"
#import "BSparam.h"
#import "BSLoginVC.h"
#import "MyMD5.h"

#import "BSSetNavigationView.h"
#import "Common.h"

#import "BSUtils.h"

#define screenW [UIScreen mainScreen].bounds.size.width
@interface BSchangPwyPwd () {
    UILabel *sureLabel;
}
/**
 *显示内容
 */
@property(nonatomic,weak) UILabel *detailView;


/**
 *确认密码
 */
@property(nonatomic,weak) UITextField *pwdView;
/**
 *再次确认密码
 */
@property(nonatomic,weak) UITextField *surePwdView;

/**
 *显示内容
 */
@property(nonatomic,weak) UILabel *codeView;

/**
 *确定按钮
 */
@property(nonatomic,weak) UIButton *sureView;


//验证码
@property(nonatomic,copy) NSString *msg;

@end

@implementation BSchangPwyPwd

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNavigation];
    [self setUpAllchildrens];
    [self setUpData];
    [self setUpFrame];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.view addGestureRecognizer:tap];
    [self createalphaView];
    
}
- (void)setMsssg:(NSString *)msssg {
    _msssg = msssg;
    
}
- (void)createalphaView {
    
    UIView *alphaView = [[UIView alloc]initWithFrame:self.view.frame];
    alphaView.tag = 555;
    alphaView.alpha = 0;
    alphaView.backgroundColor = [UIColor blackColor];
    
    sureLabel = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-250)/2, ScreenHeight/4, 250, 30)];
    
    sureLabel.font = [UIFont boldSystemFontOfSize:18];
    sureLabel.textAlignment = NSTextAlignmentCenter;
    sureLabel.textColor = [UIColor whiteColor];
    [alphaView addSubview:sureLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake((CGRectGetWidth(alphaView.frame) - 145)/2,ScreenHeight/3, 145, 36);
    sureButton.layer.cornerRadius = 5;
    sureButton.tag = 556;
    sureButton.clipsToBounds = YES;
    [sureButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:REDCOLOR];
    [sureButton addTarget:self action:@selector(sureTouch:) forControlEvents:UIControlEventTouchUpInside];
    [alphaView addSubview:sureButton];
    [self.view addSubview:alphaView];
}

- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithLeftImageName:@"fanhui" centerTitleName:@"账户安全" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navg.delegateVC = self;
    navg.backgroundColor = [UIColor whiteColor];
    navg.titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:navg];
}
#pragma mark 结束编辑
-(void)hiddenView{
    [self.view endEditing:YES];
}

-(void)setUpAllchildrens{
    UILabel *detailView=[[UILabel alloc] init];
    _detailView=detailView;
    [self.view addSubview:detailView];
    
    
    UITextField *pwdView=[[UITextField alloc] init];
    _pwdView=pwdView;
    pwdView.keyboardType = UIKeyboardTypeASCIICapable;
    [pwdView addTarget:self action:@selector(modifyLength) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:pwdView];
    
    UITextField *surePwdView=[[UITextField alloc] init];
    _surePwdView=surePwdView;
    surePwdView.keyboardType = UIKeyboardTypeASCIICapable;
    [surePwdView addTarget:self action:@selector(modifyLength) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:surePwdView];
    
    UILabel *codeView=[[UILabel alloc] init];
    _codeView=codeView;
    [self.view addSubview:codeView];
    
    
    UIButton *sureView=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureView=sureView;
    [self.view addSubview:sureView];
    
    
    
}

//设置数据
-(void)setUpData{
    self.detailView.text=@"2、修改密码";
    self.detailView.font=[UIFont systemFontOfSize:14];
    [self.pwdView initWithplaceholder:@"请输入新密码"];
    [self.surePwdView initWithplaceholder:@"请再次确定新密码"];
    self.surePwdView.font=[UIFont systemFontOfSize:14];
    self.pwdView.font=[UIFont systemFontOfSize:14];
    
    _codeView.textColor = [UIColor lightGrayColor];
    //属性字符串
    NSString *exchangeCountStr = [@" *  " stringByAppendingString:@"密码至少6位的数字和字母组成"];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:exchangeCountStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(0,1)];
    _codeView.attributedText = AttributedStr;
    _codeView.font=[UIFont systemFontOfSize:13];

    
    
    [_sureView setTitle:@"下一步" forState:UIControlStateNormal];
    [_sureView addTarget:self action:@selector(saveBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    _sureView.backgroundColor=REDCOLOR;
    [_sureView.layer setMasksToBounds:YES];
    [_sureView.layer setCornerRadius:5];
}

#pragma mark 确认 改变密码
-(void)saveBtnMethod{
    
#pragma mark 判断输入的密码
    if (![BSUtils checkPassword:self.pwdView.text]) {
        [MBProgressHUD showError:@"密码至少6位的数字和字母组成"];
        return ;
    }
    //验证是否正确
    if (![self.pwdView.text isEqualToString:self.surePwdView.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一样"];
        return;
    }
    if ([BSUtils checkPassword:self.pwdView.text]&&[self.pwdView.text isEqualToString:self.surePwdView.text]) {
        [self requstUrl];
    }

    
}
-(void)requstUrl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BSparam *param=[[BSparam alloc] init];
    param.name = [userDefaults objectForKey:@"loginTel"];
    param.pwd = self.pwdView.text;
    param.yzm = _msssg;
//    获取修改登录密码 (modifyPwd)
    [BSHttpTool POST:@"modifyPwd" parameters:param success:^(id responseObject) {
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            sureLabel.text = dic[@"code_text"];
            
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults removeObjectForKey:@"merchName"];
            [userdefaults removeObjectForKey:@"addr"];
            [userdefaults removeObjectForKey:@"tel"];
            [userdefaults removeObjectForKey:@"headImg"];
            [userdefaults removeObjectForKey:@"ActiveUser"];
            [userdefaults removeObjectForKey:@"yuE"];
            [userdefaults removeObjectForKey:@"loginPwd"];
            [userdefaults removeObjectForKey:@"id"];
            [userdefaults removeObjectForKey:@"Conversion"];
            
            [self showbgView];
            
        }else {
            if ([dic[@"code"] isEqualToString:@"1"]) {
                [MBProgressHUD showError:dic[@"code_text"]];
                return ;
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",[error description]);
    }];
    
}

- (void)showbgView {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *alphaV = [self.view viewWithTag:555];
        alphaV.alpha = 0.8;
        UIButton *sureB = [self.view viewWithTag:556];
        sureB.alpha = 1;
    }];
    
}
//点击 立即登录 按钮
- (void)sureTouch:(UIButton *)sureBtn {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *alphaV = [self.view viewWithTag:555];
        alphaV.alpha = 0;
        UIButton *sureB = [self.view viewWithTag:556];
        sureB.alpha = 0;
    }];
    
    
    
    BSLoginVC *loginVC = [[BSLoginVC alloc]init];
    
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
}

//设置布局
-(void)setUpFrame{
    CGFloat padding=8;
    CGFloat paddingH=10;
    CGFloat detailX=padding;
    CGFloat detailY=paddingH+64;
    CGFloat detailW=screenW-2*padding;
    CGFloat detailH=36;
    _detailView.frame=CGRectMake(detailX, detailY, detailW, detailH);
    
    
    CGFloat telY=CGRectGetMaxY(_detailView.frame)+paddingH;
    CGFloat telX=padding;
    CGFloat telW=screenW-2*padding;
    CGFloat telH=36;
    _pwdView.frame=CGRectMake(telX, telY, telW, telH);
    
    CGFloat surePwdViewY=CGRectGetMaxY(_pwdView.frame)+paddingH;
    _surePwdView.frame=CGRectMake(padding, surePwdViewY, telW, telH);
    
    CGFloat codeViewY=CGRectGetMaxY(_surePwdView.frame)+paddingH;
    _codeView.frame=CGRectMake(padding, codeViewY, telW, telH);
    
    
    
    
    CGFloat sureY=CGRectGetMaxY(_codeView.frame)+paddingH;
    CGFloat sureW=screenW/3;
    
    _sureView.frame=CGRectMake(screenW/3, sureY, sureW, telH);
    
    
    
}

#pragma mark 协议方法结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}


//账户只能是11位电话号码
//密码是6~18位数字字符字母
- (void)modifyLength
{
    if (self.pwdView.text.length > 18) {
        self.pwdView.text = [self.pwdView.text substringToIndex:18];
    }
    if (self.surePwdView.text.length > 18) {
        self.surePwdView.text = [self.surePwdView.text substringToIndex:18];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return [self validatePwdNumber:string];

    return YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
