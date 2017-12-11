

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"

// 账号帐户资料
//更改商户把相关参数后可测试

#define APP_ID          @"wx2bcea27c21a14ad1"               //APPID
#define APP_SECRET      @"c1635f96a65e8bf31114721af3ef5ecd" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1279873701"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"liushan8855411327198805064213bsw"
//支付结果回调页面
#define NOTIFY_URL      @"http://116.255.246.239:9001.com/api/weiXinNotify.aspx"
//测试回调
//#define NOTIFY_URL      @"http://bsw.3w.net579.com/api/weiXinNotify.aspx"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"


@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;
    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
    
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- ( NSMutableDictionary *)sendPay_demo;

@property (nonatomic, retain)NSString *order_price;


@end