//
//  BuildConfig.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/20.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#ifndef DevelopArchitecture_BuildConfig_h
#define DevelopArchitecture_BuildConfig_h


//测试服务器地址
#define APP_URL_ROOT [NSString stringWithFormat:@"%@api/", [[[NSBundle  mainBundle]infoDictionary] objectForKey:@"APP_ROOT_URL"]]

//当前是否为企业版
#define currentIsEEVersion [[[[NSBundle  mainBundle]infoDictionary] objectForKey:@"CFBundleIdentifier"] isEqualToString:@"com.mizholdings.DevelopArchitecture"]

#define kUserLoginDB @"kUserLoginDB"

#endif


