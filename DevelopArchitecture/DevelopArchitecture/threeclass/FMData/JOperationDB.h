//
//  JOperationDB.h
//  Text
//
//  Created by Jeffrey on 14-9-9.
//  Copyright (c) 2014年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface JOperationDB : NSObject
//创建表
+(BOOL)funj_createTable:(NSString*)name mainKey:(NSDictionary*)mainKey  otherKey:(NSDictionary*)otherKey;
//根据key 删除内容
+(BOOL)funj_deleteDataFromTable:(NSString*)name deleteKey:(NSDictionary*)key;
// 在表中添加新项column:@{key:text}
+(BOOL)funj_AddTableColumns:(NSString*)table column:(NSDictionary*)column;
// 显示所有内容 showkey:@[name,age]
+(NSArray*)funj_showAllDataFromTable:(NSString*)name showKey:(NSArray*)showKey;
/**
 *根据条件查找内容
 *optional:(@{@"name":@"likeA"})(@{@"name":@"=A"} @{@"name":@">=A"}...) , 注意 @{@"name":@"=A"} 等同 @{@"name":@"A"}
 * asc 或者desc 仅只能一个，另外一个为空
 * limit : 0,10 类似这样子写
 */
+(NSArray*)funj_searchDataFromTable:(NSString*)name showKey:(NSArray*)showKey withOption:(NSDictionary*)optional ascBy:(NSString*)asc descBy:(NSString*)desc limit:(NSString*)limit;
//更新或者插入数据
+(void)funj_insertData:(NSString*)tableName data:(NSDictionary*)data mainKey:(NSDictionary*)mainKey;
//判断是否有这条记录
+(BOOL)funj_isHasData:(NSString*)tableName key:(NSDictionary*)data;
//根据key 倒序获取 最新一条记录
+(NSDictionary*)funj_searchTopFirstFromTable:(NSString*)name key:(NSArray*)showKey searchKey:(NSString*)key;
@end
