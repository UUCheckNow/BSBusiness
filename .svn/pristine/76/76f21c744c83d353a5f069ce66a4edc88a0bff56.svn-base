//
//  BSHttpTool.h
//  Pods
//
//  Created by nyhz on 15/11/16.
//
//

#import <Foundation/Foundation.h>
@class BSUpLoadParam;
@interface BSHttpTool : NSObject
/**
 *发送get请求
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */
+(void)GET:(NSString *)URLString
parameters:(id)parameters
   success:(void (^)( id responseObject))success
   failure:(void (^)( NSError *error))failure;
/**
 *发送post请求
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */
+(void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)( id responseObject))success
    failure:(void (^)( NSError *error))failure;

/**
 *上传请求
 * urlstring 请求的基本的url
 *parameters 请求的参数字典
 * success 请求成功的回调
 *failure 请求失败的回调
 */

+(void)Upload:(NSString *)URLString
   parameters:(id)parameters uploadParam:(BSUpLoadParam *)uploadParam
      success:(void (^)( id responseObject))success
      failure:(void (^)( NSError *error))failure;

@end
