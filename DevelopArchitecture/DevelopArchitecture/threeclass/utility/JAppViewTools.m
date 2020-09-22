//
//  JAppViewTools.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/9/6.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JAppViewTools.h"
#import "JProgressHUD.h"
#import "JConstantHelp.h"
#import "JAppViewExtend.h"

@implementation JAppViewTools
FilletValue JFilletMake(CGFloat borderWidth,CGFloat cornerRadius,UIColor *borderColor){
    FilletValue fillect;
    fillect.borderWidth=borderWidth;
    fillect.cornerRadius=cornerRadius;
    fillect.borderColor=borderColor;
    return fillect;
}
TextFC JTextFCZero(){
    TextFC textfc;
    textfc.textColor=nil;
    textfc.textFont=nil;
    textfc.selectTextColor=nil;
    textfc.alignment = NSTextAlignmentLeft;
    return textfc;
}
TextFC JTextFCMake(UIFont *textFont,UIColor *textColor){
    TextFC textfc;
    textfc.textColor=textColor;
    textfc.textFont=textFont;
    textfc.selectTextColor=nil;
    textfc.alignment = NSTextAlignmentLeft;
    return textfc;
}
TextFC JTextFCMaked(UIFont *textFont,UIColor *textColor,UIColor *selectTextColor){
    TextFC textfc;
    textfc.textColor=textColor;
    textfc.textFont=textFont;
    textfc.selectTextColor=selectTextColor;
    textfc.alignment = NSTextAlignmentLeft;
    return textfc;
}
TextFC JTextFCMakeAlign(UIFont *textFont,UIColor *textColor,NSTextAlignment alignment){
    TextFC textfc;
    textfc.textColor=textColor;
    textfc.textFont=textFont;
    textfc.selectTextColor = nil;
    textfc.alignment = alignment;
    return textfc;
}



//提示信息显示后消失
+ (void)funj_showTextToast:(UIView *)containerview message:(NSString *)msgtxt{
    [self funj_showTextToast:containerview message:msgtxt complete:nil time:2];
}
+ (void)funj_showTextToast:(UIView *)containerview message:(NSString *)msgtxt complete:(void (^)(void))complete time:(CGFloat)time{
    JMProgressHUD *progressHUD =[JMProgressHUD share];
    [progressHUD funj_reloadSuperView:containerview t:kprogressType_OnlyText];
    [progressHUD funj_showProgressViews:msgtxt t:time complete:complete];
}

//显示只带有一个ok按钮的提示框
+ (void)funj_showAlertBlock:(id)delegate :(NSString *)msgtxt{
    [self funj_showAlertBlock:(id)delegate :nil :msgtxt :@[NSLocalizedString(@"Confirm",nil)] :nil ];
}
+ (void)funj_showAlertBlocks:(id)delegate :(NSString *)title :(NSString *)msgtxt :(alertBlockCallback)callback{
    [self funj_showAlertBlock:(id)delegate :title :msgtxt :@[NSLocalizedString(@"Cancel",nil),NSLocalizedString(@"Confirm",nil)] :callback ];
}
+ (UIAlertController*)funj_showAlertBlock:(id)delegate :(NSString *)title :(NSString *)msgtxt :(NSArray*)button :(alertBlockCallback)callback{
    title=title?title:NSLocalizedString(@"Info",nil);
    msgtxt=(!msgtxt || [msgtxt isKindOfClass:[NSNull class]]) ?@"":msgtxt;
    
    JAlertController *alertController=[JAlertController alertControllerWithTitle:title message:msgtxt preferredStyle:UIAlertControllerStyleAlert];
    LRWeakSelf(delegate);
    for(int i=0;i<[button count];i++){
        UIAlertAction *action =  [UIAlertAction actionWithTitle:button[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LRStrongSelf(delegate);
            if(callback)callback(delegate,i);
        }] ;
        if(button.count ==2){
            if(i == 0 )[action setValue:COLOR_TEXT_GRAY_DARK forKey:@"titleTextColor"];
            else [action setValue:COLOR_ORANGE forKey:@"titleTextColor"];
        }
        [alertController addAction:action];
    }
    if([delegate isKindOfClass:[UIViewController class]]){
        [(UIViewController*)delegate  presentViewController:alertController animated:YES completion:nil];
    }else{
          [[JAppViewTools funj_getTopViewcontroller] presentViewController:alertController animated:YES completion:nil];
    }
    return alertController;
}
+(void)funj_showSheetBlock:(id)target :(UIView*)sourceView :(NSString*)title :(NSArray *)buttonArr block:(alertBlockCallback)callback{
    UIAlertControllerStyle type = sourceView ? UIAlertControllerStyleActionSheet : (IS_IPAD ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet);
    JAlertController *alertController=[JAlertController alertControllerWithTitle:title message:nil preferredStyle:type];
    LRWeakSelf(target);
    for(int i=0;i<[buttonArr count];i++){
        [alertController addAction:[UIAlertAction actionWithTitle:buttonArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LRStrongSelf(target);
            if(callback)callback(target,i);
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil)   style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        LRStrongSelf(target);
        if(callback)callback(target,buttonArr.count);
    }]];
    
    if(sourceView && [sourceView isKindOfClass:[UIView class]]){
 
        alertController.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
        alertController.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-200, [UIScreen mainScreen].bounds.size.width-200);//设置弹出视图大小必须好推送类型相
        UIPopoverPresentationController *pover = alertController.popoverPresentationController;
        [pover setSourceRect:[sourceView bounds]];//弹出视图显示位置
        [pover setSourceView:sourceView];//设置目标视图，这两个是必须设置的。
     }
    if([target isKindOfClass:[UIViewController class]]){
        [(UIViewController*)target  presentViewController:alertController animated:YES completion:nil];
    }else{
         [[JAppViewTools funj_getTopViewcontroller]  presentViewController:alertController animated:YES completion:nil];
    }
}
+(UIViewController*)funj_getTopViewcontroller{
    UIViewController *showViewApplication = [UIApplication sharedApplication].delegate.window.rootViewController;
#if TARGET_OS_MACCATALYST
    for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){
        if(windowScene.activationState == UISceneActivationStateForegroundActive){
            UIWindow*window = windowScene.windows.firstObject;
            showViewApplication = window.rootViewController;
        }
    }
