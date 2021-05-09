//
//  JBaseTableViewVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/7/15.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseViewController.h"
#import "JTableDataArrModel.h"
#import "JRefreshView.h"
#import "JBaseTableViewCell.h"

#define kCellIndentifier @"cellIndentifier"

typedef void (^reloadToSolveDataCallback)(BOOL isHead,BOOL isSearch, NSInteger page);

@interface JBaseTableViewVC: JBaseViewController<UITableViewDataSource,UITableViewDelegate,JSearchBarDelegate>
@property(nonatomic,strong)UIView *m_topView;
@property(nonatomic,strong)JSearchBar *m_searchBar;
@property(nonatomic,strong)UIImageView *m_topTableViewLine,*m_BlackImageView;
@property(nonatomic,strong)UITableView *m_tableView;

//自动适配cell高度
@property(nonatomic,strong)NSMutableDictionary*m_saveQuestionHeightDic;
 
@property(nonatomic,assign)BOOL m_isCanDeleteTableItem;//是否具体左滑删除功能。默认没有
@property(nonatomic,assign)BOOL m_isSearchTableViewList;//正常显示与搜索的关系
@property(nonatomic,strong) UIImageView *m_defaultImageView;//无内容时的默认背影图片

@property(nonatomic,assign) BOOL m_isReloadNewDataing;

//存放数据 有section
@property(nonatomic,strong)JTableDataArrModel *m_multTypeDataModel,*m_searchMultTypeDataModel;//解决重叠的tableview -section
//存放数据 无section
@property(nonatomic,strong)NSMutableArray *m_dataArr,*m_searchDataArr;
@property(nonatomic,strong)NSMutableSet *m_dataSet,*m_searchDataSet;

-(void)funj_reloadBaseViewParameter:(CGRect)topViewFrame f:(CGRect)tableViewFrame hidden:(BOOL)searchBarHidden;//重新设置tablew、searchbar 等视图的坐标与大小

-(void)funj_searchBarState:(BOOL)isShowBlack;//searchbar 相关的方法
-(void)funj_reloadTableViewToSolveData:(reloadToSolveDataCallback)callback;

-(void)funj_solverToSetData:(NSArray*)data d:(NSMutableSet*)targetArr;
-(void)funj_solverToSubRepeatData:(NSArray*)data d:(NSMutableArray*)targetArr k:(NSString*)key;
-(void)funj_solverToSubRepeatData:(NSArray*)data d:(NSMutableArray*)targetArr key:(NSString*)key m:(NSString*)model;

-(void)funj_addCellCallbackHeight:(JBaseTableViewCell*)cell k:(NSString*)idKey;
@end

#define  kcreateTableViewWithDelegate(delegateVC) ({\
UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight) style:UITableViewStylePlain];\
    tableView.tag = 939003;\
    tableView.backgroundColor=[UIColor clearColor];\
    tableView.rowHeight=100.0f;\
    tableView.showsVerticalScrollIndicator=NO;\
    tableView.showsHorizontalScrollIndicator=NO;\
    tableView.delegate=delegateVC;\
    tableView.dataSource=delegateVC;\
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;\
    [tableView registerClass:[JBaseTableViewCell class] forCellReuseIdentifier:kCellIndentifier];\
    if (@available(iOS 11.0, *)) {\
       tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
    }\
    (tableView);\
})
