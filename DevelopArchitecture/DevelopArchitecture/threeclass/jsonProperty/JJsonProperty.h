//
//  JJsonProperty.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2021/4/24.
//  Copyright © 2021 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJsonProperty : NSObject
+(void) funj_requestToJsonToProperty:(NSString*)subUrl values:(NSDictionary*)parameter k:(NSString*)keyPath;

+(void) funj_solverToJsonToProperty:(NSDictionary*)parameter;

@end

NS_ASSUME_NONNULL_END
