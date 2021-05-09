//
//  DESBase64.h
//  Text
//
//  Created by Jeffrey on 15/8/12.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDESBase64 : NSObject

/************************************************************
 函数名称 : + (NSString *)funj_encryptionWithbase64:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 **********************************************************/
+ (NSString *)funj_encryptionWithbase64:(NSString *)text k:(NSString*)key;

/************************************************************
 函数名称 : + (NSString *)funj_decryptionFromBase64:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 **********************************************************/
+ (NSString *)funj_decryptionFromBase64:(NSString *)base64 k:(NSString*)key;


#pragma detail
/************************************************************
 函数名称 : + (NSData *)funj_DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
+ (NSData *)funj_DESEncrypt:(NSData *)data k:(NSString *)key;

/************************************************************
 函数名称 : + (NSData *)funj_DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
+ (NSData *)funj_DESDecrypt:(NSData *)data k:(NSString *)key;

/************************************************************
 函数名称 : + (NSData *)funj_dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 **********************************************************/
+ (NSData *)funj_dataWithBase64EncodedString:(NSString *)string;

/************************************************************
 函数名称 : + (NSString *)funj_base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 **********************************************************/
+ (NSString *)funj_base64EncodedStringFrom:(NSData *)data;

+ (NSString *)funj_hmacsha1:(NSString *)data k:(NSString *)key;
@end
