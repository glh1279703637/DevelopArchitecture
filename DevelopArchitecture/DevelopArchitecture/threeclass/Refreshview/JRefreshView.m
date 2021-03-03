//
//  JRefreshView.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/11/8.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JRefreshView.h"
#import <objc/runtime.h>

#define krefreshHeight 70
static NSTimeInterval const delayTime = 1;

typedef NS_ENUM(NSInteger, JRefreshState) {
    kRefreshStateBeganDrag = 1,     // 开始拉。
    kRefreshStateDragEnd,       //松手,开始加载。
    kRefreshStateEnd        //回到原位，整个环节结束。
};

static char *refreshHeadView = "jheadView";
static char *refreshFootView = "jFootView";
static char *refreshPageDic = "jrefreshPageDic";
@interface JRefreshView()
@property (nonatomic, copy)JRefreshHeadle m_refreshHeadle;
@property (nonatomic, assign)JRefreshState    m_state;
@property(nonatomic,assign)BOOL m_isHead;


@end
@implementation JRefreshView

-(id)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        _m_arrowImageView =[UIImageView funj_getImageView:CGRectMake((CGRectGetWidth(frame)-30)/2, (CGRectGetHeight(frame)-30)/2, 30, 30) image:@"reloading_fresh"];
        [self addSubview:self.m_arrowImageView];
    }
    return self;
}
-(void)setM_isHead:(BOOL)m_isHead{
    _m_isHead = m_isHead;
    _m_arrowLabel =[UILabel funj_getLabel:CGRectMake(_m_arrowImageView.right+10, _m_arrowImageView.top, 0, _m_arrowImageView.height) :JTextFCMake(kFont_Size12, kColor_Text_Gray_Dark)];
    [self addSubview:self.m_arrowLabel];
}
-(void)setM_state:(JRefreshState)m_state{
    _m_state = m_state;
    if(m_state == kRefreshStateBeganDrag){
        self.m_arrowLabel.text =self.m_isHead ? LocalStr(@"Pull down to refresh") : LocalStr(@"Pull up to load more");
    }else if(m_state == kRefreshStateDragEnd ){
        self.m_arrowLabel.text = LocalStr(@"Refresh...");
    }else{
        self.m_arrowLabel.text = LocalStr(@"Refresh finished");
    }
    [self funj_reloadProgressViews:m_state == kRefreshStateBeganDrag];
}

-(void)funj_addProgressAnimate{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.7;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_m_arrowImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)funj_reloadProgressViews:(BOOL)ischangePoint{
    self.m_arrowLabel.width =[JAppUtility funj_getTextWidthWithView:self.m_arrowLabel];
    if(ischangePoint){
        self.m_arrowImageView.left = (self.width - self.m_arrowImageView.width - 10 - self.m_arrowLabel.width )/2;
        self.m_arrowLabel.left = self.m_arrowImageView.right+10;
    }

}

-(void)funj_stopProgressAnimate{
    [_m_arrowImageView.layer removeAllAnimations];
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil && self.superview) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if(!self.accessibilityLabel)return;
        self.accessibilityLabel = nil;
        if (self.m_isHead) {
            [scrollView removeObserver:scrollView forKeyPath:@"contentOffset"context:@"jrefresh"];
        }else{
            [scrollView removeObserver:scrollView forKeyPath:@"contentSize"context:@"jrefresh"];
        }
    }
}
@end

@interface UIScrollView()
@property(nonatomic,strong)NSMutableDictionary *m_refreshPageDic;

@end

