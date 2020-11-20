//
//  JLoginUserModel.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/23.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JLoginUserModel.h"
#import "JConstantHelp.h"
#import "JAppUtility.h"
#import "JOperationDB.h"
#import "NSDictionary+JSON.h"

static NSMutableDictionary * userDic =nil;
@interface JLoginUserModel()
@end
@implementation JLoginUserModel

+(void)funj_setUserDicData:(BOOL)isReload{
    if(!userDic){
        userDic =[[NSMutableDictionary alloc]init];
    }
    if(isReload){
        [userDic removeAllObjects];
    }
}
//目前只适合 登录与环信登录 分开保存，
//{@"islogining":@"0"}
+(void)funj_insertLoginUserMessage:(NSDictionary*)data{
    if(!data || !data[@"userId"]) return;
    
    NSMutableDictionary *idKeyDic =[[NSMutableDictionary alloc]init];
    for(NSString *name in [self getItems]){
        if([name isEqualToString:@"userId"])continue;
        [idKeyDic setObject:@"text" forKey:name];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JOperationDB funj_createTable:kUserLoginDB mainKey:@{@"userId":@"text"}
                         otherKey:idKeyDic];
    });
    NSString *serverTime =[JAppUtility funj_getDateTime:@"yyyyMMddHHmmss"];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:data];
    [dic setObject:serverTime forKey:@"serverTime"];
    
    [JOperationDB funj_insertData:kUserLoginDB data:dic mainKey:@{@"userId":[dic objectForKey:@"userId"]}];
    
    [self funj_setUserDicData:YES];
    
}
+(NSDictionary*)funj_getLastLoginUserMessage{
    [self funj_setUserDicData:NO];
    
    if([userDic count] >0){
        return userDic;
    }
    NSDictionary *dic= [JOperationDB funj_searchTopFirstFromTable:kUserLoginDB :[self getItems] searchKey:@"serverTime"];
    [userDic addEntriesFromDictionary:dic];
    return (dic && [dic count]>0) ? userDic : [NSMutableDictionary dictionary];
}
+(NSMutableDictionary*)funj_getLastLoginTokenMessage{
    [self funj_setUserDicData:NO];
    if( [userDic count]>0){
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        if([[userDic objectForKey:@"isLogining"]isEqualToString:@"1"]){
            [dic setObject:userDic[@"token"] forKey:@"token"];
        }else{
            [dic setObject:@"" forKey:@"token"];
        }
        return dic;
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self funj_getLastLoginUserMessage];
        });
    }
    
    NSMutableDictionary*dic = (NSMutableDictionary*)[JOperationDB funj_searchTopFirstFromTable:kUserLoginDB :@[@"token",@"isLogining"] searchKey:@"serverTime"];
    if(dic && [dic count]>0){
        if(![[dic objectForKey:@"isLogining"]isEqualToString:@"1"]){
            [dic setObject:@"" forKey:@"token"];
        }
        [dic removeObjectForKey:@"isLogining"];
    }
    
    return dic;
}
+(BOOL)funj_getIsLogining{
    NSDictionary *dic = [self funj_getLastLoginUserMessage];
    return [dic integerWithKey:@"isLogining"] == 1;
}
+(void)funj_deleteUserMessage:(NSDictionary*)data{
    [JOperationDB funj_deleteDataFromTable:kUserLoginDB deleteKey:data];
    [self funj_setUserDicData:YES];
}
+(NSArray*)getItems{
    return @[@"userId",@"photoId",@"nickName",@"mySign",@"password",
             @"serverTime",@"token",@"userType",@"userName",@"cloudId",
             @"isLogining",@"phone",@"account",@"isaccountlogin",@"originalPassCode",
             @"schoolName",@"sex",@"schoolId",@"photoPath",@"cloud_usr_account",@"relPhone"];
}

@end
