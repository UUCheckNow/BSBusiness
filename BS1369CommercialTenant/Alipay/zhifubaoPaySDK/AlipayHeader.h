//
//  AlipayHeader.h
//  ytx
//
//  Created by valor on 15/11/17.
//  Copyright © 2015年 JY. All rights reserved.
//

#ifndef AlipayHeader_h
#define AlipayHeader_h



#import <AlipaySDK/AlipaySDK.h>     // 导入AlipaySDK
#import "AlipayRequestConfig.h"     // 导入支付类
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类：获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode

#import <Foundation/Foundation.h>   // 导入Foundation，防止某些类出现类似：“Cannot find interface declaration for 'NSObject', superclass of 'Base64'”的错误提示


/**
 *  partner:合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。
 *
 */
//其他公司的PID
//#define kPartnerID @"2088021230746498"
//河南尼德的PID
#define kPartnerID @"2088221262988297"

/**
 *  seller:支付宝收款账号,手机号码或邮箱格式。
 */
//#define kSeller @"xmgj1369@163.com"
//河南尼德的收款账号
#define kSeller @"zhangyu@bs1369.com"


/**
 *  支付宝服务器主动通知商户 网站里指定的页面 http 路径。
 */
#define kNotifyURL @"http://116.255.246.239:9001/api/business/addBusinessStarNote.ashx"

//回调测试链接
//#define kNotifyURL @"http://bsw.3w.net579.com/api/business/addBusinessStarNote.ashx"


/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"BS1369CommercialTenant"


/**
 *  private_key:商户方的私钥,pkcs8 格式。
 */
//#define kPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANQ3F9g+z0DG+HsxDeRldgMvpGrYLYlIzUOEgh+ssnX/SQ68mX5itE922dDTzrHIxvIUZeb08vR6uTC5V08n1ccTR3Kg3Wsdpb9bRE+LnvA7qIFOSqoEzAoEy2fEXgatpI1ka3VoS21otl7bVaM3VqSsmKrgX+2t+7ni4sSVckRhAgMBAAECgYEAsImwXWVK1lFvblQNgX3iIZ5lgbiakQUuNMer1Bu/Tifzp72/VwNXim+NnYpF/WHQFpxfdTU6U6UwH9dfSWsTC4fNIgZiFj58+zWGdZsMqLCg1uQtCRsLNLukB8ko9QKV7YmNlYGUECx1iRZj6FfWdtfLi5TErhwZAcZLCszW71ECQQDz30VHrVJzxr7hmjHFnV4RgyCY8y6OFlM7deTbk1/E+MJHR4OQsOBF+xQzsOe5vdK9fxv0T9xEVHfxKk7ZVBR9AkEA3sTMg1lnxvbLwovxEtRsg416HcIkShEzG7EDQh4PL7rjpDWGWEZdaDMomkZtT1T+UzfDbU20A2uC4N+hV/FotQJBAMLyVypuJfxBAvPLVEA5hSoQnW1G8I9Kz2w32SOh0qvdg0iBpW1zx0SJ6mNL5mF3mdA7nPgXIuhIcb0Kag+XA+0CQC0q6eyX7BrDX30Kss6Gk5n4zZHLE2CRLDOpKGf3gEzFL/LTh3HOkpHWDZ16Oh+jtA1beRxobN9kpRzDOwuBvyECQAl2V4jAKJebCmSVD15OLgKdsSD5PrYv9/d5j6whPjQsfM73e1T0NscclYbJQwJWd/tHxPDWz7e6DT+0y+RAbCo="

//河南尼德的私钥
//调不起来的秘钥
//#define kPrivateKey @"MIICXAIBAAKBgQCrr6w2KxsK1Aui3JOVG+guv6wGZDpwAGZWAOF9zaIq++0N1KYe+d2SIcYETvQn2cG6XMUc/91kXTZcswl9bR6X6A/FwdVvpHH8Yy6Bwl27ldaDsKXuSmTDuHkM1EqK+jUh2khhKmMRcMh8HlDT41c00qa8Mcgi3m0lI/IPc8wX9wIDAQABAoGAKitG8DMcPEei6Ainkys8lybq+NLra5Edkag7umuklkw0iH4fo2IZ4we6nFpMK/GXXM/mdl3+IeWnMZOkFBOWPLBzwFxmZ2pRisCVMlAN/VV0C5cvsQgN8oay4QWVct7E6ucWioPd8bZRX1XPriDKEUmVtNJde0W9JkRogCa67KECQQDXZVB8uUS+btPo/cXqe3BjwIcJrWQ7IqxgdkVpoFDGEQsrMUg9+Dlqg0nCoqHE9GHZdNRWFNq2CHrTrd8rZ2znAkEAzAz/6j2doaCqhNi5mM43nH2hQCpkwPsm5zNGAHgftHBFoZjQNLEc0bk4CGSkhYiYCk6rN3mfCRqqcqNAV3wKcQJBAL0QM/7WTE3vT9hh8Dgqk3MrihxncuQpQi8FgVX+nwfL7AbEokmquRMSHEtYnzAW5lCOqNbKRVOky9ND+fDKPp8CQDZheIq65RnAMfG5uKzquJNyP9lT8wojZRjU52EUoo56JXSNv19rnFygWjiSae5UmwCUOrlMJoBMpQRsUad/HWECQBxuxvtukAtsz6mErCAfBHZCjo9buNkHTuml41geWudkmOwRDdOShhUTkK4G3oul+xIqagLe/N/KjzuKbw0Rk5c="

//正常秘钥
#define kPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKuvrDYrGwrUC6Lck5Ub6C6/rAZkOnAAZlYA4X3Noir77Q3Uph753ZIhxgRO9CfZwbpcxRz/3WRdNlyzCX1tHpfoD8XB1W+kcfxjLoHCXbuV1oOwpe5KZMO4eQzUSor6NSHaSGEqYxFwyHweUNPjVzTSprwxyCLebSUj8g9zzBf3AgMBAAECgYAqK0bwMxw8R6LoCKeTKzyXJur40utrkR2RqDu6a6SWTDSIfh+jYhnjB7qcWkwr8Zdcz+Z2Xf4h5acxk6QUE5Y8sHPAXGZnalGKwJUyUA39VXQLly+xCA3yhrLhBZVy3sTq5xaKg93xtlFfVc+uIMoRSZW00l17Rb0mRGiAJrrsoQJBANdlUHy5RL5u0+j9xep7cGPAhwmtZDsirGB2RWmgUMYRCysxSD34OWqDScKiocT0Ydl01FYU2rYIetOt3ytnbOcCQQDMDP/qPZ2hoKqE2LmYzjecfaFAKmTA+ybnM0YAeB+0cEWhmNA0sRzRuTgIZKSFiJgKTqs3eZ8JGqpyo0BXfApxAkEAvRAz/tZMTe9P2GHwOCqTcyuKHGdy5ClCLwWBVf6fB8vsBsSiSaq5ExIcS1ifMBbmUI6o1spFU6TL00P58Mo+nwJANmF4irrlGcAx8bm4rOq4k3I/2VPzCiNlGNTnYRSijnoldI2/X2ucXKBaOJJp7lSbAJQ6uUwmgEylBGxRp38dYQJAHG7G+26QC2zPqYSsIB8EdkKOj1u42QdO6aXjWB5a52SY7BEN05KGFROQrgbei6X7EipqAt7838qPO4pvDRGTlw=="

#endif
