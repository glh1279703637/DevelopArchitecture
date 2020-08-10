//
//  AppDelegate.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 16/4/21.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import "AppDelegate.h"
#import "HBGuidePageViewController.h"
#import "JMainViewController.h"
#import "AFNetworkReachabilityManager.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()
@end

@implementation AppDelegate
//void UncaughtExceptionHandler(NSException *exception) {
//    NSArray *arr = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//
//    NSString *urlStr = [NSString stringWithFormat:"错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
//                        name,reason,[arr componentsJoinedByString:@"<br>"]];
//
//    CLog(@"%@",urlStr);
//    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self addRootMainViewController];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
     
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
     
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
//
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
     
//    //IOS崩溃 异常处理
//     NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
     
//     //本地通知
//     UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];//请求获取通知权限（角标，声音，弹框）
//     [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//         if (granted) { //获取用户是否同意开启通知
//             CLog(@"request authorization successed!");
//         }
//     }];
 
    return YES;
}
#pragma mark 如果没有stordboard 可以使用这个方法。
-(void)addRootMainViewController{
     self.window.backgroundColor=[UIColor whiteColor];
    
//    if([self isFirstLoadUserView]){
//        //第一次登录,出现引导页
//        JMainViewController *mainVC=[JMainViewController shareMainVC];
//        HBGuidePageViewController *viewController = [[HBGuidePageViewController alloc] initWithLoadVC:mainVC];
//        self.window.rootViewController=viewController;
//    }
    
}
-(BOOL)isFirstLoadUserView{
    //判断app是否第一次登录 2015.6.19改
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
}
-(void)applicationWillTerminate:(UIApplication *)application{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}




#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)) {
     // Called when a new scene session is being created.
     // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)) {
     // Called when the user discards a scene session.
     // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
     // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

