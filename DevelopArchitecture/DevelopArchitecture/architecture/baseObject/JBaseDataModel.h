//
//  JBaseDataModel.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/1/27.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JConstantHelp.h"

/*//自动封装成对象
 *继承jbasedatamode的nsobject
 *如果属性跟返回值不一致，则需要设置mapAttributes对照表，以dic设备@{@"key":@"key"}
 *mapAttributes(属于参数名与你属性的对照表关系）
 *如果属性跟返回值一致，则不需要重写mapAttributes,则可以自动处理
 *
 *所对应的内容都是为ObjectType
 *
 */

/*//自动归档与解档
 *继承jbasedatamode的nsobject，只要继承就可能了，
 *不需要自己再去实现归档中funj_encodeWithCoder:方法
 *不需要自己再去实现解档中initWithCoder:方法
 */
@interface JBaseDataModel : NSObject
- (id)initWithContent:(NSDictionary *)json;
-(NSDictionary*)funj_getDicFromModel ;
@end

/*
 *由于uibutton action 有很多相同的方法，因此可以通过此方法编写共同部分内容
 */
@interface JBaseCommonAction : JBaseDataModel
@end
