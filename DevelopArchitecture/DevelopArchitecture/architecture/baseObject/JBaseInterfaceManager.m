//
//  JBaseInterfaceManager.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2017/5/24.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "JBaseInterfaceManager.h"
@implementation JBaseInterfaceManager
//验证返回信息是否成功
+(BOOL)funj_VerifyIsSuccessful:(NSDictionary *)data show:(BOOL)isSuccessShow callVC:(id)viewcontroller{
    NSString *msg=[data stringWithKey:@"msg"];
    if([data integerWithKey:@"result"]==0 ){
        if(isSuccessShow){
            if(msg.length>15){
                [JAppViewTools funj_showAlertBlock:self :nil :msg :0 :nil];
            }else  if(msg.length > 0){
                [JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:msg];
            }
        }
        return YES;
    } else if([data integerWithKey:@"result"]==2){
        [self funj_didLogoutAccount:viewcontroller];
        
        if(viewcontroller && [viewcontroller isKindOfClass:[JBaseViewController class]]){
            [JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:LocalStr(@"You are not logged in") complete:^{
                if([data integerWithKey:@"result"]==2 && viewcontroller){
                    [(JBaseViewController*)viewcontroller funj_getPresentVCWithController:@"JLogin_Register_ForgetItVC" title:nil :nil :NO];
                }
            } time:1.0];
            
        }else{
            [JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:LocalStr(@"You are not logged in")];
        }
        return NO;
    } else/* if([data integerWithKey:@"result"]==1 )*/{
        if(msg.length>15){
            [JAppViewTools funj_showAlertBlock:self :nil :msg :0 :nil];
        }else if(msg.length>0){
            [JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:msg];
        }
        return NO;
    }
    return NO;
}

//退出登陆状态
+(void)funj_didLogoutAccount:(id)viewController{
    NSDictionary *dic=[JLoginUserModel funj_getLastLoginUserMessage];
    if([dic count]>0 && [dic integerWithKey:@"isLogining"]==1){
        NSMutableDictionary *dic2 =[JLoginUserModel funj_getLastLoginTokenMessage];
        [JLoginUserModel funj_insertLoginUserMessage:@{@"userId":[dic objectForKey:@"userId"],@"isLogining":@"0"}];
//        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateUserIdentityNoti object:@"out"];
        UIViewController *vcs =[JAppViewTools funj_getTopViewcontroller];
        [[[JHttpReqHelp share] funj_requestToServer:vcs url:@"usr/loginOut" v:dic2]
            funj_addSuccess:^(id viewController, NSArray *dataArr, NSDictionary *dataDic) {
            [JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:LocalStr(@"You have successfully logged out") complete:^{
                if([dataDic integerWithKey:@"result"] ==-100){
                    if(viewController){
                        JBaseViewController *objectVc = [[NSClassFromString(@"JSelectLoginStyleVC") alloc]init];
                        objectVc.m_currentShowVCModel = kCURRENTISPRENTVIEW;
                        objectVc.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
                        [viewController presentViewController:objectVc animated:YES completion:nil];
                    }
                }
            } time:1.0];
        }];
    }
    
}
@end