#else
    if (@available(iOS 13.0, *)) {
        for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){
            if(windowScene.activationState == UISceneActivationStateForegroundActive){
                UIWindow*window = windowScene.windows.firstObject;
                showViewApplication = window.rootViewController;
            }
        }
    }
#endif
    int countIndex = 0;
    while (showViewApplication.presentedViewController) {
        showViewApplication = showViewApplication.presentedViewController;
        if([showViewApplication isKindOfClass:[UINavigationController class]]){
            UINavigationController*nav  = (UINavigationController*)showViewApplication;
            if(nav.viewControllers.count>0) showViewApplication = [nav.viewControllers lastObject];
        }
        if(countIndex ++ > 6)break;
    }
    return showViewApplication;
}
+(UIView*)funj_getKeyWindow{
#if TARGET_OS_MACCATALYST
    for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){
        if(windowScene.activationState == UISceneActivationStateForegroundActive){
            return windowScene.windows.firstObject;
        }
    }
#else
    if (@available(iOS 13.0, *)) {
       for(UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes){
           if(windowScene.activationState == UISceneActivationStateForegroundActive){
               return windowScene.windows.firstObject;
           }
       }
    }
    return [UIApplication sharedApplication].keyWindow;
#endif
    return nil;
}
@end

/// JButton.h
@interface JButton()
@property(nonatomic,assign)CGFloat m_addProhibitActionTime; // 设置连续事件点击间隔时间 ，防止重复点击
@property(nonatomic,assign)BOOL m_addProhibitActionTimeIsEnable; // 设置连续事件点击 防止重复点击,YES:enable,NO:noenable
@property(nonatomic,strong)NSArray* m_saveBgImageOrColor;
@property(nonatomic,copy) clickCallBack m_clickBack;
@property(nonatomic,assign)BOOL m_isHasObserver, m_isCanAction;
@property(nonatomic,assign)NSTimeInterval m_upSelectTime;

@property(nonatomic,strong)UIImage *m_saveNormalDarkImage,*m_saveDarkImage;
@end
@implementation JButton

-(id)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        _m_isNeedSelectHightColor = YES;
        _m_isDefalutNeedToSelectChange = YES;
        _m_addProhibitActionTimeIsEnable = YES;
    }
    return self;
}

