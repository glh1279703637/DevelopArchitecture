//
//  JOperationDB.m
//  Text
//
//  Created by Jeffrey on 14-9-9.
//  Copyright (c) 2014年 Jeffrey. All rights reserved.
//



#import "JOperationDB.h"

#define kdocumentDBPath   [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/DevelopArchitecture.db"]]

@implementation JOperationDB

//创建表
+(BOOL)funj_createTable:(NSString*)name mainKey:(NSDictionary*)mainKey  otherKey:(NSDictionary*)otherKey{
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return NO;
    }
    NSMutableString *sql=[[NSMutableString alloc]initWithFormat:@"CREATE TABLE IF NOT EXISTS %@(",name];
    NSMutableString *keyStr=[[NSMutableString alloc]init];
    [mainKey enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [sql appendFormat:@"%@ %@,",key,obj];
        [keyStr appendFormat:@"%@",key ];
    }];
    
    [otherKey enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [sql appendFormat:@" %@ %@,",key,obj];
    }];
    
    [sql appendFormat:@"primary key(%@)",keyStr];
    [sql appendString:@")"];
    [db executeUpdate:sql];
    [db close];
    return YES;
    
}

+(BOOL)funj_deleteDataFromTable:(NSString*)name deleteKey:(NSDictionary*)key{
    
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return NO;
    }
    
    NSMutableString *sql=[[NSMutableString alloc]initWithFormat:@"delete from %@ where",name];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [key enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [sql appendFormat:@" %@ =? and",key];
        [array addObject:obj];
    }];
    
    [sql deleteCharactersInRange:NSMakeRange(sql.length-4,4)];
    
    if ([db executeUpdate:sql withArgumentsInArray:array]) {
        [db close];
        return YES;
    }
    [db close];
    
    return NO;
    
}
+(BOOL)funj_AddTableColumns:(NSString*)table :(NSDictionary*)column{
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return NO;
    }
    for(NSString *key in column.allKeys){
        NSString *sql=[[NSString alloc]initWithFormat:@"alter table %@ add %@ %@",table,key ,[column objectForKey:key]];
        [db executeUpdate:sql];
    }
    [db close];
    return YES;
}

