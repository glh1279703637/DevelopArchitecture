//
//  JJsonProperty.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2021/4/24.
//  Copyright © 2021 Jeffrey. All rights reserved.
//

#import "JJsonProperty.h"
#import "JHttpReqHelp.h"

@implementation JJsonProperty
+(void) funj_requestToJsonToProperty:(NSString*)subUrl values:(NSDictionary*)parameter k:(NSString*)keyPath{
    if(!keyPath)return;
    
    [[[JHttpReqHelp share] funj_requestToServer:nil url:@"mobile/login" v:@{@"account":@"15911111111",@"password":@"111111"}]
    funj_addSuccess:^(id viewController, NSArray *dataArr, NSDictionary *dataDic) {
        [self funj_solverToJsonToProperty:[dataDic valueForKeyPath:keyPath]];
    }];
    
}
+(void) funj_solverToJsonToProperty:(NSDictionary*)parameter{
    if([parameter isKindOfClass:[NSArray class]]){
        parameter = [(NSArray*)parameter firstObject];
    }
    if(!parameter)return;
    NSArray *keyArr = [parameter.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    NSMutableArray *keyPathArr = [[NSMutableArray alloc]init];
    for(NSString *key in keyArr) {
        NSObject* value = parameter[key];
        NSString * str = @"@property ( nonatomic , ";
        if([value isKindOfClass:[NSNumber class]]){
            str =[str stringByAppendingString:@"assign ) "];
            NSNumber *number = (NSNumber*)value;
            NSString *addStr = nil;
            if (strcmp([number objCType], @encode(BOOL)) == 0) {
                addStr = @"BOOL ";
            }else if ((strcmp([number objCType], @encode(int)) == 0) || (strcmp([number objCType], @encode(long)) == 0)) {
                addStr = @"NSInteger ";
            }else if (strcmp([number objCType], @encode(long long)) == 0) {
                addStr = @"long long ";
            }else if (strcmp([number objCType], @encode(unsigned long long)) == 0) {
                addStr = @"unsigned long long ";
            }else if (strcmp([number objCType], @encode(float)) == 0) {
                addStr = @"float ";
            }else if(strcmp([number objCType], @encode(double)) == 0){
                addStr = @"double ";
            }else{
                NSLog(@"-- -- -- -- \n");
                NSLog(@"内容number无法识别 :%@\n",key);
                exit(0);
            }
            str =[str stringByAppendingString:addStr];
        }else if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNull class]]){
            str =[str stringByAppendingString:@"copy   ) NSString *"];
        }else if([value isKindOfClass:[NSArray class]]){
            str =[str stringByAppendingString:@"strong ) NSArray *"];
        }else if([value isKindOfClass:[NSDictionary class]]){
            str =[str stringByAppendingString:@"strong ) NSDictionary *"];
        }else if([value isKindOfClass:[NSDate class]]){
            str =[str stringByAppendingString:@"strong ) NSDate *"];
        }else{
            NSLog(@"-- -- -- -- \n");
            NSLog(@"内容number无法识别 :%@\n",key);
            continue;
        }
        str = [str stringByAppendingFormat:@"%@ ;",key];
        [keyPathArr addObject:str];
    }
    
    NSLog(@"%@",keyPathArr);
    
}



@end