//修改button的样式 是否需要点击高亮 是否需要点击时selected变化
-(void)funj_updateButtonSelectStyle:(BOOL)isNeedSelectHightColor :(BOOL)isDefalutNeedToSelectChange{
    _m_isNeedSelectHightColor = isNeedSelectHightColor;
    _m_isDefalutNeedToSelectChange = isDefalutNeedToSelectChange;
}
-(void)setM_saveBgImageOrColor:(NSArray *)saveBgImage{
    if(saveBgImage && saveBgImage.count>0  && [saveBgImage[0] isKindOfClass:[UIColor class]] &&  [saveBgImage count]>=1){
        if(!self.m_isHasObserver) [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew |  NSKeyValueObservingOptionOld context:nil];
        self.m_isHasObserver=YES;
    }else{
        if(self.m_isHasObserver)[self removeObserver:self  forKeyPath:@"selected"];
        self.m_isHasObserver = NO;
    }
    
    _m_saveBgImageOrColor = saveBgImage;
}
-(void)funj_resetProhibitActionTime:(CGFloat)time e:(BOOL)enable{
    self.m_addProhibitActionTime = time;
    self.m_addProhibitActionTimeIsEnable = enable;
}
-(void)funj_setBlockToButton:(NSArray*)saveBgImageOrColor :(clickCallBack)block{
    self.m_clickBack=block;
    [self setM_saveBgImageOrColor:saveBgImageOrColor];
}
-(void)funj_addNormalDarkImage:(NSString*)image{
    self.m_saveNormalDarkImage = [self imageForState:UIControlStateNormal];
    self.m_saveDarkImage =[UIImage imageNamed:image];
    if(kcurrentUserInterfaceStyleModel == 2){
        [self setImage:self.m_saveDarkImage forState:UIControlStateNormal];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    self.m_isCanAction = [self isCanPerformSelector] ;
    if(!self.m_isCanAction)return;
    
    if(_m_isNeedSelectHightColor && self.m_saveBgImageOrColor && [self.m_saveBgImageOrColor count]>=1 && [self.m_saveBgImageOrColor[0] isKindOfClass:[UIColor class]] ){
        [JAppUtility funj_changeColorAnimationForView:self];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    if(!self.m_isCanAction)return;
    
    if(_m_isDefalutNeedToSelectChange){
        self.selected=!self.selected;
    }
    if(self.m_saveBgImageOrColor && [self.m_saveBgImageOrColor count]>=2  && [self.m_saveBgImageOrColor[0] isKindOfClass:[UIColor class]]){
        if(!self.selected){
            self.backgroundColor=self.m_saveBgImageOrColor[0];
        }else{
            self.backgroundColor=self.m_saveBgImageOrColor[1];
        }
    }
    if(self.m_clickBack){
        self.m_clickBack(self);
    }
    if(!self.m_addProhibitActionTimeIsEnable){
        self.enabled = NO;
        LRWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.m_addProhibitActionTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LRStrongSelf(self);
            self.enabled = YES;
        });
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"selected"] && object){
        if(self.m_saveBgImageOrColor && [self.m_saveBgImageOrColor count]>=2  && [self.m_saveBgImageOrColor[0] isKindOfClass:[UIColor class]]){
            if(!self.selected){
                self.backgroundColor=self.m_saveBgImageOrColor[0];
            }else{
                self.backgroundColor=self.m_saveBgImageOrColor[1];
            }
        }
    }
}
-(BOOL)isHighlighted{
    BOOL isHighlighted = [super isHighlighted];
    
    if(self.m_addProhibitActionTime <= 0) return isHighlighted;
    
    if(self.m_isCanAction){
        return isHighlighted;
    }
    return NO;
}
- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event{
    if(!self.m_isCanAction)return;
    
    [super sendAction:action to:target forEvent:event];
}
-(BOOL)isCanPerformSelector{
    if(self.m_addProhibitActionTime <= 0) return YES;
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    if(now - self.m_upSelectTime >= self.m_addProhibitActionTime ){
        self.m_upSelectTime = now;
        return YES;
    }
    return NO;
}
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if(!(self.m_saveDarkImage && self.m_saveNormalDarkImage))return;
    if(kcurrentUserInterfaceStyleModel == 2){
        [self setImage:self.m_saveDarkImage forState:UIControlStateNormal];
    }else{
        [self setImage:self.m_saveNormalDarkImage forState:UIControlStateNormal];
    }
}

-(void)dealloc{
    if(_m_isHasObserver){
        [self removeObserver:self forKeyPath:@"selected"];
    }
}
@end

//UIAlertController
@implementation JAlertController

- (BOOL)shouldAutorotate {
    return NO;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE_DARK;
    [self.view funj_setViewCornerRadius:15];
}
@end
@implementation JTextField
@end
@implementation JTextView
@end

// UISearchBar
@implementation JSearchBar
@synthesize m_searchIcon = _m_searchIcon;

-(id)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        _m_searchTF =[[UITextField alloc]initWithFrame:CGRectMake(2, 2, frame.size.width-4, frame.size.height-4)];
        [self addSubview:_m_searchTF];
        self.m_searchTF.delegate = self;
        self.m_searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.m_searchTF.placeholder = LocalStr(@"Enter search content");
        self.m_searchTF.returnKeyType = UIReturnKeySearch;
    }
    return self;
}

