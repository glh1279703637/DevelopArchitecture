//
//  JBaseTableViewVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/7/15.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseTableViewVC.h"

@interface JBaseTableViewVC ()
@property(nonatomic,copy)reloadToSolveDataCallback m_reloadTableViewCallback;
@end

@implementation JBaseTableViewVC
@synthesize m_defaultImageView;
-(id)init{
    if(self=[super init]){
        self.m_isSearchTableViewList=NO;
         _m_isCanDeleteTableItem=NO;
    }
    return self;
}
-(void)setM_isSearchTableViewList:(BOOL)isSearchTableViewList{
    UIScrollView *tableview = [self funj_getTabeleView];
    tableview.m_currentPageType = isSearchTableViewList;
    _m_isSearchTableViewList = isSearchTableViewList;
}
maddProperyValue(m_dataArr, NSMutableArray)
maddProperyValue(m_searchDataArr, NSMutableArray)
maddProperyValue(m_dataSet, NSMutableSet)
maddProperyValue(m_searchDataSet, NSMutableSet)
maddProperyValue(m_multTypeDataModel, JTableDataArrModel)
maddProperyValue(m_searchMultTypeDataModel, JTableDataArrModel)
maddProperyValue(m_saveQuestionHeightDic, NSMutableDictionary)

-(UIView*)m_topView{
    if(!_m_topView){
        _m_topView =[UIView funj_getView:CGRectMake(0, 0, KWidth, 0) :COLOR_WHITE_DARK];
        [self.view addSubview: _m_topView];
        _m_topTableViewLine =[UIImageView funj_getLineImageView:CGRectMake(0, 0, KWidth, 1)];
        [_m_topView addSubview:_m_topTableViewLine];
     }
    return _m_topView;
}
-(JSearchBar*)m_searchBar{
    if(!_m_searchBar){
        _m_searchBar = [[JSearchBar alloc] initWithFrame:CGRectMake(0,0,KWidth,37)];
        _m_searchBar.searchDelegate = self;
        _m_searchBar.m_filletValue = JFilletMake(0.5, 37/2, COLOR_LINE_GRAY_DARK);
        _m_searchBar.hidden = YES;
        [_m_searchBar funj_reloadSearchState:YES :YES];
        [_m_topView addSubview:_m_searchBar];
        
        _m_blackImageView=[UIImageView funj_getBlackAlphaView:CGRectMake(0, 0, KWidth, KHeight)];
        _m_blackImageView.hidden=YES;
        [self.view addSubview:_m_blackImageView];
        __weak typeof(self) weakSelf = self;
        [_m_blackImageView  funj_whenTouchedDown:^(UIView *sender) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.m_searchBar endEditing:YES];
            [strongSelf funj_searchBarState:NO];
            strongSelf.m_isSearchTableViewList=NO;
            [strongSelf funj_reloadData];
        }];
        [self.view addSubview:_m_blackImageView];
    }
    return _m_searchBar;
}
-(UITableView*)m_tableView{
    if(!_m_tableView){
        _m_tableView = kcreateTableViewWithDelegate(self);
    }
    return _m_tableView ;
}
-(UIScrollView*)funj_getTabeleView{
    UIScrollView *tableview = nil;
    if([self isKindOfClass:NSClassFromString(@"JBaseCollectionVC")]){
        tableview = [self valueForKeyPath:@"m_collectionView"];
    }else{
        tableview = [self valueForKeyPath:@"m_tableView"];
    }
    return tableview;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITableView* tableview = (UITableView*)[self funj_getTabeleView];
    self.m_defaultImageView.hidden = tableview.visibleCells.count>0;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self addNoDataDefaultView];
    if(![self isKindOfClass:NSClassFromString(@"JBaseCollectionVC")]){
        [self.view addSubview:self.m_tableView];
    }
 }

