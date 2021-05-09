//
//  JPickView.h
//  bimsopFM
//
//  Created by Jeffrey on 15/4/2.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseView.h"
typedef enum PickType{
    DateAndTime =1,
    OnlyDate,
    OnlyTime,
    PickPlistName,
    PickPlistArray
}PickType;

typedef void (^callBackSelector)(NSDictionary*result,BOOL isFinish);

@interface JPickView : JBaseView
@property(nonatomic,strong)NSMutableDictionary *m_resultDic;
@property(nonatomic,strong)UIPickerView *m_pickerView;

-(instancetype)initWithPlistName:(NSString *)plistName/*(NSArray<NSArray*> *)*/ callback:(callBackSelector)callback;

-(instancetype)initWithPlistType:(PickType)plistType callback:(callBackSelector)callback;

-(instancetype)initWithPlistArray:(NSArray<NSArray*> *)plistarray callback:(callBackSelector)callback;

-(void)funj_setPickTitle:(NSString *)title cname:(NSArray *)contentName cid:(NSArray *)contentId;
-(void)funj_setDefaultPicker:(NSArray*)array;

-(void)show;
-(void)remove;

-(void)funj_doneClick;
@end
