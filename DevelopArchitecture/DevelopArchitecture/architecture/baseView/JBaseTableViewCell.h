//
//  JBaseTableViewCell.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/7/16.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JConstantHelp.h"
#import "JAppViewExtend.h"
 #import "JWhenTappedView.h"
#import "JReloadImageView.h"

typedef void (^CallbackHeight)(NSString*idKey,CGFloat height);

 @interface JBaseTableViewCell : UITableViewCell
-(void)funj_addBaseTableSubView;
-(void)funj_setBaseTableCellWithData:(NSDictionary*)data;

//在cell中同一行多种类型文字时，并且需要根据字数自动往后排序 // 如：教师名 学校名 在同一行时
-(void)funj_autoAdjustLabelPosition:(NSArray<UILabel*>*)labelArr s:(CGFloat)addInterval a:(CGFloat)addSub;

@property(nonatomic,copy)CallbackHeight m_callbackHeight;

@end
