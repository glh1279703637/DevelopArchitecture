//
//  JRefreshView.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/11/8.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^JRefreshHeadle)(NSInteger page);

@interface JRefreshView : JBaseView
@property(nonatomic,strong)UIImageView *m_arrowImageView;
@property(nonatomic,strong)UILabel *m_arrowLabel;

-(void)funj_addProgressAnimate;
-(void)funj_stopProgressAnimate;

@end
@interface UIScrollView(JRefreshView)

@property (nonatomic, strong,nullable)JRefreshView  *m_headView;
@property (nonatomic, strong,nullable)JRefreshView  *m_footView;

@property(nonatomic,assign)NSInteger m_currentPageType;
-(void)funj_setPageWithType:(NSInteger)type p:(NSInteger)page;//由于同一个刷新，u但是多个page时使用
-(void)funj_resetPageWithType:(NSInteger)type;
-(NSInteger)funj_getPageWithType:(NSInteger)type; //同上
-(NSInteger)funj_getPage;

- (void)funj_addHeaderWithCallback:(JRefreshHeadle)refreshHeadle;
- (void)funj_addFooterWithCallback:(JRefreshHeadle)refreshHeadle;

- (void)funj_stopRefresh;

- (void)funj_removeHeaderView;
- (void)funj_removeFooterView;
@end
NS_ASSUME_NONNULL_END

