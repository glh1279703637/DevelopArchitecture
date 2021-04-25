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

-(BOOL)funj_saveToLocaleData:(NSString*)fileName data:(id)content{
    [self funj_checkIsFile];
    NSString *path = [JAppUtility funj_getTempPath:@"savefile" :fileName];
    id data = [self funj_solverToSaveFile:content a:YES];
    BOOL res = [self funj_saveDataToFile:data p:path];
    return res;
}
-(id)funj_getLocaleDataWithName:(NSString*)fileName{
    [self funj_checkIsFile];
    NSString *path = [JAppUtility funj_getTempPath:@"savefile" :fileName];
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if(data){ return  data ;}
    
    data = [NSArray arrayWithContentsOfFile:path];
    if(!data) data = [NSDictionary dictionaryWithContentsOfFile:path];
    if(data){
       data = [self funj_solverToSaveFile:data a:NO];
    }
    return data;
}
-(id)funj_solverToSaveFile:(id)content a:(BOOL)isArchive{
    if([content isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray*)content;
        NSMutableArray *contentArr =[[NSMutableArray alloc]initWithCapacity:array.count];
        for(int i=0;i<array.count;i++){
            id data = [self funj_solverToSaveFile:array[i] a:isArchive];
            if(data)[contentArr addObject:data];
        }
        return contentArr;
    }else if([content isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic =(NSDictionary*)content;
        NSMutableDictionary *contentDic =[[NSMutableDictionary alloc]initWithCapacity:dic.count];
        for(NSString *key in dic.allKeys){
            id data = [self funj_solverToSaveFile:dic[key] a:isArchive];
            if(data)[contentDic setObject:data forKey:key];
        }
        return contentDic;
    }else if([content isKindOfClass:[NSString class]]){
        return content;
    }else{//model or data
        if(isArchive){
            if([content isKindOfClass:[NSData class]])return content;
            return [NSKeyedArchiver archivedDataWithRootObject:content];
        }else{
            id data = [NSKeyedUnarchiver unarchiveObjectWithData:content];
            if(!data && [content isKindOfClass:[NSData class]]) data = content;
            return data;
        }
    }
    return nil;
}
-(BOOL)funj_saveDataToFile:(id)data p:(NSString*)path{
    BOOL res= [data writeToFile:path atomically:YES];
    return res;
}
-(void)funj_checkIsFile{
    if(![JAppUtility funj_isFileExit:[JAppUtility funj_getTempPath:@"savefile":nil]]){
        [JAppUtility funj_createDirector:[JAppUtility funj_getTempPath:@"savefile":nil]];
    }
}

@end