-(NSString*)m_searchIcon{
     if(!_m_searchIcon || _m_searchIcon.length<=0) return @"main_search_n";
     return _m_searchIcon;
}
-(void)setM_searchIcon:(NSString *)searchIcon{
    if(!searchIcon || searchIcon.length<=0)return;
    if(_m_searchTF){
        UIImageView *leftImage =(UIImageView*)[[_m_searchTF.leftView subviews]firstObject];
        leftImage.image =[UIImage imageNamed:searchIcon];
    }
    _m_searchIcon = searchIcon;
}
-(void)setM_cancelAlreadyShow:(BOOL)m_cancelAlreadyShow{
    _m_cancelAlreadyShow = m_cancelAlreadyShow;
    if(m_cancelAlreadyShow){
        self.m_cancelButton.hidden = NO;
        [self setNeedsLayout];
    }
}
-(void)setM_filletValue:(FilletValue)m_filletValue{
    self.m_searchTF.layer.cornerRadius = m_filletValue.cornerRadius;
    self.m_searchTF.layer.borderColor = m_filletValue.borderColor.CGColor;
    self.m_searchTF.layer.borderWidth = m_filletValue.borderWidth;
}
-(void)funj_reloadSearchState:(BOOL)needIcon :(BOOL)needCancel{
    if(needIcon){
        UIImageView *searchImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:self.m_searchIcon]];
        searchImage.frame = CGRectMake(0, 0, 30, 15);
        searchImage.contentMode = UIViewContentModeCenter;
        self.m_searchTF.leftViewMode = UITextFieldViewModeAlways;
        UIView*bgview =[UIView funj_getView:CGRectMake(0, 0, 30, 15) :COLOR_CREAR];
        [bgview addSubview:searchImage];
        self.m_searchTF.leftView = bgview;
    }
    if(needCancel){
        _m_cancelButton =[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 0, 60, self.frame.size.height)];
        [_m_cancelButton setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
        [_m_cancelButton setTitle:LocalStr(@"Cancel") forState:UIControlStateNormal];
        _m_cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_m_cancelButton addTarget:self action:NSSelectorFromString(@"funj_searchCancelButtonClicked:") forControlEvents:UIControlEventTouchUpInside];
        _m_cancelButton.backgroundColor = COLOR_WHITE_DARK;
        _m_cancelButton.hidden = YES;
        [self addSubview:_m_cancelButton];
    }
  }
-(void)funj_removeCancelButton{
    [_m_cancelButton removeFromSuperview];
    _m_searchTF.frame = CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4);
    _m_cancelButton = nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    BOOL  cancelBt = self.m_cancelButton && !self.m_cancelButton.hidden;
    CGFloat width = self.m_cancelButton.width * cancelBt;
    
    _m_searchTF.frame = CGRectMake(2, 2, self.frame.size.width-4-width, self.frame.size.height-4);
    _m_cancelButton.frame =CGRectMake(self.frame.size.width-self.m_cancelButton.width-2, 0, self.m_cancelButton.width, self.frame.size.height);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self changeCancelButton:YES];
     if(self.searchDelegate && [self.searchDelegate respondsToSelector:NSSelectorFromString(@"funj_searchShouldBeginEditing:")]){
      return  [self.searchDelegate funj_searchShouldBeginEditing:textField];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self changeCancelButton:YES];
    if(self.searchDelegate && [self.searchDelegate respondsToSelector:NSSelectorFromString(@"search:inRange:replacementString:")]){
        return  [self.searchDelegate funj_search:textField inRange:range replacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self changeCancelButton:NO];
    if(self.searchDelegate && [self.searchDelegate respondsToSelector:NSSelectorFromString(@"funj_searchReturnButtonClicked:")]){
       [self.searchDelegate funj_searchReturnButtonClicked:textField];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self changeCancelButton:NO];
    if(self.searchDelegate && [self.searchDelegate respondsToSelector:NSSelectorFromString(@"funj_searchDidEndEditing:")]){
        [self.searchDelegate funj_searchDidEndEditing:textField];
    }
}
-(void)funj_searchCancelButtonClicked:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:LocalStr(@"Cancel")]){
        self.m_searchTF.text = @"";
        [self changeCancelButton:NO];
    }
    if(self.searchDelegate && [self.searchDelegate respondsToSelector:NSSelectorFromString(@"funj_searchCancelButtonClicked:")]){
        [self.searchDelegate funj_searchCancelButtonClicked:self.m_searchTF];
    }
}
-(void)changeCancelButton:(BOOL)isShow{
    if(!isShow)[self endEditing:YES];
    if(!_m_cancelButton)return;
    self.m_cancelButton.hidden = self.m_cancelAlreadyShow?NO:!isShow;
    [UIView animateWithDuration:0.2 animations:^{
        self.m_searchTF.frame = CGRectMake(self.m_searchTF.frame.origin.x, self.m_searchTF.frame.origin.y, self.frame.size.width-(self.m_cancelButton.frame.size.width+4)*isShow , self.m_searchTF.frame.size.height);
     }];
}
@end

