//
//  ErWeiMaViewController.m
//  bs1369
//
//  Created by bsmac1 on 15/11/3.
//  Copyright © 2015年 bsw. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "UINavigationBar+Awesome.h"
#import <AVFoundation/AVFoundation.h>
#import "BSSetNavigationView.h"

#import "SVProgressHUD.h"
#import "Common.h"
#import "XingbiRecordVC.h"

#define kScreenW    [UIScreen mainScreen].bounds.size.width
#define kScreenH    [UIScreen mainScreen].bounds.size.height
@interface ErWeiMaViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) AVCaptureDevice *device;//采集用的硬件
@property (nonatomic,strong) AVCaptureDeviceInput *input;//输入管道
@property (nonatomic,strong) AVCaptureSession *session;//会话
@property (nonatomic,strong) AVCaptureMetadataOutput *output;//输出数据

@property (nonatomic,strong) UIView *preView;

@property (nonatomic,weak) UIImageView *animationView;//动画的视图

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
        //取消view的延伸效果
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //显示预览层
    self.preView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.preView];
    
    //添加边框
    UIImage *image = [UIImage imageNamed:@"qrcode_border"];
    //对图片进行四角拉伸
    UIImage *borderImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 52, 52) resizingMode:UIImageResizingModeStretch];
    
    NSInteger margin = 70;
    NSInteger imageW = self.view.frame.size.width - margin * 2;
    //显示边框的imagerview
    UIImageView *boundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageW)];
    boundView.center = self.view.center;
    [boundView setImage:borderImage];
    [self.view addSubview:boundView];
    
    //添加上移动的动画的imageview
    UIImageView *animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_scan_line"]];
    animationView.frame = boundView.bounds;
    [boundView addSubview:animationView];
    self.animationView = animationView;
    
    //剪切掉子视图
    boundView.clipsToBounds = YES;
    
    
    //设置计时器
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(changAnimation:) userInfo:nil repeats:YES];
    
    [self setNav];
}
- (void)setNav
{
    BSSetNavigationView *setNavg = [BSSetNavigationView navigationWithLeftImageName:@"head_back" centerTitleName:@"二维码" andFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    setNavg.backgroundColor = [UIColor clearColor];
    setNavg.titleLabel.textColor = [UIColor whiteColor];
    setNavg.delegateVC = self;
    
    [self.view addSubview:setNavg];
    
    
    UILabel *bottomTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 33)];
    bottomTitle.text = @"请将二维码置于取景框内扫描";
    bottomTitle.textAlignment = NSTextAlignmentCenter;
    bottomTitle.textColor = [UIColor whiteColor];
    bottomTitle.center = CGPointMake(kScreenW * 0.5, kScreenH - 40);
    [self.view addSubview:bottomTitle];
    
}

- (void)changAnimation:(NSTimer *)timer
{
    self.animationView.frame = CGRectOffset(self.animationView.frame, 0, 5.f);
    if (self.animationView.frame.origin.y >= self.animationView.frame.size.height) {
        self.animationView.frame = CGRectOffset(self.animationView.frame, 0, - self.animationView.frame.size.height * 2);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //开启二维码服务
    [self reading];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //停止二维码扫描
    [self stop];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - custom
- (void)reading
{
    //1.构造device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.构造input
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    //3.构造output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //4.添加input和output到session
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //5.设置out的支持的类型和代理
    [self.output setMetadataObjectTypes:@[
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeCode39Code,
                                          AVMetadataObjectTypeQRCode
                                          ]];
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    
    
    //预览层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.preView.layer addSublayer:layer];
    
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer setFrame:self.preView.bounds];
    
    //添加遮罩层
    UIGraphicsBeginImageContextWithOptions(self.preView.bounds.size, NO, [[UIScreen mainScreen] scale]);
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加外层的半透明效果
    //设置半透明填充色
    CGContextSetRGBFillColor(context, 0, 0, 0, .9f);
    //绘制矩形区域
    CGContextAddRect(context, self.preView.bounds);
    //填充内容
    CGContextFillPath(context);
    //上面的代码生成了一个整个屏幕的白乎乎的半透明效果
    
    //绘制中间完全不透明区域
    //设置填充色
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.f);
    //在边框区域填充颜色
    CGContextAddRect(context, self.animationView.superview.frame);
    //绘制内容
    CGContextFillPath(context);
    //上面代码生成了一个中间一个矩形区域是透明的，周围都是有白色阴影的
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.bounds = self.preView.bounds;
    maskLayer.position = self.preView.center;
    maskLayer.contents = (__bridge id)(image.CGImage);
    layer.mask = maskLayer;
    layer.masksToBounds = YES;
    
    
    //开启服务
    [self.session startRunning];
}
- (void)stop
{
    [self.session stopRunning];
}
#pragma mark - QRCode delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count != 0) {
        AVMetadataMachineReadableCodeObject *code = metadataObjects[0];
        [connection setEnabled:NO];
        if (code.stringValue) {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                    (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [connection setEnabled:YES];
                if (self.returnTextBlock != nil) {
                    self.returnTextBlock([[code.stringValue componentsSeparatedByString:@"/"] lastObject]);
                }
                    [self.navigationController popViewControllerAnimated:YES];
               
            });
        } else {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                    (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [connection setEnabled:YES];
                [SVProgressHUD showErrorWithStatus:@"扫码有误！"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

- (void)returnText:(ReturnTextBlock)block {
    
    self.returnTextBlock = block;
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
