//
//  JBaseInterfaceManager.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2017/5/24.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHttpReqHelp.h"
#import "JBaseDataModel.h"
#import "JBaseView.h"
#import "JBaseViewController.h"


typedef NS_ENUM(NSInteger,MBProgressHUDTitleType) {
    kDATALOADING,      // 数据加载中...
    kDATAREQUESTING,   // 数据请求中...
    kDATADELETEING,    // 数据删除中...
    kDATAPROCESSING,   // 数据处理中...
    kDATAREMOVEING,    // 移除中...
    kDATACOMMITTING,   // 数据提交中...
    kDATACREATING,     // 创建中...
    kDATAMODIFYING,    // 修改中...
    kDATASEARCHING,    // 查询中...
    kDATAUPLOADING,    // 上传中...
    kDATALOGINING,     // 登录中...
    kDATAREGISTING     // 注册中...
};



//本类是数据管理类。处理数据的类

@interface JBaseInterfaceManager : NSObject
 
//验证返回信息是否成功
+(BOOL)funj_VerifyIsSuccessful:(NSDictionary *)data show:(BOOL)isSuccessShow callVC:(id)viewcontroller;
 //退出登陆状态
+(void)funj_didLogoutAccount:(id)viewController;

@end