-(void)addNoDataDefaultView{
     m_defaultImageView=[UIImageView funj_getImageView:CGRectZero image:@"uu_tableview_default_icon"];
    
    UILabel *contentLabel =[UILabel funj_getLabel:CGRectMake(0, 0, 200, 20) :LocalStr(@"Here is a wilderness ...Nothing left") :JTextFCMakeAlign(PUBLIC_FONT_SIZE17,COLOR_TEXT_GRAY_DARK,NSTextAlignmentCenter)];
    [m_defaultImageView addSubview:contentLabel];
    contentLabel.tag = 9993;
}
-(void)funj_reloadBaseViewParameter:(CGRect)m_topViewFrame :(CGRect)tableViewFrame :(BOOL)searchBarHidden{
    if(!CGRectEqualToRect(m_topViewFrame, CGRectZero)){
         self.m_topView.frame=m_topViewFrame;
         self.m_topTableViewLine.frame=CGRectMake(_m_topTableViewLine.left, _m_topView.height-1, _m_topView.width, _m_topTableViewLine.height);
    }
    UIScrollView *tableview = [self funj_getTabeleView];
    tableview.frame=tableViewFrame;

    if(!searchBarHidden){
        self.m_searchBar.hidden = searchBarHidden;
        _m_searchBar.width = m_topViewFrame.size.width;
        CGPoint point = [self.view convertPoint:_m_searchBar.origin fromView:_m_searchBar];
        self.m_blackImageView.frame=CGRectMake(_m_blackImageView.left, point.y+_m_searchBar.height  , _m_topView.width, CGRectGetHeight(tableViewFrame)+(CGRectGetMinY(tableViewFrame)-_m_topTableViewLine.top));
    }
 
    CGFloat width = IS_IPAD ? 300 : 200;
    m_defaultImageView.frame=CGRectMake(CGRectGetWidth(tableViewFrame)/2-width/2, MAX(CGRectGetHeight(tableViewFrame)/2-width/2-60, 0), width, width);
    UILabel *contentLabel =[m_defaultImageView viewWithTag:9993];
    contentLabel.frame = CGRectMake((m_defaultImageView.width-tableview.width)/2, m_defaultImageView.height+10, tableview.width, 20);
    [tableview addSubview:m_defaultImageView];
}

-(void)funj_reloadTableViewToSolveData:(reloadToSolveDataCallback)callback{
    if(callback){
        self.m_reloadTableViewCallback=callback;
        __weak typeof(self) weakSelf = self;
        UIScrollView *tableview = [self funj_getTabeleView];
 
        [tableview funj_addFooterWithCallback:^(NSInteger page) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.m_isReloadNewDataing = NO;
            if(strongSelf. m_reloadTableViewCallback)strongSelf.m_reloadTableViewCallback(NO,strongSelf.m_isSearchTableViewList,page);
        }];
        [tableview funj_addHeaderWithCallback:^(NSInteger page) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.m_isReloadNewDataing = YES;
            if(strongSelf. m_reloadTableViewCallback)strongSelf.m_reloadTableViewCallback(YES,strongSelf.m_isSearchTableViewList,page);
        }];
    }
}
#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.m_isSearchTableViewList)return [_m_searchDataArr count];
    else return [_m_dataArr count];
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 40;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dic =[self.m_dataArr objectAtIndex:indexPath.row];
//    if([self.m_saveQuestionHeightDic objectForKey:dic[@"classroomId"]]){
//        return [self.m_saveQuestionHeightDic doubleWithKey:dic[@"classroomId"]];
//    }
    return 50;
}
//继承的此类的，要覆盖这个方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    self.m_defaultImageView.hidden=YES;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    self.m_defaultImageView.hidden=YES;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    self.m_defaultImageView.hidden=YES;
}
//***************************删除cell***************************
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.m_isCanDeleteTableItem) return YES;
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:_m_tableView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [_m_tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}
//设置删除标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LocalStr(@"Delete");
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [JAppViewTools funj_showAlertBlocks:self  :nil :LocalStr(@"Do you want to delete? ") :^(id strongSelf, NSInteger index) {
            
        }];
    }
}
-(void)funj_addCellCallbackHeight:(JBaseTableViewCell*)cell :(NSString*)idKey{
    __weak typeof(self) weakSelf = self;
     cell.m_callbackHeight = ^(NSString*idKey,CGFloat height) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong typeof(weakSelf) strongSelf=weakSelf;
            if(strongSelf && [[strongSelf.m_saveQuestionHeightDic objectForKey:idKey] floatValue] != height){
                [strongSelf.m_saveQuestionHeightDic setObject:[NSString stringWithFormat:@"%f",height] forKey:idKey];
             }
        });
    };
}
#pragma mark JsearchBar delegate
- (BOOL)funj_searchShouldBeginEditing:(UITextField *)textField{
    if([textField.text length] <=0){
        self.m_isSearchTableViewList=NO;
        [self funj_searchBarState:YES];
    }else{
        self.m_isSearchTableViewList=YES;
        [self funj_searchBarState:NO];
    }
    return YES;
}
-(BOOL)funj_search:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string{
    if(range.length<=0 || (textField.text.length>1 && range.length>=1)){
        self.m_isSearchTableViewList = YES;
        [self funj_searchBarState:NO];
    }else{
        self.m_isSearchTableViewList = NO;
        [self funj_searchBarState:YES];
    }
    return YES;
}
-(void)funj_searchDidEndEditing:(UITextField *)textField{
    if(textField.text.length>0){
        self.m_isSearchTableViewList = YES;
    }else{
        self.m_isSearchTableViewList = NO;
    }
    [self funj_searchBarState:NO];
    [self funj_reloadData];
}
-(void)funj_searchReturnButtonClicked:(UITextField*)textField{
    self.m_isSearchTableViewList = YES;
    [self funj_searchBarState:NO];
}
-(void)funj_searchCancelButtonClicked:(UITextField *)textField{
    self.m_isSearchTableViewList = NO;
    [self funj_searchBarState:NO];
}

