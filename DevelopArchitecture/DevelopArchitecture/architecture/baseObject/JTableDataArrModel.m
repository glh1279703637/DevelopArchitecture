//
//  JTableDataArrModel.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/7/21.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JTableDataArrModel.h"
@implementation JTableDataArrModel

maddProperyValue(m_titleArr, NSMutableArray)
maddProperyValue(m_dataModelArr, NSMutableArray)
maddProperyValue(m_dataTypeArr, NSMutableArray)
maddProperyValue(m_otherMarkArr, NSMutableArray)

-(void)funj_setTableShowTypeForSection:(NSInteger)section o:(BOOL)isOpen{
    if(section>=[_m_dataTypeArr count]){
        [_m_dataTypeArr addObject:isOpen?@"YES":@"NO" ];
    }else{
        _m_dataTypeArr[section]=isOpen?@"YES":@"NO";
    }
}
-(NSArray*)funj_getShowDataWithSection:(NSInteger)section{
    if(section<_m_dataTypeArr.count && [_m_dataTypeArr[section]isEqualToString:@"YES"]){
        return _m_dataModelArr[section];
    }else{
        return @[];
    }
}
-(BOOL)funj_getDataTypeWithSection:(NSInteger)section{
    if([_m_dataTypeArr[section]isEqualToString:@"YES"])return YES;
    else return NO;
}

@end

