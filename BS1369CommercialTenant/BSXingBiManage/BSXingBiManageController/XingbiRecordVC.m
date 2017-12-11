//
//  XingbiRecordVC.m
//  BS1369CommercialTenant
//
//  Created by bsmac2 on 15/12/17.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "XingbiRecordVC.h"
#import "BSSetNavigationView.h"
#import "Common.h"

#import "MBProgressHUD+MJ.h"

#import "MyMD5.h"
#import "BSHttpTool.h"
#import "BSparam.h"

#import "XingBiRecordModel.h"

#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>

#import "ErWeiMaViewController.h"


@interface XingbiRecordVC () < UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UITextField *_nametextfield;
    UITextField *_moneytextfield;
    UILabel *_numberLabel;
    
    UIButton *btn;
}

@property(nonatomic,strong) BSparam *bsparam;

@end

@implementation XingbiRecordVC


- (void) changeNameTextFieldText:(NSString *)aStr {
    _nametextfield.text = aStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self setNavigation];
    
    [self createTableView];
    
    UITapGestureRecognizer *tapguest=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endkeyboard)];
    [self.view addGestureRecognizer:tapguest];
    
    [self createView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)createView {
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(ScreenWidth/3, 350,ScreenWidth/3, 35);
    [btn setTitle:@"确认赠送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:13];
    btn.backgroundColor=REDCOLOR;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5.0;
    [btn addTarget:self action:@selector(payyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)getDataFromNet {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _bsparam = [[BSparam alloc]init];
    _bsparam.name = [userDefaults objectForKey:@"loginTel"];
    _bsparam.pwd = [MyMD5 md5:[userDefaults objectForKey:@"loginPwd"]];
    _bsparam.mobile = _nametextfield.text;
    
    //    获取会员信息 (getMemberByMobile)
    [BSHttpTool POST:@"getMemberByMobile" parameters:_bsparam success:^(id responseObject) {
        
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [_dataArray addObject:responseObject[@"info"]];
            
            [self createalphaView];
            [self createAlertVieww];
            
        }else {
            
            NSString *str=dic[@"code_text"];
            
            [MBProgressHUD showError:str];
        }
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)createalphaView {
    
    UIView *alphaView = [[UIView alloc]initWithFrame:self.view.frame];
    alphaView.tag = 20160333;
    alphaView.alpha = 0.8;
    alphaView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:alphaView];
    
}

//弹出的是否确认赠送VIEW
- (void)createAlertVieww {
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(16, ScreenHeight/3, ScreenWidth-2*16, 150)];
    alertView.tag = 20160323;
    alertView.layer.cornerRadius = 10;
    alertView.clipsToBounds = YES;
    alertView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:alertView];
    
    UILabel *Label5_1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, ScreenWidth-32, 60)];
    Label5_1.textAlignment = NSTextAlignmentCenter;
    Label5_1.font = [UIFont boldSystemFontOfSize:18];
    Label5_1.textColor = REDCOLOR;
    Label5_1.numberOfLines = 2;
    NSUserDefaults *userDefaultss = [NSUserDefaults standardUserDefaults];
    NSString *telNum = [_nametextfield.text stringByReplacingCharactersInRange:NSMakeRange(3,5) withString:@"*****"];
    NSString *xbNum = [NSString stringWithFormat:@"%.0f",[[userDefaultss objectForKey:@"Conversion"] floatValue]/100*[_moneytextfield.text floatValue]];
    Label5_1.text = [NSString stringWithFormat:@"您确认赠送给%@\n%@星币？",telNum,xbNum];
    
    [alertView addSubview:Label5_1];
    
    UIButton *sureButton = [UIButton buttonWithType:0];
    sureButton.frame = CGRectMake((ScreenWidth-2*120)/3,100,120, 36);
    sureButton.layer.cornerRadius = 5;
    sureButton.clipsToBounds = YES;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:REDCOLOR];
    [sureButton addTarget:self action:@selector(suresTouch) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:0];
    cancelButton.frame = CGRectMake((ScreenWidth-2*120)/3 +20 + 120,100,120, 36);
    cancelButton.layer.cornerRadius = 5;
    cancelButton.clipsToBounds = YES;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:REDCOLOR forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [REDCOLOR CGColor];
    [cancelButton addTarget:self action:@selector(cancelsTouch:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelButton];
    
}
//点击确认
- (void)suresTouch {
    [self getDataFromNets];
}

//点击 取消 按钮
- (void)cancelsTouch:(UIButton *)sureBtn {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *alphaV = [self.view viewWithTag:20160333];
        [alphaV removeFromSuperview];
        UIView *AlertView1 = [self.view viewWithTag:20160323];
        [AlertView1 removeFromSuperview];
    }];
    btn.userInteractionEnabled = YES;
}

