//
//  JFileManageHelp.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/3/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JFileManageHelp.h"
#import "JBaseDataModel.h"
#import "JAppUtility.h"
static JFileManageHelp *fileManage=nil;
@implementation JFileManageHelp
-(id)init{
    if(self=[super init]){
        
    }
    return self;
}
+(id)shareFile{
    if(!fileManage){
        fileManage=[[JFileManageHelp alloc]init];
    }
    return fileManage;
}
-(id)funj_getLocaleDataWithName:(NSString*)fileName model:(NSString*)model{
    if(![JAppUtility funj_isFileExit:[JAppUtility funj_getTempPath:@"savefile":nil]]){
        [JAppUtility funj_createDirector:[JAppUtility funj_getTempPath:@"savefile":nil]];
    }
    NSString *path=[JAppUtility funj_getTempPath:@"savefile" :fileName];
    NSData *content=[NSData dataWithContentsOfFile:path];
    if(content){
        id jsonObject=[NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        if(model && [jsonObject isKindOfClass:[NSArray class]]){
            NSArray *arr=(NSArray*)jsonObject;
            NSMutableArray *allData = [[NSMutableArray alloc] init];
            for(int i=0;i<[arr count];i++){
                id currentModel = [[NSClassFromString(model) alloc] initWithContent:arr[i]];
                [allData addObject:currentModel];
            }
            return allData;
        }else if(model &&[jsonObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dic=(NSDictionary*)jsonObject;
            NSMutableDictionary *mutableDic=[[NSMutableDictionary alloc]init];
            [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSMutableArray *allData = [[NSMutableArray alloc] init];
                if([obj isKindOfClass:[NSArray class]]){
                    NSArray *arr=(NSArray*)obj;
                    for(int i=0;i<[arr count];i++){
                        id currentModel = [[NSClassFromString(model) alloc] initWithContent:arr[i]];
                        [allData addObject:currentModel];
                    }
                    [mutableDic setObject:allData forKey:key];
                }else if([obj isKindOfClass:[NSDictionary class]]){
                    id currentModel = [[NSClassFromString(model) alloc] initWithContent:obj];
                    [mutableDic setObject:currentModel forKey:key];
                }
            }];
            return mutableDic;
        }
        return jsonObject;
    }
    return nil;
    
}
-(BOOL)funj_saveToLocaleData:(NSString*)fileName data:(id)content model:(NSString*)model{
    NSString *path=[JAppUtility funj_getTempPath:@"savefile" :fileName];
    if(![JAppUtility funj_isFileExit:[JAppUtility funj_getTempPath:@"savefile":nil]]){
        [JAppUtility funj_createDirector:[JAppUtility funj_getTempPath:@"savefile":nil]];
    }
    if([content isKindOfClass:[NSDictionary class]] || [content isKindOfClass:[NSArray class]] || [content isKindOfClass:[NSString class]]){
        if(model && [content isKindOfClass:[NSArray class]]){
            NSArray *arr=(NSArray*)content;
            NSMutableArray *array=[[NSMutableArray alloc]init];
            for(int i=0;i<[arr  count];i++){
                if([arr[i] isKindOfClass:[JBaseDataModel class]]){
                    JBaseDataModel *dataModel=(JBaseDataModel*)arr[i];
                    [array addObject:[dataModel funj_getDicFromModel]];
                }else continue;
            }
            NSData *mydata=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil ];
            BOOL res= [mydata writeToFile:path atomically:YES];
            return res;
        }else if(model && [content isKindOfClass:[NSDictionary class]]){
            NSDictionary *dic=(NSDictionary*)content;
            NSMutableDictionary *mutableDic=[[NSMutableDictionary alloc]init];
            [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if([obj isKindOfClass:[NSArray class]]){
                    NSArray *arr=(NSArray*)obj;
                    NSMutableArray *array=[[NSMutableArray alloc]init];
                    for(int i=0;i<[arr count];i++){
                        if([arr[i] isKindOfClass:[JBaseDataModel class]]){
                            JBaseDataModel *dataModel=(JBaseDataModel*)arr[i];
                            [array addObject:[dataModel funj_getDicFromModel]];
                        }else continue;
                    }
                    [mutableDic setObject:array forKey:key];
                }else if([obj isKindOfClass:[JBaseDataModel class]]){
                    JBaseDataModel *dataModel=(JBaseDataModel*)obj;
                    [mutableDic setObject:[dataModel funj_getDicFromModel] forKey:key];
                }
            }];
            NSData *mydata=[NSJSONSerialization dataWithJSONObject:mutableDic options:NSJSONWritingPrettyPrinted error:nil ];
            BOOL res= [mydata writeToFile:path atomically:YES];
            return res;
        }else{
            NSData *mydata=[NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil ];
            BOOL res= [mydata writeToFile:path atomically:YES];
            return res;
        }
    }
    return NO;
    
}
@end
