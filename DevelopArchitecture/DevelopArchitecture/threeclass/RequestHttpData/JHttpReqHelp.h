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
typedef void (^failureRequest)(UIViewController*viewController,NSString* error);

//请求数据的‘  model是数据模型一个类名的字符串
@interface JHttpReqHelp : NSOperation<NSURLConnectionDataDelegate>
+(id)share;

- (JHttpReqHelp*)funj_requestMessageToServer:(UIViewController*)viewController url:(NSString*)suffixUrl values:(NSDictionary *)parameter success:(successRequest)success failure:(failureRequest)failure;

//上传图片 model是数据模型一个类名的字符串
- (JHttpReqHelp*)funj_requestImageToServers:(UIViewController*)viewController url:(NSString*)suffixUrl values:(NSDictionary *)parameter image:(UIImage *)image forKey:(NSString *)key :(NSString*)flag success:(successRequest)success failure:(failureRequest)failure;
//上传音频 model是数据模型一个类名的字符串
- (JHttpReqHelp*)funj_requestVoiceToServer:(UIViewController*)viewController :(NSString*)suffixUrl values:(NSDictionary *)parameter fileUrl:(NSURL *)fileUrl forKey:(NSString *)key success:(successRequest)success failure:(failureRequest)failure;

- (JHttpReqHelp*)funj_requestInfoToServer:(UIViewController*)viewController url:(NSString*)fullUrl values:(NSDictionary *)parameter success:(successRequest)success;

//校验网络状态
+(BOOL)funj_checkNetworkType;
//是否添加验证 结果code 校验是否正确
-(JHttpReqHelp*)funj_addVerify:(BOOL)isSuccessShow call:(BOOL)isMustLogin;

//如果需求返回参数dataArr 为类对象数组（MVC模式）时，则需要设置类名className
-(JHttpReqHelp*)funj_addModleClass:(NSString*)className;

@end
