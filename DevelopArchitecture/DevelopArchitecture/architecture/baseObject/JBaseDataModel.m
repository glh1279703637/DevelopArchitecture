//
//  JBaseDataModel.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseDataModel.h"
#import <objc/runtime.h>
@implementation JBaseDataModel
- (id)initWithContent:(NSDictionary *)json{
    self = [self init];
    
    if (self) {
        
        [self funj_setModelData:json];
    }
    
    return self;
}

- (id)mapAttributes{
    unsigned int count=0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for(int i=0;i<count;i++){
        [dic setObject:[NSString stringWithFormat:@"%s",property_getName(propertys[i])] forKey:[NSString stringWithFormat:@"%s",property_getName(propertys[i])]];
    }
    free(propertys);
    return dic;
}

- (SEL)setterMethod:(NSString *)key{
    NSString *first = [[key substringToIndex:1] capitalizedString];
    NSString *end = [key substringFromIndex:1];
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", first, end];
    return NSSelectorFromString(setterName);
}

- (void)funj_setModelData:(NSDictionary *)json{
    NSDictionary *mapDic = [self mapAttributes];
    
    for (id key in mapDic) {
        
        SEL sel = [self setterMethod:key];//(setBox:)
        
        if ([self respondsToSelector:sel]) {
            
            id jsonKey = [mapDic objectForKey:key];
            
            id jsonValue = [json objectForKey:jsonKey];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if(jsonValue && ![jsonValue isKindOfClass:[NSNull class]]){
                [self performSelector:sel withObject:jsonValue];
            }
#pragma clang diagnostic pop
        }
    }
}
-(NSDictionary*)funj_getDicFromModel {
    NSDictionary *mapDic = [self mapAttributes];
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    [mapDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SEL sel=NSSelectorFromString(key);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id object= [self performSelector:sel];
#pragma clang diagnostic pop
        if(object && ![object isKindOfClass:[NSNull class]]){
            [dataDic setValue:object forKey:obj];
        }
    }];
    return dataDic;
}

#pragma mark 自动归档 解档
+ (NSArray *)propertyOfSelf{
    unsigned int count;
    // 1. 获得类中的所有成员变量
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *properNames =[NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        // 2.获得成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 3.除去下划线，从第一个角标开始截取
        NSString *key = [name substringFromIndex:1];
        
        [properNames addObject:key];
    }
    free(ivarList);
    return [properNames copy];
}
// 归档
- (void)encodeWithCoder:(NSCoder *)enCoder{
    // 取得所有成员变量名
    NSArray *properNames = [[self class] propertyOfSelf];
    
    for (NSString *propertyName in properNames) {
        // 创建指向get方法
        SEL getSel = NSSelectorFromString(propertyName);
        // 对每一个属性实现归档
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [enCoder encodeObject:[self performSelector:getSel] forKey:propertyName];
#pragma clang diagnostic pop
    }
}
// 解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    // 取得所有成员变量名
    NSArray *properNames = [[self class] propertyOfSelf];
    
    for (NSString *propertyName in properNames) {
        // 创建指向属性的set方法
        // 1.获取属性名的第一个字符，变为大写字母
        NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString;
        // 2.替换掉属性名的第一个字符为大写字符，并拼接出set方法的方法名
        NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:",firstCharater,[propertyName substringFromIndex:1]];
        SEL setSel = NSSelectorFromString(setPropertyName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:setSel withObject:[aDecoder decodeObjectForKey:propertyName]];
#pragma clang diagnostic pop
    }
    return  self;
}


@end

@implementation JBaseCommonAction

@end
