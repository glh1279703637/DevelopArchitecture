//
//  JProgressHUD.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2017/11/17.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "JProgressHUD.h"
#import "JConstantHelp.h"
#import "JAppViewExtend.h"
static JProgressHUD *progressHUD =nil;
@interface JProgressHUD()
@property(nonatomic,strong)UILabel *m_titleLabel;
@end
@implementation JProgressHUD{
    UIImageView *progressBgImageView,*progressImageView;
    
}
-(id)init{
    if(self =[super init]){
        self.frame = CGRectMake(0,0,KWidth,KHeight);
        self.backgroundColor = COLOR_CREAR;
        progressBgImageView =[UIImageView funj_getImageView:CGRectMake((KWidth-202/2.5)/2, (KHeight-202/2.5)/2, 202/2.5, 202/2.5) image:@"reloadProgress_center"];
        [self addSubview:progressBgImageView];
        progressImageView =[UIImageView funj_getImageView:CGRectMake((progressBgImageView.frame.size.width-188/2.5)/2, (progressBgImageView.frame.size.height-188/2.5)/2, 188/2.5, 188/2.5) image:@"reloadProgress_route"];
        [progressBgImageView addSubview:progressImageView];
        self.tag = NSNotFound-1;

        UITapGestureRecognizer *tapGest =[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(funj_stopProgressAnimate)];
        [self addGestureRecognizer:tapGest];
    }
    return self;
}

