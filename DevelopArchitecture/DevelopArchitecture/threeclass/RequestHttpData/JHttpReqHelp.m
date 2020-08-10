//
//  JHttpReqHelp.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JHttpReqHelp.h"
#import "JConstantHelp.h"
#import "JAppViewExtend.h"
#import "JBaseDataModel.h"
#import "JBaseViewController.h"
#import "JBaseInterfaceManager.h"
static NSMutableDictionary *saveRequestDic = nil;

@interface JHttpReqHelp(){
    NSURLSessionDataTask*dataTask;
}
@property(nonatomic,weak)UIViewController *m_viewController;
@property(nonatomic,assign)BOOL isDefaultHasVC;

@property(nonatomic,strong) NSMutableURLRequest*m_httpRequest;
@property(nonatomic,copy)successRequest m_successCallback;
@property(nonatomic,copy)failureRequest m_failureCallback;
@property(nonatomic,copy)NSString *m_modleClassName;

@property(nonatomic,assign)BOOL m_isSuccessShow,m_isMustLogin,m_addVerify;
@end


@implementation JHttpReqHelp

+(id)share{
    JHttpReqHelp *httpRequest=[[JHttpReqHelp alloc]init];
    return httpRequest;
}
- (JHttpReqHelp*)funj_requestMessageToServer:(UIViewController*)viewController url:(NSString*)suffixUrl values:(NSDictionary *)parameter success:(successRequest)success failure:(failureRequest)failure{
     self.m_viewController = viewController;
    self.isDefaultHasVC = viewController!=nil;
    self.m_successCallback = success;
    self.m_failureCallback = failure;
 
    NSMutableString *urlStr=[[NSMutableString  alloc]initWithString:APP_URL_ROOT];
    
    _m_httpRequest=[[NSMutableURLRequest alloc]init];
    [self.m_httpRequest setTimeoutInterval:10];
    if([suffixUrl length]>0){
        [urlStr appendFormat:@"%@",suffixUrl];
    }
    NSArray *array =[self solverParameterToConnect:parameter];
    [self.m_httpRequest setURL:[NSURL URLWithString:urlStr]];
    
    if([array count]>0){
        [self.m_httpRequest setHTTPMethod:@"POST"];
        NSString *strs=[array componentsJoinedByString:@"&"];
        [self.m_httpRequest setHTTPBody:[strs dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [self funj_dataTaskMessage];
    
    return self;
}
- (JHttpReqHelp*)funj_requestInfoToServer:(UIViewController*)viewController url:(NSString*)fullUrl values:(NSDictionary *)parameter success:(successRequest)success{
    self.m_viewController = viewController;
    self.isDefaultHasVC = viewController!=nil;
    self.m_successCallback = success;
    self.m_failureCallback = nil;
 
    NSMutableString *urlStr=[[NSMutableString  alloc]initWithString:fullUrl];
    
    _m_httpRequest=[[NSMutableURLRequest alloc]init];
    [self.m_httpRequest setTimeoutInterval:10];
    NSArray *array =[self solverParameterToConnect:parameter];
    [self.m_httpRequest setURL:[NSURL URLWithString:urlStr]];
    
    if([array count]>0){
        [self.m_httpRequest setHTTPMethod:@"POST"];
        NSString *strs=[array componentsJoinedByString:@"&"];
        [self.m_httpRequest setHTTPBody:[strs dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [self funj_dataTaskMessage];
    
    return self;
}
- (JHttpReqHelp*)funj_requestImageToServers:(UIViewController*)viewController url:(NSString*)suffixUrl values:(NSDictionary *)parameter image:(UIImage *)image forKey:(NSString *)imagekey :(NSString*)flag success:(successRequest)success failure:(failureRequest)failure{
    self.m_viewController = viewController;
    self.isDefaultHasVC = viewController!=nil;
    self.m_successCallback = success;
    self.m_failureCallback = failure;
 
    NSMutableString *urlStr=[[NSMutableString  alloc]initWithString:APP_URL_ROOT];
    if([suffixUrl length]>0){
        [urlStr appendFormat:@"%@",suffixUrl];
    }
    _m_httpRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                        timeoutInterval:120];
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = [JAppUtility funj_compressImageWithMaxLength:image :-1];

    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    
//    //遍历keys
//    NSArray *array =[self solverParameterToConnect:parameter];
//
//    if([array count]>0){
//        NSString *strs=[array componentsJoinedByString:@"&"];
//        [urlStr appendFormat:@"?%@",strs];
//        [self.m_httpRequest setURL:[NSURL URLWithString:urlStr]];
//    }
    
    for(NSString *key in parameter.allKeys){
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n\r\n",key];

        [body appendFormat:@"%@\r\n",[parameter objectForKey:key]];
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",imagekey,imagekey];
    
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [self.m_httpRequest setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [self.m_httpRequest setValue:[NSString stringWithFormat:@"%zd", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [self.m_httpRequest setHTTPMethod:@"POST"];
    [self.m_httpRequest setHTTPBody:myRequestData];
    self.m_httpRequest.accessibilityLabel = flag;
    
    [self funj_uploadTaskMessage];
    
    return self;
}

//上传音频
- (JHttpReqHelp*)funj_requestVoiceToServer:(UIViewController*)viewController :(NSString*)suffixUrl values:(NSDictionary *)parameter fileUrl:(NSURL *)fileUrl forKey:(NSString *)voicekey success:(successRequest)success failure:(failureRequest)failure{
    self.m_viewController = viewController;
    self.isDefaultHasVC = viewController!=nil;
    self.m_successCallback = success;
    self.m_failureCallback = failure;
 
    NSMutableString *urlStr=[[NSMutableString  alloc]initWithString:APP_URL_ROOT];
    if([suffixUrl length]>0){
        [urlStr appendFormat:@"%@",suffixUrl];
    }
    _m_httpRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                        timeoutInterval:120];
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = [NSData dataWithContentsOfURL:fileUrl];;
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameter allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameter objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"record.mp3\"\r\n",voicekey];
    
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: audio/mp3\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [self.m_httpRequest setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [self.m_httpRequest setValue:[NSString stringWithFormat:@"%zd", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [self.m_httpRequest setHTTPMethod:@"POST"];
    [self.m_httpRequest setHTTPBody:myRequestData];
    [self funj_uploadTaskMessage];
    return self;
}
-(void)cancelCunrrentRequest{
    [dataTask cancel];
}
-(NSArray*)solverParameterToConnect:(NSDictionary*)parameter{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    [parameter enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(![obj isKindOfClass:[NSDictionary class]] && ![obj isKindOfClass:[NSArray class]]){
            NSString *str =[NSString stringWithFormat:@"%@",obj];
            str = [str stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
            str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            // NSString *jsonString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)obj, nil, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
            [array addObject:[NSString stringWithFormat:@"%@=%@",key,str]];
        }else{
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString  *jsonStr=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            [array addObject:[NSString stringWithFormat:@"%@=%@",key,jsonStr]];
        }
    }];
    return array;
}
-(void)funj_dataTaskMessage{
    if([JHttpReqHelp funj_checkNetworkType]){
        if(!saveRequestDic){
            saveRequestDic =[[NSMutableDictionary alloc]init];
        }
        NSDictionary *dataTaskDic = [saveRequestDic objectForKey:self.m_httpRequest.URL.absoluteString];
        NSString *newParam =[[NSString alloc]initWithData:self.m_httpRequest.HTTPBody encoding:NSUTF8StringEncoding];
        if(dataTaskDic){
            NSString *oldParam =[dataTaskDic objectForKey:@"param"];
            if([oldParam isEqualToString:newParam]){
                NSURLSessionDataTask *dataTasks = [dataTaskDic objectForKey:@"dataTask"];
                if(dataTasks.state != NSURLSessionTaskStateRunning || [NSDate timeIntervalSinceReferenceDate] -[dataTaskDic[@"time"] doubleValue] >30){
                    [dataTasks cancel];
                    [saveRequestDic removeObjectForKey:self.m_httpRequest.URL.absoluteString];
                }else{
                    return;
                }
            }
        }
        [self.m_viewController funj_showProgressViewType:0];
        dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:self.m_httpRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_viewController funj_closeLoadingProgressView];
                if(self.isDefaultHasVC && !self.m_viewController)return ;
                if(!error && data) [self solveDataFromServer:data];
                else if(self.m_failureCallback) self.m_failureCallback(self.m_viewController,nil);
            });
        }];
        [dataTask resume];
        [saveRequestDic setObject:@{@"dataTask":dataTask,@"param":newParam,@"time":[NSString stringWithFormat:@"%lf",[NSDate timeIntervalSinceReferenceDate]]} forKey:self.m_httpRequest.URL.absoluteString];
        
    }else{
        if(self.m_failureCallback){
             self.m_failureCallback(self.m_viewController,LocalStr(@"The current network is not available, please check your network settings"));
        }
    }
}
-(void)funj_uploadTaskMessage{
    if([JHttpReqHelp funj_checkNetworkType]){
        [self.m_viewController funj_showProgressViewType:0];
        dataTask = [[NSURLSession   sharedSession] uploadTaskWithRequest:self.m_httpRequest fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.m_viewController funj_closeLoadingProgressView];
                if(self.isDefaultHasVC && !self.m_viewController)return ;
                if(!error && data) [self solveDataFromServer:data];
                else  if(self.m_failureCallback) self.m_failureCallback(self.m_viewController,nil);
            });
        }];
        [dataTask resume];
    }else{
        if(self.m_failureCallback){
             self.m_failureCallback(self.m_viewController,LocalStr(@"The current network is not available, please check your network settings"));
        }
    }
}
-(void)solveDataFromServer:(NSData*)data{
    if(!data)return;
    NSError *parseError=nil;
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
    CLog(@"%@ => %@",self.m_httpRequest.URL.absoluteString,jsonObject);
    if(jsonObject!=nil && parseError==nil)
    {
        if([jsonObject isKindOfClass:[NSDictionary class]]){
            
            if(![self funj_VerifyIsSuccessful:jsonObject])return;

            if([jsonObject objectForKey:@"data"] &&
               [[jsonObject objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                if(self.m_successCallback){
                    NSMutableDictionary *dics =[self funj_createNewSolver:jsonObject];
                    NSArray *array= [dics objectForKey:@"data"];
                    [dics removeObjectForKey:@"data"];
                    
                    array=self.m_modleClassName?[self requestDataWithModle:self.m_modleClassName data:array]:array;
                    
                    if(self.m_httpRequest.accessibilityLabel){
                        [dics setObject:self.m_httpRequest.accessibilityLabel forKey:@"flag"];
                        self.m_successCallback(self.m_viewController,array,dics);
                    }else{
                        self.m_successCallback(self.m_viewController,array,dics);
                    }
                }
            }else if([jsonObject objectForKey:@"data"] &&
                     [[jsonObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                if(self.m_successCallback){
                    NSMutableDictionary *dics =[self funj_createNewSolver:jsonObject];
                    
                    NSArray *array =nil;
                    
                    if( [dics objectForKey:@"data"]){
                        array = self.m_modleClassName?[self requestDataWithModleDic:self.m_modleClassName data:[dics objectForKey:@"data"]]:nil;
                    }

                    if(self.m_httpRequest.accessibilityLabel){
                        [dics setObject:self.m_httpRequest.accessibilityLabel forKey:@"flag"];
                        self.m_successCallback(self.m_viewController,array,dics);
                    }else{
                        self.m_successCallback(self.m_viewController,array,dics);
                    }
                }
            }else{
                NSMutableDictionary *dics =[self funj_createNewSolver:jsonObject];
                if(self.m_successCallback)self.m_successCallback(self.m_viewController,nil,dics);
            }
        }
    } else {
        if(self.m_failureCallback){
            CLog(@"%@ => %@",self.m_httpRequest.URL.absoluteString,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            if([JAppViewTools funj_getKeyWindow])[JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:LocalStr(@"The server is abnormal. Please try again later")];
            self.m_failureCallback(self.m_viewController,LocalStr(@"The server is abnormal. Please try again later") );
        }
    }
    if(self.m_httpRequest.URL.absoluteString)[saveRequestDic removeObjectForKey:self.m_httpRequest.URL.absoluteString];
    
}


-(NSArray *)requestDataWithModle:(NSString*)modle data:(NSArray*)array
{
    NSMutableArray *allData = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (id data in array) {
        id currentModel = [[NSClassFromString(modle) alloc] initWithContent:data];
        [allData addObject:currentModel];
    }
    return allData;
}
-(NSArray *)requestDataWithModleDic:(NSString*)modle data:(NSDictionary*)data
{
    if(!data)return nil;
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    id currentModel = [[NSClassFromString(modle) alloc] initWithContent:data];
    [allData addObject:currentModel];
    
    return allData;
}
+(BOOL)funj_checkNetworkType{
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]){
        [JAppViewTools funj_showTextToast:[UIApplication sharedApplication].keyWindow message:LocalStr(@"The current network is not available, please check your network settings") complete:nil time:1];
        return NO;
    }
    return YES;
}
//验证返回信息是否成功
-(JHttpReqHelp*)funj_addVerify:(BOOL)isSuccessShow call:(BOOL)isMustLogin{
    self.m_addVerify = YES;
    self.m_isMustLogin = isMustLogin;
    self.m_isSuccessShow = isSuccessShow;
    return self;
}
-(BOOL)funj_VerifyIsSuccessful:(NSDictionary*)data{
    if(!self.m_addVerify)return YES;
    
    return [JBaseInterfaceManager funj_VerifyIsSuccessful:data show:self.m_isSuccessShow callVC:(self.m_isMustLogin?self.m_viewController:nil)];
}
-(JHttpReqHelp*)funj_addModleClass:(NSString*)className{
    self.m_modleClassName = className;
    return self;
}
-(NSMutableDictionary*)funj_createNewSolver:(NSMutableDictionary*)data{
    if(!data)return nil;
    NSMutableDictionary *saveData1 = nil;
    if([data isKindOfClass:[NSDictionary class]]){
        saveData1 =[[NSMutableDictionary alloc]init];
        [self funj_solverDataIsEffective:saveData1 :data];
    }else if([data isKindOfClass:[NSString class]]){
        saveData1 = data;
    }

    return saveData1;
}
-(void)funj_solverDataIsEffective:(NSMutableDictionary*)saveData :(NSDictionary*)data{
    for(NSString *key in data.allKeys){
        id object = [data objectForKey:key];
        if(![object isKindOfClass:[NSNull class]]){
            if([object isKindOfClass:[NSDictionary class]]){
                NSMutableDictionary *saveData1 =[self funj_createNewSolver:object];
                [saveData setObject:saveData1 forKey:key];
            }else if([object isKindOfClass:[NSArray class]]){
                NSMutableArray*dataArr =[[NSMutableArray alloc]init];
                NSArray *arr = (NSArray*)object;
                for(NSInteger i =0;i<[arr count];i++){
                    NSMutableDictionary *saveData1 =[self funj_createNewSolver:arr[i]];
                    [dataArr addObject:saveData1];
                }
                [saveData setObject:dataArr forKey:key];
            }else{
                [saveData setObject:object forKey:key];
            }
        }
    }
}

@end
