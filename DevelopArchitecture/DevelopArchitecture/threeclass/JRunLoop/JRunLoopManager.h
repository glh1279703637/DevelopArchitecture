//
//  JRunLoopManager.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2021/3/8.
//  Copyright © 2021 Jeffrey. All rights reserved.
//

#import "JBaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^kRunLoopWorkDistributionUnit)(NSString *idKey);

@interface JRunLoopManager : JBaseDataModel
+(instancetype) shared;

-(void)funj_addTast:(kRunLoopWorkDistributionUnit)action key:(NSString*)key;
-(void)funj_addTast:(NSUInteger)hash a:(kRunLoopWorkDistributionUnit)action key:(NSString*)key;
-(void)funj_removeAllTasts;

-(void)funj_updateTastCapacity:(NSInteger)count key:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
