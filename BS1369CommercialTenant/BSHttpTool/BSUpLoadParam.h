//
//  BSUpLoadParam.h
//  Pods
//
//  Created by nyhz on 15/11/16.
//
//

#import <Foundation/Foundation.h>

@interface BSUpLoadParam : NSObject

/**
 *上传文件的二进制数据
 */
@property (nonatomic,strong) NSData *data;
/**
 *上传的参数名称
 */
@property (nonatomic,copy) NSString *name;
/**
 *上传到服务器的文件名称
 */
@property (nonatomic,copy) NSString *fileName;
/**
 *上传文件的类型
 */
@property (nonatomic,copy) NSString *nameType;
@end
