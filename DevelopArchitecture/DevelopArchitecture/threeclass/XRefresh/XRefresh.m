////
////  XRefresh.m
////  ObjectCDemo
////
////  Created by XiaoJingYuan on 5/23/16.
////  Copyright © 2016 XiaoJingYuan. All rights reserved.
////
//
//#import "XRefresh.h"
//#import <objc/runtime.h>
//#define kScreen_Width [UIScreen mainScreen].bounds.size.width
//#define kScreen_Height [UIScreen mainScreen].bounds.size.height
//CGFloat const refreshHeight = 64;
//CGFloat const increaseHeight = 30;
//static NSTimeInterval const delayTime = 1;
//static NSTimeInterval const animateDurationTime = 0.3;
//static char *refreshm_headView = "m_headView";
//static char *refreshm_footView = "m_footView";
//
//typedef NS_ENUM(NSInteger, XRefreshState) {
//    XRefreshStateBeganDrag = 0,     // 开始拉。
//    XRefreshStateCanTouchUp,     //手势所处位置，松手可以开始刷新
//    XRefreshStateDragEnd,       //松手,开始加载。
//    XRefreshStateBack,       //加载完毕开始复位。
//    XRefreshStateEnd        //回到原位，整个环节结束。
//};
//
//#pragma mark -- 刷新动画界面
//@interface XRefreshView ()
//
//@property (nonatomic, strong)UILabel   *titleLabel,  *sloganLabel;
//@property (nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
//@property (nonatomic, strong)UIImageView *arrowImage;
//@property (nonatomic, copy)XRefreshHeadle xRefreshHeadle;
//
////状态
//@property (nonatomic, assign)XRefreshState    state;
///**
// *  下拉刷新，他判断是否符合返回条件。保证最低停留时间。Yes即将停止加载，再次触发就停止加载。
// */
//@property (nonatomic, assign)BOOL    willStop;
///**
// *  判断上拉提示语，是否需要改变，是否可以加载更多。默认NO是可以加载更多。Yes停止加载。
// */
//@property (nonatomic, assign)BOOL    noIncreae;
////上面显示标题的数组，和状态相对应。
//@property (nonatomic, strong)NSArray     *titleArray;
//@property (nonatomic, assign)BOOL         sizeObserving;//是否在监听size
//@property (nonatomic, assign)BOOL         offsetObserving;//是否在监听offset
//
//@property(nonatomic,copy)NSDate *lastUpdateTime;
//- (instancetype)initWithIncreaseFrame:(CGRect)frame;
//
//@end
//
//@implementation XRefreshView
//#pragma mark -- 下拉刷新
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.titleArray =@[NSLocalizedString(@"Pull down to refresh",nil),NSLocalizedString(@"Release to refreshing",nil),NSLocalizedString( @"Refresh...",nil),NSLocalizedString(@"Refresh finished",nil),NSLocalizedString(@"Pull down to refresh",nil)];
//        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
//        self.arrowImage.frame = CGRectMake(0, 0, 15, 40);
//        [self addSubview:_arrowImage];
//        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityIndicatorView.frame = self.arrowImage.frame;
//        [self addSubview:self.activityIndicatorView];
//        
//        
//        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.5+20, frame.size.height - 30, frame.size.width*0.6, 20)];
//        _titleLabel.font= [UIFont systemFontOfSize:12];_titleLabel.textColor = [UIColor grayColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.titleLabel];
//        
//        _sloganLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.5+20, frame.size.height -50, frame.size.width*0.6, 20)];
//        self.sloganLabel.font = [UIFont boldSystemFontOfSize:12];
//        _sloganLabel.textAlignment = NSTextAlignmentCenter;_sloganLabel.textColor = [UIColor grayColor];
//        [self addSubview:self.sloganLabel];
//        
//        self.state = XRefreshStateEnd;
//        self.lastUpdateTime = [NSDate date];
//        
//    }
//    return self;
//}
//#pragma mark 更新时间字符串
//- (void)setLastUpdateTime:(NSDate *)lastUpdateTime{
//    _lastUpdateTime = lastUpdateTime;
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
//    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
//    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
//    // 2.格式化日期
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    if ([cmp1 day] == [cmp2 day]) { // 今天
//        formatter.dateFormat = @"HH:mm";
//    } else if ([cmp1 year] == [cmp2 year]) {
//        formatter.dateFormat = @"MM/dd HH:mm";
//    }
//    NSString *time = [formatter stringFromDate:_lastUpdateTime];
//    
//    // 3.显示日期
//    CGSize labelsize = CGSizeMake(self.frame.size.width,20);
//    self.sloganLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"Last Updated",nil),time];
//    CGFloat width =[self.sloganLabel.text boundingRectWithSize:labelsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.sloganLabel.font} context:nil].size.width;
//    width += 10 + self.arrowImage.frame.size.width;
//    self.arrowImage.frame = CGRectMake((self.frame.size.width- width)/2, self.frame.size.height-10-self.arrowImage.frame.size.height, self.arrowImage.frame.size.width, self.arrowImage.frame.size.height);
//    self.titleLabel.frame = CGRectMake(self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width + 10,self.frame.size.height - 30, width-10-self.arrowImage.frame.size.width, 20);
//    self.sloganLabel.frame = CGRectMake(self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width + 10,self.frame.size.height - 50, width-10-self.arrowImage.frame.size.width, 20);
//    self.activityIndicatorView.frame = self.arrowImage.frame;
//    
//}
//- (void)setState:(XRefreshState)state{
//    //没有更多的时候，状态不发生改变。
//     if (self.noIncreae) {
//        return;
//    }
//    _state = state;
//    self.titleLabel.text = self.titleArray[self.state];
//    switch (state) {
//        case XRefreshStateEnd:  {
//            self.arrowImage.hidden = NO;
//            if (self.activityIndicatorView) {
//                [self.activityIndicatorView stopAnimating];
//            }
//        }  break;
//            
//        case XRefreshStateCanTouchUp: {
//            [UIView animateWithDuration:animateDurationTime animations:^{
//                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
//            }];
//        } break;
//        case XRefreshStateBeganDrag: {
//            [UIView animateWithDuration:animateDurationTime animations:^{
//                self.arrowImage.transform = CGAffineTransformIdentity;
//            }];
//        }  break;
//        case XRefreshStateDragEnd:  {
//            //拖拽结束，开始加载
//            if (self.xRefreshHeadle) {
//                self.willStop = NO;
//                self.xRefreshHeadle();
//            }
//            self.arrowImage.hidden = YES;
//            if(self.activityIndicatorView) {
//                [self.activityIndicatorView startAnimating];
//            }
//        } break;
//            
//        case XRefreshStateBack: {
//            
//        } break;
//        default:
//            break;
//    }
//}
//
//#pragma mark -- 上拉增加更多
//- (instancetype)initWithIncreaseFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.titleArray =@[NSLocalizedString(@"Pull up to load more",nil),NSLocalizedString(@"Release to load more",nil),NSLocalizedString(@"Data loading...",nil),NSLocalizedString(@"Data loading...",nil),NSLocalizedString(@"Pull up to load more",nil)];
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, increaseHeight)];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.textColor = [UIColor lightGrayColor];
//        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self addSubview:self.titleLabel];
//        self.state = XRefreshStateEnd;
//    }
//    return self;
//}
//- (void)willMoveToSuperview:(UIView *)newSuperview{
//    [super willMoveToSuperview:newSuperview];
//    if (newSuperview == nil && self.superview) {
//        UIScrollView *scrollView = (UIScrollView *)self.superview;
//        if (self.offsetObserving) {
//            [scrollView removeObserver:scrollView forKeyPath:@"contentOffset"context:@"xrefresh"];
//            self.offsetObserving = NO;
//        }
//        if (self.sizeObserving) {
//            [scrollView removeObserver:scrollView forKeyPath:@"contentSize"context:@"xrefresh"];
//            self.sizeObserving = NO;
//        }
//    }
//}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    if(self.sloganLabel){
//        CGSize labelsize = CGSizeMake(self.frame.size.width,20);
//        CGFloat width =[self.sloganLabel.text boundingRectWithSize:labelsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.sloganLabel.font} context:nil].size.width;
//        width += 10 + self.arrowImage.frame.size.width;
//        self.arrowImage.frame = CGRectMake((self.frame.size.width- width)/2, self.frame.size.height-10-self.arrowImage.frame.size.height, self.arrowImage.frame.size.width, self.arrowImage.frame.size.height);
//        self.titleLabel.frame = CGRectMake(self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width + 10,self.frame.size.height - 30, width-10-self.arrowImage.frame.size.width, 20);
//        self.sloganLabel.frame = CGRectMake(self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width + 10,self.frame.size.height - 50, width-10-self.arrowImage.frame.size.width, 20);
//        self.activityIndicatorView.frame = self.arrowImage.frame;
//        
//    }else{
//        self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, increaseHeight);
//    }
//    
//}
//@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//#pragma mark -- UIScrollView 刷新
//@implementation UIScrollView(XRefresh)
//
//@dynamic m_footView;
//@dynamic m_headView;
//
//#pragma mark -- 添加下拉刷新
//- (void)funj_addHeaderWithCallback:(XRefreshHeadle)refreshHeadle{
//    if(!self.m_headView){
//        XRefreshView *view = [[XRefreshView alloc]initWithFrame:CGRectMake(0, -100-refreshHeight, self.frame.size.width, refreshHeight+100)];
//        [self addSubview:view];
//        self.m_headView = view;
//        self.m_headView.originalOffSetY = 0;
//        if (!self.m_headView.offsetObserving) {
//            [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"xrefresh"];
//            self.m_headView.offsetObserving = YES;
//        }
//    }
//    self.m_headView.xRefreshHeadle = refreshHeadle;
//}
//
//- (void)setM_headView:(XRefreshView *)m_headView {
//    [self willChangeValueForKey:@"m_headView"];
//    objc_setAssociatedObject(self, refreshm_headView,
//                             m_headView,
//                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"m_headView"];
//    
//}
//- (XRefreshView *)m_headView {
//    return objc_getAssociatedObject(self, refreshm_headView);
//}
//
//#pragma mark -- 添加上拉更多
//- (void)funj_addFooterWithCallback:(XRefreshHeadle)refreshHeadle {
//    if (!self.m_footView) {
//        XRefreshView *m_footView = [[XRefreshView alloc]initWithIncreaseFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, increaseHeight) ];
//        [self addSubview:m_footView];
//        self.m_footView = m_footView;
//        
//        if (!self.m_footView.sizeObserving) {
//            [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"xrefresh"];
//            self.m_footView.sizeObserving = YES;
//        }
//    }
//    self.m_footView.xRefreshHeadle = refreshHeadle;
//}
//
//- (void)setM_footView:(XRefreshView *)m_footView {
//    [self willChangeValueForKey:@"m_footView"];
//    objc_setAssociatedObject(self, refreshm_footView,
//                             m_footView,
//                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"m_footView"];
//}
//- (XRefreshView *)m_footView{
//    return objc_getAssociatedObject(self, refreshm_footView);
//}
//#pragma mark -- 监听
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    
//    if ([keyPath isEqualToString:@"contentOffset"]) {
//        [self scrollViewDidScroll :[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
//    }  else if ([keyPath isEqualToString:@"contentSize"]) {
//        if (![[change objectForKey:NSKeyValueChangeOldKey ] isEqual:change[NSKeyValueChangeNewKey]]) {
//            if (self.contentSize.height>=self.frame.size.height) {
//                self.m_footView.hidden = NO;
//                self.m_footView.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, 30);
//            } else {
//                self.m_footView.hidden = YES;
//            }
//        }
//    }
//}
//- (void)scrollViewDidScroll:(CGPoint)contentOffset {
//     if (self.contentOffset.y<0) {//只有下拉的时候，才会判断下拉刷新
//         if (self.m_headView.state == XRefreshStateEnd&&!self.isDragging) {//如果还没有拖拽就发生偏移错误，就进行修正。
//            if (self.contentOffset.y!=self.m_headView.originalOffSetY) {
//                self.contentInset = UIEdgeInsetsMake(-self.m_headView.originalOffSetY, 0, self.contentInset.bottom, 0);
//                self.contentOffset = CGPointMake(0, self.m_headView.originalOffSetY);
//            }
//        }
//        
//        if (contentOffset.y <= self.m_headView.originalOffSetY- refreshHeight) {
//            if (!self.isDragging) {
//                if (self.m_headView.state == XRefreshStateCanTouchUp) {
//                    [self funj_startRefresh];
//                }
//            } else  {
//                if (self.m_headView.state == XRefreshStateBeganDrag) {
//                    self.m_headView.state = XRefreshStateCanTouchUp;
//                }
//            }
//        } else  {
//            if (self.isDragging) {//在下拉较轻时，正在拉就是开始拉着了，如果手指没有拖拽，就是已经结束归位了。
//                 if(self.m_headView.state == XRefreshStateDragEnd){
//                    self.m_headView.willStop = YES;
//                    self.m_headView.state = XRefreshStateEnd;
//                    [self funj_stopRefresh];
//                }
//                self.m_headView.state = XRefreshStateBeganDrag;
//            }  else  {
//                if (self.m_headView.state !=XRefreshStateEnd) {
//                    self.m_headView.state = XRefreshStateEnd;
//                }
//            }
//            //            //只要不是刚拖拽结束加载的时候，图都是随动的。
//            //            if (self.m_headView.state != XRefreshStateDragEnd) {
//            //                float height =MIN((self.m_headView.originalOffSetY-contentOffset.y), 58);
//            //             }
//            
//        }
//        
//    }else if(self.contentSize.height && self.contentOffset.y && self.contentOffset.y >= self.contentSize.height- self.bounds.size.height-increaseHeight*5 &&
//             !self.m_footView.noIncreae){//上拉加载更多
//         if (self.isDragging) {
//            if (self.m_footView.state != XRefreshStateCanTouchUp) {
//                self.m_footView.state = XRefreshStateCanTouchUp;
//            }
//        } else   {
//            if (self.m_footView.state ==XRefreshStateCanTouchUp ) {
//                [self startIncrease];
//            }
//        }
//    }
// }
//
//- (void)funj_startRefresh {
//    
//    self.m_headView.state = XRefreshStateDragEnd;
//    [UIView animateWithDuration:0.1 animations:^{
//        //顺序是 上左下右
//        self.contentInset = UIEdgeInsetsMake(-self.m_headView.originalOffSetY+refreshHeight,0,  self.contentInset.bottom, 0) ;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    //如果刷新了界面那么就再次可以加载更多了
//    if (self.m_footView) {
//        self.m_footView.noIncreae = NO;
//    }
//    [self performSelector:@selector(goBackSite) withObject:self.m_headView afterDelay:delayTime];
//    [self performSelector:@selector(funj_stopRefresh) withObject:self.m_headView afterDelay:delayTime*3];
//    
//}
//- (void)funj_stopRefresh {
//    
//    [self goBackSite];
//    self.m_headView.lastUpdateTime = [NSDate date];
//    self.m_headView.arrowImage.transform = CGAffineTransformIdentity;
//    
//    if (self.m_footView) {
//        self.m_footView.state = XRefreshStateEnd;
//    }
//}
////加载结束返回原来的位置。
//- (void)goBackSite {
//    
//    if (self.m_headView.willStop == YES) {
//        self.m_headView.state = XRefreshStateBack;
//        [UIView animateWithDuration:animateDurationTime animations:^{
//            self.contentInset = UIEdgeInsetsMake(-self.m_headView.originalOffSetY, 0, self.contentInset.bottom, 0);
//        }completion:^(BOOL finished) {
//            self.m_headView.state = XRefreshStateEnd;
//            self.m_headView.willStop = NO;
//        }];
//    }
//    else
//    {
//        self.m_headView.willStop = YES;
//        if (self.m_footView.state != XRefreshStateBack) {
//            self.m_footView.state = XRefreshStateBack;
//        }
//    }
//    
//    
//}
//- (void)startIncrease {
//    if (self.m_footView.state == XRefreshStateCanTouchUp) {
//        self.m_footView.state = XRefreshStateDragEnd;
//    }
//}
//- (void)noIncrease {
//    self.m_footView.noIncreae = YES;
//    self.m_footView.state = XRefreshStateEnd;
//    self.m_footView.titleLabel.text = NSLocalizedString(@"No more...", nil);
//}
//- (void)canIncrease {
//    self.m_footView.noIncreae = NO;
//}
//- (void)funj_removeFooterView{
//    [self.m_footView removeFromSuperview];
//    self.m_footView.xRefreshHeadle = nil;
//    self.m_footView = nil;
//}
//- (void)funj_removeHeaderView{
//    [self.m_headView removeFromSuperview];
//    self.m_headView.xRefreshHeadle = nil;
//    self.m_headView = nil;
//}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    self.m_footView.frame = CGRectMake(0, MAX(self.contentSize.height, self.frame.size.height), self.frame.size.width, increaseHeight);
//    self.m_headView.frame = CGRectMake(0, self.m_headView.frame.origin.y, self.frame.size.width, refreshHeight+100);
//}
//@end
//
//
