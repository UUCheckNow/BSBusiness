//
//  FreeCodeQueryVC.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/17.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "FreeCodeQueryVC.h"
#import "BSSetNavigationView.h"
#import "Common.h"

#import "MyMD5.h"
#import "BSparam.h"
#import "BSHttpTool.h"

#import "MBProgressHUD+MJ.h"

#import "ErWeiMaViewController.h"

@interface FreeCodeQueryVC () <UITextFieldDelegate> {
    NSMutableArray *dataArr4;
    NSMutableArray *dataArr0;
    UIButton *ewmButton;
}

/**
 * 订单编码
 */
@property(nonatomic,strong) UILabel *orderlabel;
/**
 *订单号输入框
 */
@property(nonatomic,weak) UITextField *telField;
/**
 * 查询按钮
 */
@property(nonatomic,weak) UIButton *lookForBtn;
/**
 * 登录的param
 */
@property(nonatomic,strong) BSparam *bsparam;

@property (nonatomic,strong) NSString *statusString;

@end

@implementation FreeCodeQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setNavigation];
    dataArr4 = [[NSMutableArray alloc]init];
    dataArr0 = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.view addGestureRecognizer:tap];
    
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithLeftImageName:@"fanhui" centerTitleName:@"验证消费密码" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navg.backgroundColor = [UIColor whiteColor];
    navg.titleLabel.textColor = [UIColor blackColor];
    navg.delegateVC = self;
    [self.view addSubview:navg];
}

- (void)createView {
    
    UILabel *orderLabel = [[UILabel alloc]init];
    _orderlabel = orderLabel;
    orderLabel.text = @"消费密码 ：";
    orderLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:orderLabel];
    
    //订单号输入框
    UITextField *telField=[[UITextField alloc] init];
    _telField=telField;
    [telField addTarget:self action:@selector(modifyLength) forControlEvents:UIControlEventAllEditingEvents];
    self.telField.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:telField];
    telField.placeholder=@"请输入消费密码";
    telField.font = [UIFont systemFontOfSize:15];
    telField.textColor=[UIColor blackColor];
    telField.borderStyle=UITextBorderStyleRoundedRect;
    telField.delegate=self;
    telField.backgroundColor=BgColor;
    telField.keyboardType = UIKeyboardTypeNumberPad;
    ewmButton = [UIButton buttonWithType:0];
    
    
    UIFont *icon2font = [UIFont fontWithName:@"IconFont" size: 25];
    ewmButton.titleLabel.font = icon2font;
    [ewmButton setTitle:@"\U0000e609" forState:0];
    [ewmButton setTitleColor:[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1] forState:0];
    
    [ewmButton addTarget:self action:@selector(Touchewm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ewmButton];
    
    //查询按钮
    UIButton *lookForBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _lookForBtn=lookForBtn;
    [self.view addSubview:lookForBtn];
    lookForBtn.backgroundColor= REDCOLOR;
    [lookForBtn setImage:[UIImage imageNamed:@"组-3w"] forState:UIControlStateNormal];
    [lookForBtn setImage:[UIImage imageNamed:@"组-3w"] forState:UIControlStateHighlighted];
    lookForBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-8,0,8);
    [lookForBtn setTitle:@"查询" forState:UIControlStateNormal];
//    lookForBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    lookForBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lookForBtn.layer setMasksToBounds:YES];
    [lookForBtn.layer setCornerRadius:5];
    [lookForBtn addTarget:self action:@selector(lookForClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpFrame];
}

- (void)getDataFromNet {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _bsparam = [[BSparam alloc]init];
    
    _bsparam.name = [userDefaults objectForKey:@"loginTel"];
    _bsparam.pwdUrlMd5 = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
    _bsparam.orderNum = self.telField.text;
    _bsparam.bidd = [userDefaults objectForKey:@"id"];
    //   获取验证消费密码接口 (getFreeOrder2)
    [BSHttpTool POST:@"getFreeOrder2" parameters:_bsparam success:^(id responseObject) {
        _statusString = responseObject[@"code_text"];
        
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [dataArr0 addObject:responseObject[@"info"]];
//            NSLog(@"-----%@",responseObject);
            [self createalphaView];
            [self createAlertView4];
        }else{
            [self createalphaView];
            [self createAlertView1];
        }
// 0、未使用  2、非本店 3、不存在 4、已消费 6、已过期
        
    } failure:^(NSError *error) {
        
    }];
}