-(void)funj_searchBarState:(BOOL)isShowBlack{
     _m_blackImageView.hidden=!isShowBlack;
}
-(void)funj_solverToSetData:(NSArray*)data :(NSMutableSet*)targetArr{
    if(!targetArr){
        targetArr = self.m_isSearchTableViewList ? self.m_searchDataSet : self.m_dataSet;
    }
    if(self.m_isReloadNewDataing){
        [targetArr removeAllObjects];
        [self funj_reloadData];
    }
    self.m_isReloadNewDataing= NO;
    
    if(!data || [data count]<=0 ){
        self.m_defaultImageView.hidden = targetArr.count;
        return;
    }
    [targetArr addObjectsFromArray:data];
    self.m_defaultImageView.hidden = targetArr.count;
    [self funj_reloadData];
}
-(void)funj_solverToSubRepeatData:(NSArray*)data :(NSMutableArray*)targetArr :(NSString*)key{
    [self funj_solverToSubRepeatData:data :targetArr :key :nil];
}
-(void)funj_solverToSubRepeatData:(NSArray*)data :(NSMutableArray*)targetArr :(NSString*)key :(NSString*)model{
    //    if(!data || [data count]<=0 || !key || key.length<=0) return;
    if(!targetArr){
        targetArr = self.m_isSearchTableViewList ? self.m_searchDataArr : self.m_dataArr;
    }
    if(self.m_isReloadNewDataing){
        [targetArr removeAllObjects];
        [self funj_reloadData];
    }
    self.m_isReloadNewDataing= NO;
    
    if(!data || [data count]<=0 ){
        self.m_defaultImageView.hidden = targetArr.count;
        return;
    }
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:targetArr];
    
    if(model && model.length>0){
        SEL sel=NSSelectorFromString(key);
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block NSUInteger isHas = NSNotFound;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id object= [obj performSelector:sel];
            [array enumerateObjectsUsingBlock:^(id _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                id object2= [obj2 performSelector:sel];
                if([[NSString stringWithFormat:@"%@",object] isEqualToString:[NSString stringWithFormat:@"%@",object2]]){
                    isHas = idx2; *stop2=YES;
                }
            }];
#pragma clang diagnostic pop
            if(isHas == NSNotFound && obj){
                [array addObject:obj];
            }else{
                if(isHas < array.count){
                    [array insertObject:obj atIndex:isHas];
                }else{
                    [array addObject:obj];
                }
            }
            [array removeObjectAtIndex:isHas+1];
            
        }];
        
    }else{
        [data enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block NSUInteger isHas = NSNotFound;
            [array enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if([obj[key] isKindOfClass:[NSString class]] &&  [obj2[key] isEqualToString:obj[key]]){
                    isHas = idx2; *stop2=YES;
                }else if([obj[key] isKindOfClass:[NSNumber class]] && [obj[key] intValue] == [obj2[key] intValue]){
                    isHas = idx2; *stop2=YES;
                }
            }];
            
            if(isHas == NSNotFound ){
                [array addObject:obj];
            }else{
                if(isHas < array.count){
                    [array insertObject:obj atIndex:isHas];
                }else{
                    [array addObject:obj];
                }
                [array removeObjectAtIndex:isHas+1];
            }
        }];
    }
    
    if(targetArr.count >0){
        [targetArr removeAllObjects];
    }
    [targetArr addObjectsFromArray:array];
    self.m_defaultImageView.hidden = targetArr.count;
    [self funj_reloadData];
}
-(void )funj_reloadData{
    [self.m_tableView reloadData];
}
 
@end