-(UILabel*)m_titleLabel{
    if(!_m_titleLabel){
        _m_titleLabel =[UILabel funj_getLabel:CGRectMake(0, 0, 0, 30) :JTextFCMakeAlign(PUBLIC_FONT_SIZE17, COLOR_TEXT_BLACK, NSTextAlignmentCenter)];
        [self addSubview:_m_titleLabel];
    }
    return _m_titleLabel;
}
-(void)funj_addProgressAnimate{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0.3f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.duration = 1.0f;
    [progressBgImageView.layer addAnimation:anima forKey:@"opacityAniamtion"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.6;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [progressImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)funj_stopProgressAnimate{
    [progressBgImageView.layer removeAllAnimations];
    [progressImageView.layer removeAllAnimations];
    [self removeFromSuperview];
}
-(void)funj_showProgressView{
    UIView *supView =[JAppViewTools funj_getKeyWindow];
    UIView *upProgressView =[supView viewWithTag:NSNotFound -1];
    if([upProgressView isKindOfClass:[JProgressHUD class]]){
        [(JProgressHUD*)upProgressView funj_stopProgressAnimate];
    }
    self.frame = CGRectMake(0,0,KWidth,KHeight);
    progressBgImageView.frame = CGRectMake((KWidth-202/2.5)/2, (KHeight-202/2.5)/2, 202/2.5, 202/2.5);
    [supView addSubview:self];
    [self funj_addProgressAnimate];
}
-(void)funj_showProgressView:(NSString*)title{
    UIView *supView =[JAppViewTools funj_getKeyWindow];
    UIView *upProgressView =[supView viewWithTag:NSNotFound -1];
    if([upProgressView isKindOfClass:[JProgressHUD class]]){
        [(JProgressHUD*)upProgressView funj_stopProgressAnimate];
    }
    self.frame = CGRectMake(0,0,KWidth,KHeight);
    progressBgImageView.frame = CGRectMake((KWidth-202/2.5)/2, (KHeight-202/2.5)/2, 202/2.5, 202/2.5);
    self.m_titleLabel.frame = CGRectMake(progressBgImageView.frame.origin.x-20, progressBgImageView.frame.size.height+progressBgImageView.frame.origin.y, progressBgImageView.frame.size.width+40, 30);
    self.m_titleLabel.text = title;
    [supView addSubview:self];
    [self funj_addProgressAnimate];
}

@end

static JMProgressHUD *mprogressHUD =nil;

@interface JMProgressHUD()
@property(nonatomic,assign)MprogressType m_progressType;
@property(nonatomic,assign)CGFloat m_time;

@property(nonatomic,weak)UIView* m_superView;
@property(nonatomic,strong)UILabel* m_titleLabel;
@property(nonatomic,strong)NSTimer *m_timer;
@property(nonatomic,strong)UIActivityIndicatorView *m_activityView;
@property(nonatomic,strong)UIImageView *m_blackAlphaView;
@property(nonatomic,copy)completeCallback m_callback;
@property(nonatomic,assign)BOOL m_isHasFinishCallback;

@end
@implementation JMProgressHUD
+(id)share{
    if(!mprogressHUD){
        mprogressHUD=[[JMProgressHUD alloc]init];
        mprogressHUD.backgroundColor = COLOR_CREAR;
        [mprogressHUD funj_addblackView];
    }
    return mprogressHUD;
}
-(id)initWithView:(UIView*)superView t:(MprogressType)type{
    if(self =[super initWithFrame:CGRectZero]){
        [self funj_reloadSuperView:superView t:type];
        self.backgroundColor = COLOR_CREAR;
        [self funj_addblackView];
    }
    return self;
}
-(void)funj_addblackView{
    _m_blackAlphaView =[UIImageView funj_getBlackAlphaView:CGRectZero];
    [self addSubview:_m_blackAlphaView];
    [_m_blackAlphaView funj_setViewCornerLayer:JFilletMake(1, 10, COLOR_CREAR)];
}
-(void)funj_reloadSuperView:(UIView*)superView t:(MprogressType)type{
    _m_progressType = type;
    _m_superView = superView;
}
-(UILabel*)m_titleLabel{
    if(!_m_titleLabel){
        _m_titleLabel =[UILabel funj_getLabel:CGRectZero :JTextFCMakeAlign(PUBLIC_FONT_SIZE15, COLOR_WHITE,NSTextAlignmentCenter)];
        [self addSubview:_m_titleLabel];
        _m_titleLabel.numberOfLines = 2;
    }
    return  _m_titleLabel;
}
-(NSTimer*)m_timer{
    if(!_m_timer){
        _m_timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self  selector:@selector(funj_stopProgressAnimate) userInfo:nil repeats:YES];
    }
    return _m_timer;
}
-(UIActivityIndicatorView*)m_activityView{
    if(!_m_activityView){
        _m_activityView=[[ UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_m_activityView];
    }
    return _m_activityView;
}

-(void)funj_showProgressViews:(NSString*)title{
    [self funj_showProgressViews:title t:2 complete:nil];
}
-(void)funj_showProgressViews:(NSString*)title t:(CGFloat)time complete:(completeCallback)complete{
    [self funj_stopProgressAnimate];
    [self.m_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    if(self.m_progressType == kprogressType){
        if(title && title.length>0){
            self.frame = CGRectMake((self.m_superView.width-200)/2, (self.m_superView.height-140)/2, 200, 140);
            self.m_activityView.top = 30;
        }else{
            self.frame = CGRectMake((self.m_superView.width-100)/2, (self.m_superView.height-100)/2, 100, 100);
            self.m_activityView.top = (self.height-self.m_activityView.height)/2;
        }
        [self.m_activityView startAnimating];
        self.m_activityView.left = (self.width-self.m_activityView.width)/2;
    }
    self.m_titleLabel.hidden = YES;
    if(title && title.length>0){
        self.m_titleLabel.hidden = NO;
        [self.m_titleLabel funj_updateAttributedText:title];
        CGFloat top = 0;
        if(self.m_progressType== kprogressType){
            top = _m_activityView.bottom;
        }else{
            CGFloat width =[JAppUtility funj_getTextWidthWithView:self.m_titleLabel]+40;
            if(IS_IPAD){
                width = MIN(KWidth/3*2, width);
            }else{
                width = KWidth>KHeight ? MIN(KWidth/3*2, width) : MIN(KWidth-60,width);
            }
            self.frame = CGRectMake((self.m_superView.width-width)/2, (self.m_superView.height-70)/2, width, 70);
        }
        self.m_titleLabel.frame = CGRectMake(20, top, self.width-40, self.height-top);
    }
    self.m_time = time;
    self.m_blackAlphaView.frame = self.bounds;
    [self.m_superView addSubview:self];
    self.m_isHasFinishCallback = YES;
    self.m_callback = complete;
}
-(void)funj_stopProgressAnimate{
    if(_m_activityView.animating)[_m_activityView stopAnimating];
    if(self.m_timer.isValid)[self.m_timer setFireDate:[NSDate distantFuture]];
    [self removeFromSuperview];
    if(self.m_callback && self.m_isHasFinishCallback){
        self.m_isHasFinishCallback = NO;
        self.m_callback();
    }
    self.m_callback = nil;
}
-(void)dealloc{
    if(self.m_timer.isValid) [self.m_timer invalidate];
}

@end
