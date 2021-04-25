//
//  JBaseDataModel.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JConstantHelp.h"
#import "NSObject+YYModel.h"
@interface JBaseDataModel : NSObject

@end

/*
 [NSKeyedArchiver archiveRootObject:dataModel toFile:[JAppUtility funj_getTempPath:@"tad" :@"plists.text"]];
 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataModel];
 id moda = [NSKeyedUnarchiver unarchiveObjectWithData:data];
 
 //返回json字符串
 NSString *string =[moda modelToJSONString];
 //返回dic、array等对象
 NSDictionary *dic =[moda modelToJSONObject];

 */
