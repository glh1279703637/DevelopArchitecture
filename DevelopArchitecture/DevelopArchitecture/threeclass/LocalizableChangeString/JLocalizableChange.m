//
//  JLocalizableChange.m
//  qqqq
//
//  Created by Jeffrey on 2017/5/18.
//  Copyright © 2017年 123. All rights reserved.
//

#import "JLocalizableChange.h"
#import "JAppUtility.h"
#import "JConstantHelp.h"
@implementation JLocalizableChange

//替换所有的.m文件 到 .txt

//find . -iname "*.a" -exec mv {} {}_txt \;
//find . -iname "*.framework" -exec mv {} {}_txt \;
//find . -name "*.m_txt"|sed 's/.m_txt//'|xargs -n1 -I {} mv {}.m_txt {}.txt;


//find . -name "*.a_txt"|sed 's/.a_txt//'|xargs -n1 -I {} mv {}.a_txt {}.a;
//find . -name "*.framework_txt"|sed 's/.framework_txt//'|xargs -n1 -I {} mv {}.framework_txt {}.framework;
/*
 // first
 find . -iname "*.h" -exec mv {} {}_txt \;
 find . -iname "*.c" -exec mv {} {}_txt \;
 find . -iname "*.a" -exec rm -rf {} \;
 find . -iname "*.framework" -exec rm -rf {} \;
 find . -iname "*.m" -exec mv {} {}_txt \;
 find . -iname "*.plist" -exec rm -rf {} \;
 find . -iname "*.bundle" -exec rm -rf {} \;
 find . -iname "*.storyboard" -exec rm -rf {} \;
 find . -iname "*.png" -exec rm -rf {} \;
 find . -iname "*.xcodeproj" -exec rm -rf {} \;
 find . -iname "*.xcworkspace" -exec rm -rf {} \;
 find . -iname "*Podfile*" -exec rm -rf {} +
 find . -iname "*Pods*" -exec rm -rf {} +
 find . -iname "*.xcassets" -exec rm -rf {} \;
 find . -iname "*.lproj" -exec rm -rf {} \;
 find . -iname "*.entitlements" -exec rm -rf {} \;
 find . -iname "*.strings" -exec mv {} {}_t \;

 //end
 
 find . -name "*.txt"|sed 's/.txt//'|xargs -n1 -I {} mv {}.txt {}.m;
 find . -name "*.h_txt"|sed 's/.h_txt//'|xargs -n1 -I {} mv {}.h_txt {}.h;
 find . -name "*.c_txt"|sed 's/.c_txt//'|xargs -n1 -I {} mv {}.c_txt {}.c;
 */

