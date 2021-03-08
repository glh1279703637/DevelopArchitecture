//
//  JRunLoopManager.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2021/3/8.
//  Copyright © 2021 Jeffrey. All rights reserved.
//

#import "JRunLoopManager.h"
#import "NSDictionary+JSON.h"
#import "JConstantHelp.h"

static JRunLoopManager * runLoopManager = nil;

@interface JRunLoopManager (){
    CFRunLoopObserverRef m_runloopObserver;

}
@property(nonatomic,strong)NSTimer *m_timer;
@property(nonatomic,strong)NSMutableDictionary *m_saveTastDic;
@property(nonatomic,strong)NSMutableDictionary *m_saveTastCapacityDic;
@property(nonatomic,strong)NSMutableDictionary *m_saveTastHashDic;

@property (nonatomic, strong) dispatch_queue_t m_tastHandleQueue;

@end
@implementation JRunLoopManager
maddProperyValue(m_saveTastDic, NSMutableDictionary)
maddProperyValue(m_saveTastCapacityDic, NSMutableDictionary)
maddProperyValue(m_saveTastHashDic, NSMutableDictionary)

+(instancetype) shared {
    if(!runLoopManager){
        runLoopManager = [[JRunLoopManager alloc]init];
    }
    return runLoopManager;
}
-(instancetype)init{
    if(self =[super init]){
        self.m_tastHandleQueue = dispatch_queue_create("runloop.tast.queue", NULL);//串行

        _m_timer =[NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        }];//只是为了保证
        
        [self addRunloopObserver];
    }
    return self;
}
-(void)addRunloopObserver{
    //获取Runloop
     CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个context上下文
    CFRunLoopObserverContext context = { 0, (__bridge void *)(self),
        &CFRetain,  &CFRelease,  NULL
    };
    m_runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &funj_tastToCallBack, &context);
    //添加观察者
    CFRunLoopAddObserver(runloop, m_runloopObserver, kCFRunLoopDefaultMode);
//    //C里面 一旦creat new copy
    CFRelease(m_runloopObserver);
}

void funj_tastToCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    JRunLoopManager *runManager = (__bridge JRunLoopManager*)info;
    if(runManager.m_saveTastDic.count <= 0)return;
    
    for(NSString *key in runManager.m_saveTastDic.allKeys){
        NSMutableArray *tastArr = runManager.m_saveTastDic[key];
        NSMutableArray *hashArr = runManager.m_saveTastHashDic[key];
        BOOL result = NO;
        while (!result && tastArr.count > 0) {
            kRunLoopWorkDistributionUnit block = tastArr.firstObject;
            NSString *hashKey = hashArr.firstObject;
            result = block(hashKey);
            [tastArr removeObjectAtIndex:0];
            [hashArr removeObjectAtIndex:0];
        }
    }
}

-(void)funj_addTast:(kRunLoopWorkDistributionUnit)action key:(NSString*)key {
    [self funj_addTast:0 a:action key:key];
}
-(void)funj_addTast:(NSUInteger)hash a:(kRunLoopWorkDistributionUnit)action key:(NSString*)key {
    dispatch_async(self.m_tastHandleQueue, ^{
        NSMutableArray *tastArr = self.m_saveTastDic[key];
        NSMutableArray *hashArr = self.m_saveTastHashDic[key];
        if(!tastArr){
            tastArr =[[NSMutableArray alloc]init];
            self.m_saveTastDic[key] = tastArr;
            hashArr =[[NSMutableArray alloc]init];
            self.m_saveTastHashDic[key] = hashArr;
        }
        NSString *hasKey = [NSString stringWithFormat:@"%@%lu",key,hash];
        if(hash > 0){
            NSInteger index = [hashArr indexOfObject:hasKey];
            if(index != NSNotFound){
                [hashArr removeObjectAtIndex:index];
                [tastArr removeObjectAtIndex:index];
            }
        }
        
        [tastArr addObject:action];
        [hashArr addObject:hasKey];
        NSInteger  count = [self.m_saveTastCapacityDic integerWithKey:key];
        if(tastArr.count > MAX(count, 30)){
            [tastArr removeObjectAtIndex:0];
            [hashArr removeObjectAtIndex:0];
        }
    });
}
-(void)funj_removeAllTasts{
    dispatch_async(self.m_tastHandleQueue, ^{
        [self.m_saveTastDic removeAllObjects];
        [self.m_saveTastHashDic removeAllObjects];
    });
}
-(void)funj_updateTastCapacity:(NSInteger)count key:(NSString*)key{
    self.m_saveTastCapacityDic[key] = @(count);
}
@end
