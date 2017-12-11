//
//  BSchangePwyPasswd.m
//  BS1369
//
//  Created by nyhz on 15/12/5.
//  Copyright © 2015年 bsw1369. All rights reserved.
//

#import "BSchangePwyPasswd.h"
#import "UITextField+BSRegistField.h"
#import "BSparam.h"
#import "BSHttpTool.h"
#import "BSchangPwyPwd.h"
#import "MBProgressHUD+MJ.h"
#import "Common.h"
#import "BSSetNavigationView.h"

#define screenW [UIScreen mainScreen].bounds.size.width
@interface BSchangePwyPasswd ()
/**
 *验证身份
 */
@property(nonatomic,weak) UILabel *detailView;


/**
 *输入手机号
 */
@property(nonatomic,weak) UILabel *telView;

/**
 *验证码
 */
@property(nonatomic,weak) UITextField *codeView;

/**
 *下一步
 */
@property(nonatomic,weak) UIButton *nextView;

//验证码
@property(nonatomic,copy) NSString *msg;

@end

@implementation BSchangePwyPasswd

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNavigation];
    [self setUpAllchildrens];
    [self setUpData];
    [self setUpFrame];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    [self.view addGestureRecognizer:tap];

}
- (void)setTelStr:(NSString *)telStr {
    _telStr = telStr;
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
    
    
    UILabel *telView=[[UILabel alloc] init];
    _telView=telView;
    NSString *strUrl = [_telStr stringByReplacingCharactersInRange:NSMakeRange(3,5) withString:@"*****"];
    telView.text = [NSString stringWithFormat:@"我们已经给您的手机%@发送了一条短信",strUrl];
    telView.numberOfLines = 2;
    telView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:telView];
    
    UITextField *codeView=[[UITextField alloc] init];
    _codeView=codeView;
    _codeView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:codeView];
    
    UIButton *nextView=[UIButton buttonWithType:UIButtonTypeCustom];
    _nextView=nextView;
    [self.view addSubview:nextView];
    
    
    
}

//设置数据
-(void)setUpData{
    self.detailView.text=@"1、验证身份";
    self.detailView.font=[UIFont systemFontOfSize:14];


    UIButton *codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn addTarget:self action:@selector(startTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeView initWithplaceholder:@"请输入验证码" withBtn:codeBtn WithTitle:@"获取验证码"];
    [_nextView setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextView addTarget:self action:@selector(saveBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    _nextView.backgroundColor=REDCOLOR;
    [_nextView.layer setMasksToBounds:YES];
    [_nextView.layer setCornerRadius:5];
}

#pragma mark 下一步
-(void)saveBtnMethod{
    //验证是否正确
    if (![self.codeView.text isEqualToString:self.msg]) {
//        NSLog(@"%@",self.msg);
        [MBProgressHUD showError:@"请输入正确的验证码或者手机号"];
        return;
    }
    
    BSchangPwyPwd *changPwd=[[BSchangPwyPwd alloc] init];
    
    changPwd.msssg = _msg;
    [self.navigationController pushViewController:changPwd animated:YES];
}




#pragma mark 倒计时  请求验证码
-(void)startTime:(UIButton *)btn{
    //请求短信验证码
    btn.userInteractionEnabled = NO;
    //   [self requestCodeUrl];
    BSparam *bsparam=[[BSparam alloc] init];
    bsparam.mobile= _telStr;
//    获取验证码接口 (SmsCode)
    [BSHttpTool POST:@"SmsCode" parameters:bsparam success:^(id responseObject) {
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
        if ([dic[@"Msg"] isEqualToString:@"0"]) {
            [MBProgressHUD showError:dic[@"code_text"]];
        }else{
            self.msg=dic[@"Msg"];
//            NSLog(@"-----%@-------",_msg);
            __block int timeout=60;//倒计时时间
            dispatch_queue_attr_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        btn.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout ;//% 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [btn setTitle:[NSString stringWithFormat:@"重新获取(%@s)",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        btn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
        
    } failure:^(NSError *error) {
        btn.userInteractionEnabled = YES;
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
    _telView.frame=CGRectMake(telX, telY, telW, telH);
    CGFloat codeViewY=CGRectGetMaxY(_telView.frame)+paddingH;
    _codeView.frame=CGRectMake(padding, codeViewY, telW, telH);
    
    CGFloat nextY=CGRectGetMaxY(_codeView.frame)+paddingH*3;
    CGFloat nextW=screenW/3;
    
    _nextView.frame=CGRectMake(screenW/3, nextY, nextW, telH);
    
    
    
}

#pragma mark 协议方法结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end