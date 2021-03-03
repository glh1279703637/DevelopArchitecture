//
//  JSegmentedControl.h
//  GuideApp
//
//  Created by Jeffrey on 15/7/28.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//
/*
 *自定义滑动视图
 */
#import "JBaseView.h"
typedef NS_ENUM(NSInteger,SegmentType) {
    kSegmentTypeNone,
    kSegmentType5CornerRadius,
    kSegmentTypeAllCornerRadius,
    kSegmentTypeBottomLine
};

typedef void (^selectBt)(NSInteger index);

@interface JSegmentedControl : JBaseView
@property(nonatomic,strong) UIImageView *m_BgImageView;

-(id)initWithFrame:(CGRect)frame :(NSArray*)titles :(selectBt)action;
-(void)funj_setStyleBgView:(NSArray*)bgImageArray textColor:(NSArray*)textColorArray type:(SegmentType)type;
-(void)funj_setSegmentSelectedIndex:(NSInteger)index;
@end
