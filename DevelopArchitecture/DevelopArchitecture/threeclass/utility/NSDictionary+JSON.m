//
//  NSDictionary+JSON.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2018/9/19.
//  Copyright © 2018年 Jeffrey. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
-(nullable NSString*)stringWithKey:(id)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }else if([object isKindOfClass:[NSNumber class]])   {
        return [object stringValue];
    }
    return nil;
}
-(nullable NSDictionary*)dictionaryWithKey:(id)key{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}
-(nullable NSArray*)arrayWithKey:(id)key{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

-(NSInteger)integerWithKey:(id)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return [object integerValue];
    }
    return 0;
}
-(long) longWithKey:(id)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return [object longValue];
    }
    return 0;
}

-(double)doubleWithKey:(id)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]]) {
        return [object doubleValue];
    }
    return 0;
}

@end