//点击 关闭 按钮
- (void)cancelTouch:(UIButton *)sureBtn {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *alphaV = [self.view viewWithTag:666];
        [alphaV removeFromSuperview];
        UIView *AlertView1 = [self.view viewWithTag:777];
        [AlertView1 removeFromSuperview];
        UIView *AlertView2 = [self.view viewWithTag:888];
        [AlertView2 removeFromSuperview];
        UIView *AlertView3 = [self.view viewWithTag:999];
        [AlertView3 removeFromSuperview];
        UIView *AlertView4 = [self.view viewWithTag:1111];
        [AlertView4 removeFromSuperview];
    }];
    
}
//点击使用
- (void)useTouch:(UIButton *)button {
    
    [UIView animateWithDuration:0.3 animations:^{
        UIView *alphaV = [self.view viewWithTag:666];
        [alphaV removeFromSuperview];
        UIView *AlertView4 = [self.view viewWithTag:888];
        [AlertView4 removeFromSuperview];
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _bsparam = [[BSparam alloc]init];
    _bsparam.type = [dataArr0[0] valueForKey:@"type"];
    _bsparam.name = [userDefaults objectForKey:@"loginTel"];
    _bsparam.pwdUrlMd5 = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
    _bsparam.OrderBH = [dataArr0[0] valueForKey:@"OrderBH"];
    _bsparam.BuyBH = self.telField.text;
    
    //   使用消费密码接口  "success": "1",//0失败1成功
    [BSHttpTool POST:@"UseBuyBH" parameters:_bsparam success:^(id responseObject) {
        _statusString = responseObject[@"code_text"];
        if ([responseObject[@"success"] isEqualToString:@"1"]) {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"恭喜!" message:_statusString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
        }else if ([responseObject[@"success"] isEqualToString:@"0"]){
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"抱歉!" message:_statusString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)createalphaView {
    
    UIView *alphaView = [[UIView alloc]initWithFrame:self.view.frame];
    alphaView.tag = 666;
    alphaView.alpha = 0.8;
    alphaView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:alphaView];

}
//未使用
- (void)createAlertView4 {
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(16, ScreenHeight/3, ScreenWidth-2*16, 200)];
    alertView.tag = 888;
    alertView.layer.cornerRadius = 10;
    alertView.clipsToBounds = YES;
    alertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:alertView];
    
    UILabel *Label5_1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, ScreenWidth-2*24, 30)];
    Label5_1.text = [NSString stringWithFormat:@"消费密码：%@",self.telField.text];
    Label5_1.font = [UIFont boldSystemFontOfSize:15];
    [alertView addSubview:Label5_1];
    
    UILabel *Label5_U = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 5,50, 30)];
    Label5_U.text = @"未使用";
    [Label5_U setTextColor:REDCOLOR];
    Label5_U.font = [UIFont systemFontOfSize:15];
    [alertView addSubview:Label5_U];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth-2*16, 1)];
    lineView.backgroundColor = REDCOLOR;
    [alertView addSubview:lineView];
    
    UILabel *Label5_2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, ScreenWidth-2*24, 20)];
    Label5_2.font = [UIFont boldSystemFontOfSize:15];
    Label5_2.numberOfLines = 2;
    Label5_2.text = [NSString stringWithFormat:@"商品名称：%@",[dataArr0[0] valueForKey:@"GoodName"]];
    Label5_2.textColor = [UIColor lightGrayColor];
    [alertView addSubview:Label5_2];
    
    UILabel *Label5_3 = [[UILabel alloc]initWithFrame:CGRectMake(16, 80, ScreenWidth-2*24, 20)];
    Label5_3.font = [UIFont boldSystemFontOfSize:15];
    Label5_3.numberOfLines = 2;
    Label5_3.text = [NSString stringWithFormat:@"供货价：%@",[dataArr0[0] valueForKey:@"BuyingPrice"]];;
    Label5_3.textColor = [UIColor lightGrayColor];
    [alertView addSubview:Label5_3];
    
    UILabel *Label5_4 = [[UILabel alloc]initWithFrame:CGRectMake(16, 110, ScreenWidth-2*24, 20)];
    Label5_4.font = [UIFont boldSystemFontOfSize:15];
    Label5_4.numberOfLines = 2;
    Label5_4.text = [NSString stringWithFormat:@"购买用户：%@",[dataArr0[0] valueForKey:@"Moblie"]];
    Label5_4.textColor = [UIColor lightGrayColor];
    [alertView addSubview:Label5_4];
    
    UIButton *sureButton = [UIButton buttonWithType:0];
    sureButton.frame = CGRectMake((ScreenWidth-2*120)/3,150,120, 36);
    sureButton.layer.cornerRadius = 5;
    sureButton.clipsToBounds = YES;
    [sureButton setTitle:@"使用" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:REDCOLOR];
    [sureButton addTarget:self action:@selector(useTouch:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:0];
    cancelButton.frame = CGRectMake((ScreenWidth-2*120)/3 +20 + 120,150,120, 36);
    cancelButton.layer.cornerRadius = 5;
    cancelButton.clipsToBounds = YES;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:REDCOLOR forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [REDCOLOR CGColor];
    [cancelButton addTarget:self action:@selector(cancelTouch:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelButton];
    
}

//不属于该商家  不存在   已使用
- (void)createAlertView1 {
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(16, ScreenHeight/3, ScreenWidth-2*16, 150)];
    alertView.tag = 1111;
    alertView.layer.cornerRadius = 10;
    alertView.clipsToBounds = YES;
    alertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:alertView];
    
    UILabel *Label5_1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, ScreenWidth-2*24, 30)];
    Label5_1.text = [NSString stringWithFormat:@"消费密码：%@",self.telField.text];
    Label5_1.font = [UIFont boldSystemFontOfSize:15];
    [alertView addSubview:Label5_1];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth-2*16, 1)];
    lineView.backgroundColor = REDCOLOR;
    [alertView addSubview:lineView];
    
    UILabel *Label5_2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 55, ScreenWidth-2*24, 30)];
    Label5_2.text = _statusString;
    Label5_2.font = [UIFont boldSystemFontOfSize:15];
    Label5_2.textAlignment = NSTextAlignmentCenter;
    Label5_2.textColor = REDCOLOR;
    [alertView addSubview:Label5_2];
    
    UIButton *sureButton = [UIButton buttonWithType:0];
    sureButton.frame = CGRectMake((ScreenWidth-145)/2-16,100,145, 36);
    sureButton.layer.cornerRadius = 5;
    sureButton.clipsToBounds = YES;
    [sureButton setTitle:@"关闭" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:REDCOLOR];
    [sureButton addTarget:self action:@selector(cancelTouch:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
    
}


#pragma mark 结束编辑
-(void)hiddenView{
    [self.view endEditing:YES];
}
#pragma mark 协议方法结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击查询按钮
- (void)lookForClick:(UIButton *)button {
    if ([self.telField.text isEqualToString:@""]) {

        [MBProgressHUD showError:@"请输入订单号"];
        
    }else {
        [self hiddenView];
        [self getDataFromNet];
    }
    
}

//textfield的约束
- (void)modifyLength
{
    if (self.telField.text.length > 12) {
        self.telField.text = [self.telField.text substringToIndex:12];
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.telField]) {
        
        return [self validateNumber:string];
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

-(void)setUpFrame{
    
    CGFloat orderLabX=16;
    CGFloat orderLabY= 64+30;
    CGFloat orderLabW=ScreenWidth/3;
    CGFloat orderLabH=20;
    self.orderlabel.frame=CGRectMake(orderLabX, orderLabY, orderLabW, orderLabH);
    
    CGFloat telX=16;
    CGFloat telY =64+30+50;
    CGFloat telH=36;
    CGFloat telW=ScreenWidth-32;
    self.telField.frame=CGRectMake(telX, telY, telW, telH);
    ewmButton.frame = CGRectMake(CGRectGetMaxX(_telField.frame)-40, CGRectGetMinY(_telField.frame), 34, 34);
    
    CGFloat loginBtnX=ScreenWidth/3;
    CGFloat loginBtnY=CGRectGetMaxY(self.telField.frame)+40;
    CGFloat loginBtnW=ScreenWidth/3;
    CGFloat loginBtnH=36;
    self.lookForBtn.frame=CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
    
}

- (void)Touchewm:(UIButton *)button {
    //点击二维码按钮
    ErWeiMaViewController *er = [[ErWeiMaViewController alloc] init];
    er.hidesBottomBarWhenPushed = YES;
    [er returnText:^(NSString *showText) {
        _telField.text = showText;
    }];
    [self.navigationController pushViewController:er animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end