@implementation UIScrollView(JRefreshView)
-(void)funj_setPageWithType:(NSInteger)type :(NSInteger)page{
    [self.m_refreshPageDic setObject:@(page) forKey:@(type)];
}
-(void)funj_resetPageWithType:(NSInteger)type{
    [self.m_refreshPageDic setObject:@(1) forKey:@(type)];
}
-(NSInteger)funj_getPageWithType:(NSInteger)type{
    return [self.m_refreshPageDic integerWithKey:@(type)];
}
-(NSInteger)funj_getPage{
    return [self.m_refreshPageDic integerWithKey:@(self.m_currentPageType)];
}
- (void)funj_addHeaderWithCallback:(JRefreshHeadle)refreshHeadle{
    if(!self.m_headView){
        self.m_headView = [[JRefreshView alloc]initWithFrame:CGRectMake(0, -krefreshHeight, self.frame.size.width, krefreshHeight)];
        [self addSubview:self.m_headView];
        self.m_headView.m_isHead = YES;
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"jrefresh"];
        self.m_headView.accessibilityLabel = @"jrefresh";

    }
    if(!self.m_refreshPageDic) self.m_refreshPageDic =[[NSMutableDictionary alloc]init];
    self.m_headView.m_refreshHeadle = refreshHeadle;
}
- (void)funj_addFooterWithCallback:(JRefreshHeadle)refreshHeadle{
    if(!self.m_footView){
        self.m_footView = [[JRefreshView alloc]initWithFrame:CGRectMake(0, MAX(self.contentSize.height, self.frame.size.height), self.frame.size.width, krefreshHeight)];
        [self addSubview:self.m_footView];
        self.m_footView.m_isHead = NO;
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"jrefresh"];
        self.m_footView.accessibilityLabel = @"jrefresh";
    }
    if(!self.m_refreshPageDic) self.m_refreshPageDic =[[NSMutableDictionary alloc]init];
    self.m_footView.m_refreshHeadle = refreshHeadle;
}
- (void)funj_stopRefresh{
    [self funj_stopRefresh:self.m_headView];
    [self funj_stopRefresh:self.m_footView];
}
- (void)funj_removeHeaderView{
    [self.m_headView removeFromSuperview];
    self.m_headView.m_refreshHeadle = nil;
    self.m_headView = nil;
}
- (void)funj_removeFooterView{
    [self.m_footView removeFromSuperview];
    self.m_footView.m_refreshHeadle = nil;
    self.m_footView = nil;
}
- (void)funj_startRefresh:(JRefreshView*)refreshView{
    [refreshView funj_addProgressAnimate];
    NSInteger page = [self.m_refreshPageDic integerWithKey:@(self.m_currentPageType)];
    page = [refreshView isEqual:self.m_headView] ? 1 : page + 1;
    [self.m_refreshPageDic setObject:@(page) forKey:@(self.m_currentPageType)];
    if(refreshView.m_refreshHeadle)refreshView.m_refreshHeadle(page);
}
- (void)funj_stopRefresh:(JRefreshView*)refreshView{
    [UIView animateWithDuration:0.5 animations:^{ //顺序是 上左下右
        self.contentInset = UIEdgeInsetsMake(0,0,0, 0) ;
    }];
    [refreshView funj_stopProgressAnimate];
    refreshView.m_state = kRefreshStateEnd;
}
- (void)funj_removeFooter{
    [self removeObserver:self  forKeyPath:@"contentSize" context:@"jrefresh"];
    [self.m_footView removeFromSuperview];
    self.m_footView.m_refreshHeadle = nil;
    self.m_footView = nil;
}
- (void)funj_removeHeader{
    [self removeObserver:self  forKeyPath:@"contentOffset" context:@"jrefresh"];
    [self.m_headView removeFromSuperview];
    self.m_headView.m_refreshHeadle = nil;
    self.m_headView = nil;
}


#pragma mark propery
- (void)setM_headView:(JRefreshView *)headView {
    [self willChangeValueForKey:@"jheadView"];
    objc_setAssociatedObject(self, refreshHeadView,
                             headView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"jheadView"];
    
}
- (JRefreshView *)m_headView {
    return objc_getAssociatedObject(self, refreshHeadView);
}
- (void)setM_footView:(JRefreshView *)footView {
    [self willChangeValueForKey:@"jfootView"];
    objc_setAssociatedObject(self, refreshFootView,
                             footView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"jfootView"];
}
- (JRefreshView *)m_footView{
    return objc_getAssociatedObject(self, refreshFootView);
}
- (void)setM_refreshPageDic:(NSMutableDictionary *)pageDic {
    [self willChangeValueForKey:@"jrefreshPageDic"];
    objc_setAssociatedObject(self, refreshPageDic,
                             pageDic,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"jrefreshPageDic"];
}
- (JRefreshView *)m_refreshPageDic{
    return objc_getAssociatedObject(self, refreshPageDic);
}
-(void)setM_currentPageType:(NSInteger)pageType{
    [self.m_refreshPageDic setObject:@(pageType) forKey:@"pageType"];
}
-(NSInteger)m_currentPageType{
    return [self.m_refreshPageDic integerWithKey:@"pageType"];
}



#pragma mark -- 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        [self scrollViewDidScrollOffset :point.y];
    }else if ([keyPath isEqualToString:@"contentSize"]) {
        if (![[change objectForKey:NSKeyValueChangeOldKey ] isEqual:change[NSKeyValueChangeNewKey]]) {
            self.m_footView.frame = CGRectMake(0, MAX(self.contentSize.height, self.frame.size.height), self.bounds.size.width, 30);
        }
    }
}
-(void)scrollViewDidScrollOffset:(CGFloat)offsety{
    JRefreshView *headView = offsety< 0 ? self.m_headView : (offsety > 0 ? self.m_footView : nil);
    if(!headView)return;

    if(self.dragging){ //下拉过程中 手指一直在拉
        if(headView.m_state != kRefreshStateBeganDrag){
            headView.m_state = kRefreshStateBeganDrag;
            [self funj_startRefresh:headView];
        }
    }else if(!self.dragging && self.decelerating){
        if(headView.m_state != kRefreshStateDragEnd){
            headView.m_state = kRefreshStateDragEnd;
            if(offsety < -krefreshHeight-2){
                [UIView animateWithDuration:0.1 animations:^{
                    self.contentInset = UIEdgeInsetsMake(krefreshHeight,0,  0, 0) ;
                }];
            }else if( offsety > krefreshHeight + 2 +MAX(0,self.contentSize.height - self.height)){
                [UIView animateWithDuration:0.1 animations:^{
                    self.contentInset = UIEdgeInsetsMake(-(krefreshHeight + 2 + MAX(self.contentSize.height - self.height, 0)),0,  0, 0) ;
                }];
            }
            [self performSelector:@selector(funj_stopRefresh:) withObject:headView afterDelay:delayTime];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.m_footView.frame = CGRectMake(0, MAX(self.contentSize.height, self.frame.size.height), self.frame.size.width, krefreshHeight);
    self.m_headView.frame = CGRectMake(0, self.m_headView.frame.origin.y, self.frame.size.width, krefreshHeight);
}
@end


