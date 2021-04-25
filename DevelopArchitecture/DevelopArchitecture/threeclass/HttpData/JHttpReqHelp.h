//
//  JHttpReqHelp.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"

typedef void (^successRequest)(id viewController,NSArray * dataArr,NSDictionary*dataDic);
typedef void (^successRequestm)(id viewController,NSArray * dataArr,id dataModel);
typedef void (^failureRequest)(UIViewController*viewController,NSString* error);

//请求数据的‘  model是数据模型一个类名的字符串
@interface JHttpReqHelp : NSOperation<NSURLConnectionDataDelegate>
+(id)share;
//可选 部分如果使用其他url 可调用此方法，并且需要首先调用
- (JHttpReqHelp*)funj_setRootURL:(NSString*)rootURL;

- (JHttpReqHelp*)funj_requestToServer:(UIViewController*)viewController url:(NSString*)suffixUrl v:(NSDictionary*)parameter;

//上传图片 model是数据模型一个类名的字符串
- (JHttpReqHelp*)funj_requestImageToServers:(UIViewController*)viewController url:(NSString*)suffixUrl v:(NSDictionary *)parameter image:(UIImage *)image forKey:(NSString *)imagekey :(NSString*)flag;
//上传音频 model是数据模型一个类名的字符串
- (JHttpReqHelp*)funj_requestVoiceToServer:(UIViewController*)viewController url:(NSString*)suffixUrl v:(NSDictionary *)parameter fileUrl:(NSURL *)fileUrl forKey:(NSString *)voicekey;

//校验网络状态
+(BOOL)funj_checkNetworkType;
//是否添加验证 结果code 校验是否正确
-(JHttpReqHelp*)funj_addVerify:(BOOL)isSuccessShow call:(BOOL)isMustLogin;
//添加回调方法 成功返回
-(JHttpReqHelp*)funj_addSuccess:(successRequest)success;
//添加回调方法 失败返回
-(JHttpReqHelp*)funj_addFailure:(failureRequest)failure;

//如果需求返回参数dataArr 为类对象数组（MVC模式）时，则需要设置类名className
-(JHttpReqHelp*)funj_addModleClass:(NSString*)className c:(successRequestm)success;

@end
