////
////  XRefresh.h
////  ObjectCDemo
////  Version 1.2.0
////  Created by XiaoJingYuan on 12/30/16.
////  Copyright © 2016 XiaoJingYuan. All rights reserved.
////
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//typedef void (^XRefreshHeadle)(void);
//
//@interface XRefreshView : UIView
////scroll的偏移量,未开拉前的，对应foot是下偏移量，header是上偏移量。
//@property (nonatomic, assign)CGFloat  originalOffSetY;
//@end
//
//@interface UIScrollView(XRefresh)
//
///**
// *  添加下拉刷新的控件
// *
// *  @param refreshHeadle 下拉刷新需要处理的事件
// */
//- (void)funj_addHeaderWithCallback:(XRefreshHeadle)refreshHeadle;
///**
// *  上拉加载更多
// *
// *  @param refreshHeadle 上拉后需要处理的事件
// */
//- (void)funj_addFooterWithCallback:(XRefreshHeadle)refreshHeadle;
//
///**
// *  已经没有更多了，结束上拉增加价更多。
// */
//- (void)noIncrease;
//- (void)canIncrease;
//
///**
// *  开始上拉刷新
// */
//- (void)funj_startRefresh;
///**
// * 结束下拉刷新。
// */
//- (void)funj_stopRefresh;
//- (void)funj_removeFooterView;
//- (void)funj_removeHeaderView;
//
//
//@property (nonatomic, strong)XRefreshView  *m_headView;
//@property (nonatomic, strong)XRefreshView  *m_footView;
//@end
//
