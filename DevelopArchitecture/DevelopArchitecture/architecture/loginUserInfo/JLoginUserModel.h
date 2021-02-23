//
//  JLoginUserModel.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/23.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBaseDataModel.h"
#import "JOperationDB.h"
@interface JLoginUserModel : JBaseDataModel
+(void)funj_insertLoginUserMessage:(NSDictionary*)data;
+(NSDictionary*)funj_getLastLoginUserMessage;
+(NSMutableDictionary*)funj_getLastLoginTokenMessage;//这个方法是只得到Token
+(void)funj_deleteUserMessage:(NSDictionary*)data;

+(BOOL)funj_getIsLogining;
@end
