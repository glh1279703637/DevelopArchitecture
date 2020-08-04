//
//  NSDictionary+JSON.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2018/9/19.
//  Copyright © 2018年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)
-(nullable NSString*)stringWithKey:(id)key;

-(nullable NSDictionary*)dictionaryWithKey:(id)key;
-(nullable NSArray*)arrayWithKey:(id)key;

-(NSInteger)integerWithKey:(id)key;
-(long) longWithKey:(id)key;

-(double)doubleWithKey:(id)key;
@end

NS_ASSUME_NONNULL_END