+(NSArray*)funj_showAllDataFromTable:(NSString*)name showKey:(NSArray*)showKey{
    
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return nil;
    }
    NSMutableString *strs=[[NSMutableString alloc]init];
    for(int i=0;i<[showKey count];i++){
        [strs appendFormat:@"%@,",showKey[i] ];
    }
    if(strs.length>1)
        [strs deleteCharactersInRange:NSMakeRange(strs.length-1, 1)];
    NSString *sql=[[NSString alloc]initWithFormat:@"select %@ from %@",strs,name];
    FMResultSet *rs=[db executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:10];
    
    while([rs next]) {
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:10];
        for(int i=0;i<[showKey count];i++){
            NSString *value = [rs objectForColumnName:showKey[i]];
            if(![value isKindOfClass:[NSNull class]] && ![value isEqualToString:@"<null>"]){
                [dic setObject:[rs objectForColumnName:showKey[i]] forKey:showKey[i]];
            }else{
                [dic setObject:@"" forKey:showKey[i]];
            }

        }
        [array addObject:dic ];
    }
    
    
    [db close];
    
    return array;
    
}
+(NSArray*)funj_searchDataFromTable:(NSString*)name showKey:(NSArray*)showKey withOption:(NSDictionary*)optional ascBy:(NSString*)asc descBy:(NSString*)desc limit:(NSString*)limit{
    
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return nil;
    }
    NSMutableString *strs=[[NSMutableString alloc]init];
    for(int i=0;i<[showKey count];i++){
        [strs appendFormat:@"%@,",showKey[i] ];
    }
    if(strs.length>1)
        [strs deleteCharactersInRange:NSMakeRange(strs.length-1, 1)];
    NSMutableString *sql=[[NSMutableString alloc]initWithFormat:@"select %@ from %@",strs,name];
    if([optional count]>0){
        [sql appendString:@" where"];
        [optional enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([obj hasPrefix:@"<="]){
                [sql appendFormat:@" %@ <= '%@' and",key,[obj substringFromIndex:2] ];
            }else if([obj hasPrefix:@">="]){
               [sql appendFormat:@" %@ >= '%@' and",key,[obj substringFromIndex:2] ];
            }else if([obj hasPrefix:@"="]){
                [sql appendFormat:@" %@ = '%@' and",key,[obj substringFromIndex:1] ];
            }else if([obj hasPrefix:@">"]){
                [sql appendFormat:@" %@ > '%@' and",key,[obj substringFromIndex:1] ];
            }else if([obj hasPrefix:@"<"]){
                [sql appendFormat:@" %@ < '%@' and",key,[obj substringFromIndex:1] ];
            }else if([obj hasPrefix:@"like"]){
                [sql appendFormat:@" %@ like '%%%@%%' and",key,[obj substringFromIndex:4] ];
            }else{
                [sql appendFormat:@" %@ = '%@' and",key,obj];
            }
        }];
        [sql deleteCharactersInRange:NSMakeRange(sql.length-4, 4)];
    }
    if(asc&&asc.length>0){
        [sql appendFormat:@" order by %@ asc",asc ];
    }else if(desc&&desc.length>0){
        [sql appendFormat:@" order by %@ desc",desc ];
    }
    if(limit){
        [sql appendFormat:@" limit %@",limit ];
    }

    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:10];
    FMResultSet *rs=[db executeQuery:sql];
    while([rs next]) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:10];
        for(int i=0;i<[showKey count];i++){
            NSString *value = [rs objectForColumnName:showKey[i]];
            if(![value isKindOfClass:[NSNull class]] && ![value isEqualToString:@"<null>"]){
                [dic setObject:[rs objectForColumnName:showKey[i]] forKey:showKey[i]];
            }else{
                [dic setObject:@"" forKey:showKey[i]];
            }
        }
        [array addObject:dic ];
    }
    
    
    [db close];
    
    return array;
    
}
+(void)funj_insertData:(NSString*)tableName data:(NSDictionary*)data mainKey:(NSDictionary*)mainKey{
    
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return  ;
    }
    
    NSMutableString *sql=[[NSMutableString alloc]init];
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    if([JOperationDB funj_isHasData:tableName key:mainKey]){
        [sql  appendFormat:@"UPDATE %@ SET ",tableName];
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSArray *arrayss=[mainKey allKeys];
            if( [arrayss indexOfObject:key]>[arrayss count]){
                [sql appendFormat:@"%@ = ?, ",key];
                [dataArr  addObject:obj];
            }
        }];
        [sql deleteCharactersInRange:NSMakeRange(sql.length-2,2)];
        [sql appendString:@" where"];
        [mainKey enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [sql appendFormat:@" %@ = ? and",key];
            [dataArr  addObject:obj];
        }];
        [sql deleteCharactersInRange:NSMakeRange(sql.length-4,4)];
        [db executeUpdate:sql withArgumentsInArray:(NSArray*)dataArr];
        
    }else{
        [dataArr removeAllObjects];
        [sql appendFormat:@"INSERT INTO %@(",tableName];
        NSMutableString *keyStr=[[NSMutableString alloc]init],*dataStr=[[NSMutableString alloc]init];
        NSMutableDictionary *main_data=[[NSMutableDictionary alloc]initWithDictionary:mainKey];
        [main_data addEntriesFromDictionary:data];
//       __block NSString *strss = @"";
        [main_data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [keyStr appendFormat:@"%@,",key];
            [dataStr appendFormat:@"?,"];
            [dataArr addObject:obj];
//            strss = [strss stringByAppendingFormat:@"\"%@\",",obj];
        }];
        [keyStr deleteCharactersInRange:NSMakeRange(keyStr.length-1,1)];
        [dataStr deleteCharactersInRange:NSMakeRange(dataStr.length-1,1)];
        [sql appendString:keyStr];
        [sql appendString:@") values ("];
        [sql appendString:dataStr];
        [sql appendString:@")"];
        [db executeUpdate:sql withArgumentsInArray:dataArr];
    }
    
    [db close];
    
}

+(BOOL)funj_isHasData:(NSString*)tableName key:(NSDictionary*)data{
    
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return NO;
    }
    
    NSMutableString *sql=[[NSMutableString alloc]initWithFormat:@"select count(*) from %@ where",tableName];
    
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [sql appendFormat:@" %@ ='%@' and",key,obj];
    }];
    [sql deleteCharactersInRange:NSMakeRange(sql.length-4,4)];
    
    FMResultSet *rs=[db executeQuery:sql];
    while (rs.next) {
        if([rs intForColumnIndex:0]>0) { [db close ];return YES;}
    }
    [db close];
    
    return NO;
    
}
+(NSDictionary*)funj_searchTopFirstFromTable:(NSString*)name :(NSArray*)showKey searchKey:(NSString*)key{
    FMDatabase*db = [FMDatabase databaseWithPath:kdocumentDBPath];
    
    if (![db open]) {
        return nil;
    }
    NSMutableString *strs=[[NSMutableString alloc]init];
    for(int i=0;i<[showKey count];i++){
        [strs appendFormat:@"%@,",showKey[i] ];
    }
    if(strs.length>1)
        [strs deleteCharactersInRange:NSMakeRange(strs.length-1, 1)];
    NSMutableString *sql=[[NSMutableString alloc]initWithFormat:@"select %@ from %@ order by %@ desc limit 1",strs,name,key];
    
    FMResultSet *rs=[db executeQuery:sql];
    
     NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:1];
    while([rs next]) {
        for(int i=0;i<[showKey count];i++){
            NSString *value = [rs objectForColumnName:showKey[i]];
            if(![value isKindOfClass:[NSNull class]] && ![value isEqualToString:@"<null>"]){
                [dic setObject:[rs objectForColumnName:showKey[i]] forKey:showKey[i]];
            }else{
                [dic setObject:@"" forKey:showKey[i]];
            }
        }break;
     }
    
    [db close];
    
    return dic ;
    
}
@end

