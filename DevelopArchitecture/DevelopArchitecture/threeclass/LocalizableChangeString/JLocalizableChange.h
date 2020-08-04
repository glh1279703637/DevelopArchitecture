//
//  JLocalizableChange.h
//  qqqq
//
//  Created by Jeffrey on 2017/5/18.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>

//本类没有什么作用，主要是对本地国际化快速的生成与转换起作用


@interface JLocalizableChange : NSObject
//搜索所有的中文
+(void) funj_searchAllChinaList;
//将英文的local与中文合并 新成一份
+(void) funj_changeLocalizableChinaCN;
//将英文的local 复制成一份
+(void) funj_changeLocalizable;
//将代码中中文替换成翻译后的英文
+(void) funj_resplaceChinaToLocalStr;
//根据中文进行去重复
//+(void) funj_changeDeleteReapeteCNToLocalizable;
//根据前英文进行去重复
+(void) funj_changeDeleteReapeteENKeyToLocalizable;
//将 "a" = "数字"; 拆分获取到a
+(void)funj_changeSplitWithEquelLocalizable;

/**
 *去除重复的Localizalible.string
 * 如果仅在Localizalible.string 却不在代码，则标记起来
 *如果仅在代码中，却不在Localizalible.string中，则也标记起来
 */
+(void) funj_searchAllEnglishFromMMatchLocalizalible;
/**
 *复制所有代码保存到一个文件上，主要作业是将代码提交申请著作权
 * 将所有文件中，以J开头的文件，并且是有.m文件，则将这个文件下的.h .m文件同时复制到文本上
 *其他的开头，或者没有.m文件则不使用
 */
+(void) funj_searchToCopyAllCodeToFile;
/**
 *查找所有本地的图片，是否都在被使用在代码中。
 * 如果是Assets.xcassets中的图片，则将其内所到文件（目录）到空文件夹中，将导入项目目录下即可以。因为在目录下编译后可以找到。但是如果放在Assets.xcassets目录下则无法找到。
 *而其他在项目中图片，则不用处理
 */
+(void) funj_checkAllImageIsValidToCode;
@end
