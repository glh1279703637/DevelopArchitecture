//
//  JFileManageHelp.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/3/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFileManageHelp : NSObject
//临时存储数据到文件类
+(id)shareFile;
-(id)funj_getLocaleDataWithName:(NSString*)fileName  model:(NSString*)model;
-(BOOL)funj_saveToLocaleData:(NSString*)fileName data:(id)content model:(NSString*)model;
@end
