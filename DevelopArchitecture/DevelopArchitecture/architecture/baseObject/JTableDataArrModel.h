//
//  JTableDataArrModel.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/7/21.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseDataModel.h"

//专处理tableview 重叠的问题
@interface JTableDataArrModel : JBaseDataModel
@property(nonatomic,strong)NSMutableArray *m_titleArr,*m_dataModelArr,*m_dataTypeArr,*m_otherMarkArr;

-(void)funj_setTableShowTypeForSection:(NSInteger)section :(BOOL)isOpen;
-(NSArray*)funj_getShowDataWithSection:(NSInteger)section;
-(BOOL)funj_getDataTypeWithSection:(NSInteger)section;
@end
