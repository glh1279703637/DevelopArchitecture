//
//  JMoreTipView.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/12/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JMoreTipView.h"
@interface JMoreTipView()
@property(nonatomic,assign)TipPointPostion m_tipType;
@property(nonatomic,assign)CGPoint m_tipPoint;
@end
@implementation JMoreTipView
+(void)funj_addMainBottomSwipeView:(UIView*)superView{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"funj_addMainBottomSwipeView"]){
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"funj_addMainBottomSwipeView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JMoreTipView *moreTip =[[JMoreTipView alloc]initWithTitle:@"上滑查看更多课程" :superView];
        [moreTip funj_reloadType:kshowTopPostion :CGPointMake(KWidth/2, KHeight-50-70) :0];
        [moreTip funj_addAutoHiddenViews];
    });
}
-(id)initWithTitle:(NSString*)title :(UIView*)superView{
    CGFloat width = [JAppUtility funj_getTextWidth:title textFont:PUBLIC_FONT_SIZE14];
    
    CGRect frame = CGRectMake(0, 0, width+50, 60);
    if(self =[super initWithFrame:frame]){
        [self funj_setViewGradientLayer:YES :@[COLOR_ORANGE,COLOR_WHITE] :@[@(0.f), @(1.f)]];
        UILabel *titleLabel= [UILabel funj_getLabel:CGRectMake(10, 10, width+30, 40) :title :JTextFCMakeAlign(PUBLIC_FONT_SIZE14, COLOR_WHITE, NSTextAlignmentCenter)];
        [self addSubview:titleLabel];
        [superView addSubview:self];
        
    }
    return self;
}

-(void)funj_reloadType :(TipPointPostion)type :(CGPoint)tipPoint :(CGFloat)Offset{
    self.m_tipType = type;
    CGPoint point;
    CGPoint point2 ;
    if(self.m_tipType == kshowTopPostion || self.m_tipType == kshowBottomPostion){
        point2.x = Offset;
        point.x = tipPoint.x - self.width/2;
        point.y = tipPoint.y - (self.m_tipType == kshowBottomPostion)*self.height;
        
        if(point.x < 10) point.x = 10;
        if(point.x + self.width > self.superview.width - 10) point.x = self.superview.width - 10 - self.width;
    }else{
        point2.y = Offset;
        point.x = tipPoint.x - (self.m_tipType == kshowRightPostion)*self.width;
        point.y = tipPoint.y - self.height/2;
        
        if(point.y < 10) point.y = 10;
        if(point.y + self.height > self.superview.height - 10) point.y = self.superview.height - 10 - self.height;
    }
    self.m_tipPoint = CGPointMake(tipPoint.x-point.x +point2.x, tipPoint.y-point.y +point2.y);
    CGRect frame = CGRectMake(point.x, point.y, self.width, self.height);
    self.frame = frame;
    [self funj_shakeAnimationForView];
}
-(void)funj_addAutoHiddenViews{
    LRWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LRStrongSelf(self);
        [self removeFromSuperview];
    });
}
-(void)funj_shakeAnimationForView{
    [JAppUtility funj_shakeAnimationForView:self :CGSizeMake(0, 10)];
    LRWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LRStrongSelf(self);
        if(!self)return ;
        [self funj_shakeAnimationForView];
    });
}

- (void)drawRect:(CGRect)rect {

    UIBezierPath* path =[UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(10, 15)];
    [path addQuadCurveToPoint:CGPointMake(15, 10) controlPoint:CGPointMake(10,10)];
    
    if(self.m_tipType == kshowTopPostion){//上边
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x-10, 10)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x, self.m_tipPoint.y)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x+10, 10)];
    }
    [path addLineToPoint:CGPointMake(self.width-15, 10)];
    [path addQuadCurveToPoint:CGPointMake(self.width-10, 15) controlPoint:CGPointMake(self.width-10, 10)];
    
    if(self.m_tipType == kshowRightPostion){//右边
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x-10, self.m_tipPoint.y-10)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x, self.m_tipPoint.y)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x-10, self.m_tipPoint.y+10)];
    }
    [path addLineToPoint:CGPointMake(self.width-10, self.height- 15)];
    [path addQuadCurveToPoint:CGPointMake(self.width-15, self.height- 10) controlPoint:CGPointMake(self.width-10, self.height- 10)];
    
    if(self.m_tipType == kshowBottomPostion){//下边
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x+10, self.height-10)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x, self.m_tipPoint.y)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x-10, self.height-10)];
    }
    [path addLineToPoint:CGPointMake(15, self.height- 10)];
    [path addQuadCurveToPoint:CGPointMake(10, self.height- 15) controlPoint:CGPointMake(10, self.height- 10)];
    
    if(self.m_tipType == kshowLeftPostion){//左边
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x+10, self.m_tipPoint.y+10)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x, self.m_tipPoint.y)];
        [path addLineToPoint:CGPointMake(self.m_tipPoint.x+10, self.m_tipPoint.y-10)];
    }
    [path closePath];
    [path fill];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    self.layer.mask = lineLayer;
}
@end