- (void)getDataFromNets {
    
    NSUserDefaults *userDefaultss = [NSUserDefaults standardUserDefaults];
    _bsparam = [[BSparam alloc]init];
    _bsparam.mmobile = [userDefaultss objectForKey:@"loginTel"];
    _bsparam.pwd = [MyMD5 md5:[userDefaultss objectForKey:@"loginPwd"]];
    _bsparam.usermobile = _nametextfield.text;
    _bsparam.money = _moneytextfield.text;
    _bsparam.uidd = [_dataArray valueForKey:@"id"];
    _bsparam.bfb = [userDefaultss objectForKey:@"Conversion"];//折算比
    _bsparam.bidd = [userDefaultss objectForKey:@"id"];
    _bsparam.oway = @"3";
    NSString *XBnumber = [NSString stringWithFormat:@"%.0f",[[userDefaultss objectForKey:@"Conversion"] floatValue]/100*[_moneytextfield.text floatValue]];
    _bsparam.xb = [XingbiRecordVC encryptWithContent:XBnumber type:0 key:@"zbsw1369"];
    //    获取商户的赠送记录分页 (obtainBusinessGiveRecord)（赠送）
    [BSHttpTool POST:@"insertGivingXb" parameters:_bsparam success:^(id responseObject) {
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSString *str=dic[@"code_text"];
            [MBProgressHUD showSuccess:str];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            NSString *str=dic[@"code_text"];
            [MBProgressHUD showError:str];
        }
       
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 结束编辑
-(void)endkeyboard{
    [self.view endEditing:YES];
}
- (void)setNavigation {
    BSSetNavigationView *navg = [BSSetNavigationView navigationWithLeftImageName:@"redfanhui" centerTitleName:@"星币赠送" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navg.delegateVC = self;
    [self.view addSubview:navg];
}
//textfield 输入内容
-(void)creattextField:(UITextField *)textfiel withTitle:(NSString *)title withplaceTitle:(NSString *)placeTitle{
    textfiel.text=title;
    textfiel.tintColor=[UIColor blackColor];
    textfiel.font=[UIFont systemFontOfSize:13];
    textfiel.placeholder=placeTitle;
    textfiel.delegate=self;
    textfiel.returnKeyType=UIReturnKeyDone;
    
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hello"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"hello" forIndexPath:indexPath];
    }
    if (indexPath.section == 0) {
        NSArray *titLabel1Arr = @[@"会员账号：",@"消费金额："];
        cell.textLabel.text = titLabel1Arr[indexPath.row];
        if (indexPath.section == 0 && indexPath.row == 0) {
            UIButton *ewmButton = [UIButton buttonWithType:0];
            ewmButton.frame = CGRectMake(ScreenWidth - 34 - 10, 8, 34, 34);
            
            UIFont *icon2font = [UIFont fontWithName:@"IconFont" size: 25];
            ewmButton.titleLabel.font = icon2font;
            [ewmButton setTitle:@"\U0000e609" forState:0];
            [ewmButton setTitleColor:[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1] forState:0];
            
            [ewmButton addTarget:self action:@selector(ewmTouch:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:ewmButton];
            _nametextfield = [[UITextField alloc]init];
            _nametextfield.keyboardType = UIKeyboardTypeNumberPad;
            _nametextfield.frame=CGRectMake(90, 10, ScreenWidth-80-60, 30);
            [self creattextField:_nametextfield withTitle:nil withplaceTitle:@"请输入会员账号"];
            
            [_nametextfield addTarget:self action:@selector(modifyLength) forControlEvents:UIControlEventAllEditingEvents];
            
            [cell addSubview:_nametextfield];
        }else if (indexPath.section == 0 && indexPath.row == 1) {
            _moneytextfield = [[UITextField alloc]init];
            _moneytextfield.frame=CGRectMake(90, 10, ScreenWidth-80-60, 30);
            _moneytextfield.keyboardType = UIKeyboardTypeNumberPad;
            [_moneytextfield addTarget:self action:@selector(showtextFiledContents) forControlEvents:UIControlEventEditingChanged];
            [self creattextField:_moneytextfield withTitle:nil withplaceTitle:@"请输入消费金额"];
            [cell addSubview:_moneytextfield];
        }
        
    }else {
        if (indexPath.row == 0) {
            NSUserDefaults *Userdefaults = [[NSUserDefaults alloc]init];
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 100, 30)];
            label1.text = [NSString stringWithFormat:@"%@%%",[Userdefaults objectForKey:@"Conversion"]];
            label1.font = [UIFont systemFontOfSize:14];
            [cell addSubview:label1];
        }else if (indexPath.row == 1){
            _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 30)];
            _numberLabel.text = @"0个";
            _numberLabel.textColor = REDCOLOR;
            [cell addSubview:_numberLabel];
        }
        NSArray *titLabel2Arr = @[@"折算比例：",@"赠送星币数量："];
        
        cell.textLabel.text = titLabel2Arr[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void) showtextFiledContents{
    NSUserDefaults *Userdefaults = [[NSUserDefaults alloc]init];
   CGFloat tempMoney = [[Userdefaults objectForKey:@"Conversion"] floatValue]*[_moneytextfield.text floatValue]/100;
    _numberLabel.text = [NSString stringWithFormat:@"%.0f个",tempMoney];
}
- (void)ewmTouch:(UIButton *)button {
    //点击二维码按钮
    ErWeiMaViewController *er = [[ErWeiMaViewController alloc] init];
    er.hidesBottomBarWhenPushed = YES;
    [er returnText:^(NSString *showText) {
        _nametextfield.text = showText;
    }];
    [self.navigationController pushViewController:er animated:YES];
}

#pragma mark 协议方法结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)payyButton:(UIButton *)button {
    if ([_moneytextfield.text isEqualToString:@""] && [_nametextfield.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入会员账号和消费金额"];
    }else if ([_moneytextfield.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入消费金额"];
    }else if ([_moneytextfield.text isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"消费金额不能为0"];
    }else if ([_nametextfield.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入会员账号"];
    }else {

        [self getDataFromNet];
        button.userInteractionEnabled = NO;
    }
        
}

- (void)modifyLength
{
    if (_nametextfield.text.length > 11) {
        _nametextfield.text = [_nametextfield.text substringToIndex:11];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_nametextfield]) {
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

//DES加密技术
static const char* encryptWithKeyAndType(const char *text, CCOperation encryptOperation,char *key)

{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
//    NSLog(@"[[item.url description] UTF8String=%@",textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
        
    }
    
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    //NSString *initIv = @"12345678";
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return [result UTF8String];
    
}

+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
//   返回加密后的数据
//    NSLog(@"加密后：%@",[NSString stringWithCString:miChar encoding:NSUTF8StringEncoding]);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end