//搜索所有的中文 并保存成文件 已去重复
+(void) funj_searchAllChinaList{
    NSString* path  = [[NSBundle mainBundle]bundlePath];
    NSString* fileName;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    
    NSMutableDictionary *saveChinaDic =[[NSMutableDictionary alloc]init];
    NSMutableDictionary *saveChinaKeyDic =[[NSMutableDictionary alloc]init];
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        if([fileName hasSuffix:@".m_txt"]){
            NSArray *nameArr = [fileName componentsSeparatedByString:@"."];
            if(nameArr.count>0){
                NSString *path =[[NSBundle mainBundle]pathForResource:nameArr[0] ofType:@"m_txt"];
                
                NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSString *regex =@"@\"[^\"]*[\u4E00-\u9FA5]+[^\"\n]*?\"";
                
                NSMutableArray *saveChinaArr=[[NSMutableArray alloc]init];
                for(long index = 0;index<str.length;index++){
                    NSRange range = [str rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(index, str.length-index)];
                    if(range.length>0){
                        NSString *key = [str substringWithRange:range];
                        if(![saveChinaKeyDic objectForKey:key]){
                            [saveChinaArr addObject:key];
                            [saveChinaKeyDic setObject:@"" forKey:key];
                        }
                        index = range.location + range.length -1;
                    }else{
                        break;
                    }
                }
                if(saveChinaArr.count >0){
                    [saveChinaDic setObject:saveChinaArr forKey:nameArr[0]];
                }
            }
        }
    }
    
    NSArray *keyArr =[saveChinaDic allKeys];
    keyArr = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *string =[[NSMutableString alloc]init];
    for(NSString *key in keyArr){
        [string appendFormat:@"\n\n//%@\n",key ];
        NSArray*dataArr =saveChinaDic[key];
        for(NSString *str in dataArr){
            NSString *st1 = [str substringFromIndex:1];
            NSString *s = [NSString stringWithFormat:@"%@ = %@ ;\n",st1,st1];
            [string appendString:s];
        }
    }

    NSString *temp=NSTemporaryDirectory();
    temp= [temp stringByAppendingPathComponent:@"localizable.txt"];

    [string writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];

    CLog(@"%@",temp);
}
//将英文的local与中文合并 新成一份
+(void) funj_changeLocalizableChinaCN{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable2" ofType:@"txt"];
    NSString *path2 =[[NSBundle mainBundle]pathForResource:@"localizable3" ofType:@"txt"];

    NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *str2 =[NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];

    NSArray *array = [str componentsSeparatedByString:@"\n"];
    NSArray *array2 = [str2 componentsSeparatedByString:@"\n"];

    NSMutableDictionary *dataDic =[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dataDic2 =[[NSMutableDictionary alloc]init];
    
    for(NSString *key in array2){
        if([key rangeOfString:@" = "].length > 0){
            NSInteger index = [key rangeOfString:@" = "].location;
            NSString *keys = [key substringToIndex:index];
            NSString *value = [key substringFromIndex:index+3];
            [dataDic2 setObject:value forKey:keys];
        }
    }

    NSMutableArray*dataArr = nil;;
    NSMutableDictionary *dataKeyDic =[[NSMutableDictionary alloc]init];
    for(NSString *key in array){
        if([key hasPrefix:@"//"]){
            dataArr =[[NSMutableArray alloc]init];
            [dataDic setObject:dataArr forKey:key];
        }else{
            if([key rangeOfString:@" = "].length > 0){
                NSInteger index = [key rangeOfString:@" = "].location;
                NSString *keys = [key substringToIndex:index];
                if([keys hasSuffix:@" "]) keys =[key substringToIndex:index-1];
                
                if(![dataKeyDic objectForKey:keys]){
                    [dataKeyDic setObject:@"" forKey:keys];
                }else{
                    continue;
                }
                
                NSString *value = [dataDic2 objectForKey:keys];
                if(!value){
                    NSString *regex =@"\"[^\"]*[\u4E00-\u9FA5]+[^\"\n]*?\"";
                    NSRange range = [keys rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(0, keys.length)];
                    if(range.length > 0 ){
                        value = [NSString stringWithFormat:@"%@ ;",keys];
                    }else{
                        value = @"\"\" ;";
                    }
                }
                [dataArr addObject:[NSString stringWithFormat:@"%@ = %@",keys,value]];
            }
        }
    }
    NSArray *keyArr = [dataDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *string = @"";
    for(NSString *key in keyArr){
        NSArray *dataArr =[dataDic objectForKey:key];
        if(dataArr.count > 0){
            string = [string stringByAppendingString:key];
            string = [string stringByAppendingFormat:@"\n%@\n\n\n",[dataArr componentsJoinedByString:@"\n"]];
        }
    }

    path =[JAppUtility funj_getTempPath:nil  :@"aaa.txt"];
    [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
//将英文的local 复制成一份
+(void) funj_changeLocalizable{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable2" ofType:@"txt"];
    
    NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    NSMutableArray *saveArr =[[NSMutableArray alloc]init];
    CLog(@"%@",array);
    for(int i=0;i<array.count;i++){
        NSString *myStr =[array objectAtIndex:i];
        NSArray *arr = [myStr componentsSeparatedByString:@"="];
        
        if(arr.count>1){
            myStr = [NSString stringWithFormat:@"%@ = %@;",arr[0],arr[0]];
        }
        if(myStr) [saveArr  addObject:myStr];
        
        
    }
    NSString *strss =[saveArr componentsJoinedByString:@"\n"];
    CLog(@"%@",saveArr);
    NSString *temp=NSTemporaryDirectory();
    temp= [temp stringByAppendingPathComponent:@"localizable.txt"];
    [strss writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
+(void) funj_resplaceChinaToLocalStr{
//将代码中中文替换成翻译后的英文
    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable2" ofType:@"txt"];
    NSString *dataStr =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *dataArr =[dataStr componentsSeparatedByString:@"\n"];
    
    NSMutableArray *currentKeyArr =[[NSMutableArray alloc]init];
    NSMutableArray *currentDataArr =[[NSMutableArray alloc]init];

    for(int i=0;i<dataArr.count;i++){
        if([dataArr[i] rangeOfString:@" = "] .length>0){
            NSString *str = dataArr[i];
            if([dataArr[i] hasSuffix:@";"]){
                str =[str substringWithRange:NSMakeRange(0, str.length-1)];
            }
            NSArray *arr =[str componentsSeparatedByString:@" = "];
            [currentKeyArr addObject:[NSString stringWithFormat:@"%@",arr[0]]];
            [currentDataArr addObject:[NSString stringWithFormat:@"@%@",arr[1]]];
        }
    }
    
    path  = [[NSBundle mainBundle]bundlePath];
    NSString* fileName;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    
    NSMutableArray *saveOtherKey = [[NSMutableArray alloc]init];
    NSMutableDictionary *saveOtherKeyDic = [[NSMutableDictionary alloc]init];
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
 
        if([fileName hasSuffix:@".txt"]){
            NSArray *nameArr = [fileName componentsSeparatedByString:@"."];
            if(nameArr.count>0){
                NSString *path =[[NSBundle mainBundle]pathForResource:nameArr[0] ofType:@"txt"];
                
                NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSString *regex =@"@\"[^\"]*[\u4E00-\u9FA5]+[^\"\n]*?\"";
                
                BOOL isHasChanges = NO;
                for(long index = 0;index<str.length;index++){
                    NSRange range = [str rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(index, str.length-index)];
                    if(range.length>0){
                        NSString *tempStr = [str substringWithRange:range];
                        BOOL isChange = NO;
                        for(int j = 0;j<currentDataArr.count;j++){
                            if([tempStr isEqualToString:currentDataArr[j]]){
                                if(![nameArr[0] hasPrefix:@"J"]){
                                    str =  [str stringByReplacingOccurrencesOfString:tempStr withString:[NSString stringWithFormat:@"NSLocalizedString(@%@, nil)",currentKeyArr[j]]];
                                    isChange = YES;
                                    isHasChanges = YES;
                                }else{
                                    str =  [str stringByReplacingOccurrencesOfString:tempStr withString:[NSString stringWithFormat:@"LocalStr(@%@)",currentKeyArr[j]]];
                                    isChange = YES;
                                    isHasChanges = YES;
                                }
                            }
                        };
                        if(!isChange){
                            CLog(@"%@ - %@",nameArr[0],tempStr);
                            if(![saveOtherKeyDic objectForKey:tempStr]){
                                [saveOtherKey addObject:tempStr];
                            }
                            [saveOtherKeyDic setObject:@"" forKey:tempStr];
                        }
                        index = range.location + range.length -1;
                    }else{
                        break;
                    }
                }
                if(isHasChanges){
                    NSString *temp=NSTemporaryDirectory();
                    temp= [temp stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",nameArr[0]]];
                    
                    [str writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }

                
            }
        }
    }
    NSString *temp=NSTemporaryDirectory();
    temp= [temp stringByAppendingPathComponent:@"localizable53.txt"];
    NSString *string =[saveOtherKey componentsJoinedByString:@"\n"];
    
    [string writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
//根据中文进行去重复
//+(void) funj_changeDeleteReapeteCNToLocalizable{
//    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable" ofType:@"txt"];
//
//    NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//
//    NSArray *array = [str componentsSeparatedByString:@"\n"];
//    NSMutableArray *saveArr =[[NSMutableArray alloc]init];
//    NSMutableDictionary *saveKeyDic =[[NSMutableDictionary alloc]init];
//    NSMutableDictionary *saveValueDic =[[NSMutableDictionary alloc]init];
//
//    CLog(@"%@",array);
//    for(int i=0;i<array.count;i++){
//        NSString *myStr =[array objectAtIndex:i];
//        NSArray *arr = [myStr componentsSeparatedByString:@" = "];
//        if([arr count]>1){
//            if([saveKeyDic objectForKey:arr[1]]){
//                NSMutableArray *array = [saveValueDic objectForKey:arr[1]];
//                if(!array){
//                    array =[[NSMutableArray alloc]init];
//                    [saveValueDic setObject:array forKey:arr[1]];
//                }
//                [array addObject:myStr];
//                CLog(@"%@",arr[1]);
//                 continue;
//            }
//            [saveKeyDic setObject:@"" forKey:arr[1]];
//        }
//        [saveArr  addObject:myStr];
//    }
//    NSString *strss =[saveArr componentsJoinedByString:@"\n"];
//    CLog(@"%@",saveArr);
//    path =[JAppUtility funj_getTempPath:nil  :@"aaa.txt"];
//    [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    path =[JAppUtility funj_getTempPath:nil  :@"aaa2.txt"];
//    strss =[saveKeyDic.allKeys componentsJoinedByString:@"\n"];
//
//     [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//    path =[JAppUtility funj_getTempPath:nil  :@"aaa3.txt"];
//    [saveArr removeAllObjects];
//    [saveValueDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray*  _Nonnull obj, BOOL * _Nonnull stop) {
//        [saveArr addObject:key];
//        [saveArr addObjectsFromArray:obj];
//    }];
//    strss =[saveArr componentsJoinedByString:@"\n"];
//     [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//
//}
//根据前英文进行去重复
+(void) funj_changeDeleteReapeteENKeyToLocalizable{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable2" ofType:@"txt"];
    
    NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    NSMutableArray *saveArr =[[NSMutableArray alloc]init];
    NSMutableDictionary *saveKeyDic =[[NSMutableDictionary alloc]init];
    NSMutableDictionary *saveValueDic =[[NSMutableDictionary alloc]init];
    
    CLog(@"%@",array);
    for(int i=0;i<array.count;i++){
        NSString *myStr =[array objectAtIndex:i];
        NSArray *arr = [myStr componentsSeparatedByString:@" = "];
        if([arr count]>=1){
            if([saveKeyDic objectForKey:arr[0]]){
                NSMutableArray *array = [saveValueDic objectForKey:arr[0]];
                if(!array){
                    array =[[NSMutableArray alloc]init];
                    [saveValueDic setObject:array forKey:arr[0]];
                }
                [array addObject:myStr];
                CLog(@"%@",arr[0]);
                continue;
            }
            [saveKeyDic setObject:@"" forKey:arr[0]];
        }
        [saveArr  addObject:myStr];
    }
    NSString *strss =[saveArr componentsJoinedByString:@"\n"];
    path =[JAppUtility funj_getTempPath:nil  :@"aaa.txt"];
    [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    path =[JAppUtility funj_getTempPath:nil  :@"aaa2.txt"];
    strss =[saveKeyDic.allKeys componentsJoinedByString:@"\n"];
    
    [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    path =[JAppUtility funj_getTempPath:nil  :@"aaa3.txt"];
    [saveArr removeAllObjects];
    [saveValueDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray*  _Nonnull obj, BOOL * _Nonnull stop) {
        [saveArr addObject:key];
        [saveArr addObjectsFromArray:obj];
    }];
    strss =[saveArr componentsJoinedByString:@"\n"];
    [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}
+(void)funj_changeSplitWithEquelLocalizable{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable2" ofType:@"txt"];
    NSString *dataStr =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *dataArr = [dataStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";\n"]];
    NSMutableArray *currentLocalDataArr =[[NSMutableArray alloc]init];
    for(int i=0;i<dataArr.count;i++){
        if([dataArr[i] length]>0 ){
            if([dataArr[i] hasPrefix:@"\""]){
                NSInteger index = [dataArr[i] rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(1, [dataArr[i] length]-1)].location;
                if(index == NSNotFound)continue;
                [currentLocalDataArr addObject:[dataArr[i] substringWithRange:NSMakeRange(0, index+1)]];
            }
        }
    }
    
    path =[JAppUtility funj_getTempPath:nil  :@"aaa6.txt"];
    NSString* strss =[currentLocalDataArr componentsJoinedByString:@"\n"];
    [strss writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    CLog(@"-- %@",path);

}
 
/**
 *去除重复的Localizalible.string
 * 如果仅在Localizalible.string 却不在代码，则标记起来
 *如果仅在代码中，却不在Localizalible.string中，则也标记起来
 */
+(void) funj_searchAllEnglishFromMMatchLocalizalible{
    NSString *path =[[NSBundle mainBundle]pathForResource:@"localizable2" ofType:@"txt"];
    NSString *dataStr =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *dataArr = [dataStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";\n"]];
    NSMutableDictionary *currentLocalDataDic =[[NSMutableDictionary alloc]init];
    NSMutableArray *currentLocalDataArr =[[NSMutableArray alloc]init];
    for(int i=0;i<dataArr.count;i++){
        if([dataArr[i] length]>0 ){
            if([dataArr[i] hasPrefix:@"//"]){
                [currentLocalDataArr addObject:dataArr[i]];
                [currentLocalDataDic setObject:@"" forKey:dataArr[i]];
            }else if([dataArr[i] hasPrefix:@"\""]){
                NSInteger index = [dataArr[i] rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(1, [dataArr[i] length]-1)].location;
                if(index == NSNotFound)continue;
                [currentLocalDataDic setObject:@"" forKey:[dataArr[i] substringWithRange:NSMakeRange(0, index+1)]];
                [currentLocalDataArr addObject:[dataArr[i] substringWithRange:NSMakeRange(0, index+1)]];
            }
        }
    }
    NSMutableDictionary *saveLocalstrDic =[[NSMutableDictionary alloc]init];
    NSMutableDictionary *saveLocalKeyDic =[[NSMutableDictionary alloc]init];

    path  = [[NSBundle mainBundle]bundlePath];
    NSString* fileName;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    
    NSString *regex =@"LocalStr{1}\\({1}@\"[^\"]*[^\"\n]*?\"\\)";//包括中文的localstr
    NSString *regex2 =@"LocalStr{1}\\({1}@\"[^\"]*[\u4E00-\u9FA5]+[^\"\n]*?\"\\)"; //有中文的localstr
    NSString *regex3 =@"\"[^\"]*[^\"\n]*?\"";//只有内容
    
    NSMutableDictionary *saveAllNewLocalizableDic =[[NSMutableDictionary alloc]init];

    while ((fileName = [childFilesEnumerator nextObject]) != nil){
         if([fileName hasSuffix:@".m_txt"]){
            NSArray *nameArr = [fileName componentsSeparatedByString:@"."];
            if(nameArr.count>0){
                NSString *path =[[NSBundle mainBundle]pathForResource:nameArr[0] ofType:@"m_txt"];
                
                NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                
                NSMutableArray *saveLocalstrArr=[[NSMutableArray alloc]init];
                NSMutableArray *saveAllLocalstrArr=[[NSMutableArray alloc]init];

                for(long index = 0;index<str.length;index++){
                    NSRange range = [str rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(index, str.length-index)];
                    
                    if(range.length >0){//查找所有@“”字符串
                        NSRange range2 = [str rangeOfString:regex2 options:NSRegularExpressionSearch range:range];
                        if(range2.length <=0){//查找@“”字符串，并且没有中文
                            range2 = [str rangeOfString:regex3 options:NSRegularExpressionSearch range:range];
                            NSString *tempStr = [str substringWithRange:NSMakeRange(range2.location, range2.length)];
                            
                            if([currentLocalDataDic objectForKey:tempStr]){
                                [currentLocalDataDic setObject:@"1" forKey:tempStr];
                            }else{
                                if(![saveLocalKeyDic objectForKey:tempStr]){
                                    [saveLocalKeyDic setObject:@"" forKey:tempStr];
                                    [saveLocalstrArr addObject:tempStr];
                                }
                            }
                            if(![saveAllLocalstrArr containsObject:tempStr]){
                                [saveAllLocalstrArr addObject:tempStr];
                            }
                        }
                        index = range.location + range.length -1;
                    }
                }
                if(saveLocalstrArr.count >0){
                    [saveLocalstrDic setObject:saveLocalstrArr forKey:nameArr[0]];
                }
                if(saveAllLocalstrArr.count >0){
                    [saveAllNewLocalizableDic setObject:saveAllLocalstrArr forKey:nameArr[0]];
                }
            }
        }
    }
    //当前被使用localstr 但是不在localizable中
    NSArray *keyArr =[saveLocalstrDic allKeys];
     keyArr =[keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *string =[[NSMutableString alloc]init];
    for(int i=0;i<keyArr.count;i++){
        NSArray *arrays =saveLocalstrDic[keyArr[i]];
        [string appendFormat:@"// %@; \n%@;\n\n",keyArr[i],[arrays componentsJoinedByString:@";\n"]];
    }
    [string replaceOccurrencesOfString:@"%@" withString:@"%@@" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"@@" withString:@"@" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    NSString *temp=NSTemporaryDirectory();
    temp= [temp stringByAppendingPathComponent:@"kinlocalstrandnolocalizable.txt"];
    [string insertString:@"在文件代码中但不在配置文件localizable.string中%@\n" atIndex:0];
    [string writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *newCurrentDataArr =[[NSMutableArray alloc]init];
    NSMutableArray *newNoCurrentDataArr =[[NSMutableArray alloc]init];

    for(int i=0;i<currentLocalDataArr.count;i++){
        if([currentLocalDataArr[i] hasPrefix:@"//"] || ([currentLocalDataArr[i] length] >0 && [[currentLocalDataDic objectForKey:currentLocalDataArr[i]]  intValue]>0)){
            if([currentLocalDataArr[i] hasPrefix:@"//"]){
                [newCurrentDataArr addObjectsFromArray:@[@"\n",@"\n"]];
            }
            [newCurrentDataArr addObject:currentLocalDataArr[i]];
        }else if([currentLocalDataArr[i] length] >0){
            [newNoCurrentDataArr addObject:currentLocalDataArr[i]];
        }
    }
  
    NSString *temp2=NSTemporaryDirectory();
    //新的列表localizable
    temp2= [temp2 stringByAppendingPathComponent:@"newCurrentDataArr.txt"];
    NSString* string1 =[newCurrentDataArr componentsJoinedByString:@";\n"];
    string1 =[@"新的列表localizable\n" stringByAppendingString:string1];
    [string1 writeToFile:temp2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *keyArr2 =[saveAllNewLocalizableDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *string2 =@"";
    for(NSString *key in keyArr2){
        string2 = [string2 stringByAppendingFormat:@"\n\n//%@\n",key];
        NSArray*dataArr =saveAllNewLocalizableDic[key];
        for(NSString *str in dataArr){
            NSString *s = [NSString stringWithFormat:@"%@ = %@ ;\n",str,str];
            string2 =[string2 stringByAppendingString:s];
        }
    }
    temp2=NSTemporaryDirectory();
    temp2= [temp2 stringByAppendingPathComponent:@"newlocalstring.txt"];
    string2 =[@"新的全部内容localizable列表\n" stringByAppendingString:string2];
    [string2 writeToFile:temp2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //保存当前 没有被使用localstr但是在loclizabile中
    NSString *temp3=NSTemporaryDirectory();
    temp3= [temp3 stringByAppendingPathComponent:@"knewNoCurrentDataArr.txt"];
    string1 =[newNoCurrentDataArr componentsJoinedByString:@"\n"];
    string1 =[@"保存当前 没有被使用localstr但是在loclizabile中\n" stringByAppendingString:string1];
    [string1 writeToFile:temp3 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    CLog(@"finish searchAllEnglishFromMMatchLocalizalible");
}

/**
 *复制所有代码保存到一个文件上，主要作业是将代码提交申请著作权
 * 将所有文件中，以J开头的文件，并且是有.m文件，则将这个文件下的.h .m文件同时复制到文本上
 *其他的开头，或者没有.m文件则不使用
 */
+(void) funj_searchToCopyAllCodeToFile{
    NSString *path  = [[NSBundle mainBundle]bundlePath];
    NSString* fileName;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
 
    NSString *contents = @"";
    NSString *split = @"All rights reserved.\n//\n";
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        if(![fileName hasPrefix:@"J"] || ![fileName hasSuffix:@"m_txt"])continue;
        NSArray *nameArr = [fileName componentsSeparatedByString:@"."];
            NSString *path =[[NSBundle mainBundle]pathForResource:nameArr[0] ofType:@"h_txt"];
            NSString *path2 =[[NSBundle mainBundle]pathForResource:nameArr[0] ofType:@"m_txt"];
            
            NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSString *str2 =[NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
            
            NSInteger index = [str rangeOfString:split].location+[str rangeOfString:split].length;
            NSInteger index2 = [str2 rangeOfString:split].location +[str2 rangeOfString:split].length;
            
            if(index !=NSNotFound){
                str =[str substringFromIndex:index];
                if(index2 !=NSNotFound){
                    str2 =[str2 substringFromIndex:index2];
                    contents =[contents stringByAppendingFormat:@"%@\n%@\n",str,str2];
                }
            }
        
    }
    NSString *temp=NSTemporaryDirectory();
    temp= [temp stringByAppendingPathComponent:@"localizable.txt"];
    
    [contents writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    CLog(@"%@",temp);
}
/**
 *查找所有本地的图片，是否都在被使用在代码中。
 * 如果是Assets.xcassets中的图片，则将其内所到文件（目录）到空文件夹中，将导入项目目录下即可以。因为在目录下编译后可以找到。但是如果放在Assets.xcassets目录下则无法找到。
 *而其他在项目中图片，则不用处理
 */
+(void) funj_checkAllImageIsValidToCode{
    NSString *path  = [[NSBundle mainBundle]bundlePath];
    NSString* fileName;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    NSMutableDictionary *saveAllImageName = [[NSMutableDictionary alloc]init];
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        if([fileName hasSuffix:@".png"] && [fileName rangeOfString:@"/"].length<=0 && ![fileName hasPrefix:@"AppIcon"]){
            NSInteger lentsub = [fileName rangeOfString:@"@"].location;
            if(lentsub != NSNotFound){
                fileName = [fileName substringToIndex:lentsub];
            }
            [saveAllImageName setObject:@"" forKey:fileName];
        }
    }
    childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    NSString *regex = @"@\"[^\"]*[^\"\n]*?\"";
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        if([fileName hasSuffix:@"_txt"]){
            NSString *path =[[NSBundle mainBundle]pathForResource:fileName ofType:nil];
            
            NSString *str =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            for(long index = 0;index<str.length;index++){
                NSRange range = [str rangeOfString:regex options:NSRegularExpressionSearch range:NSMakeRange(index, str.length-index)];
                 if(range.length >0){
                     NSString *name = [str substringWithRange:NSMakeRange(range.location+2, range.length-3)];
                     if([saveAllImageName objectForKey:name]){
                         [saveAllImageName setObject:name forKey:name];
                     }
                  }
                index = range.location + range.length -1;
            }
        }
    }
    __block NSMutableArray *noHasImageArr = [[NSMutableArray alloc]init];
    [saveAllImageName enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if(obj && obj.length<=0){
            [noHasImageArr addObject:key];
        }
    }];
    
    NSString *temp=NSTemporaryDirectory();
    temp= [temp stringByAppendingPathComponent:@"donotuserimagefile.txt"];
     [noHasImageArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       return [obj1 compare:obj2]>0;
     }];
    NSString *contents =[noHasImageArr componentsJoinedByString:@"\n"];
    
    [contents writeToFile:temp atomically:YES encoding:NSUTF8StringEncoding error:nil];
    CLog(@"%@",temp);

}

@end

