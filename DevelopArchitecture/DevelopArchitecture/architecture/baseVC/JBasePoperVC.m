//
//  JBasePoperVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2017/11/14.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "JBasePoperVC.h"

@interface JBasePoperVC (){
    CGFloat loginUpHeight ;
    
}
@property(nonatomic,assign)BOOL m_currentDefaultPresentVC;

@end

@implementation JBasePoperVC
@synthesize m_currentIsUpState;

+(JBasePoperVC*)funj_getPopoverVCs:(NSString *)className :(UIViewController*)sourcePresent :(id)data :(CGSize)size :(setPopverBaseVC)callback{
    NSAssert(sourcePresent, @"sourcePresent can't nil");
    if(![JHttpReqHelp funj_checkNetworkType])return nil;
    JBasePoperVC *controller=[[NSClassFromString(className) alloc]init];
    if([controller isKindOfClass:[JBasePoperVC class]]){
        [controller funj_setBaseControllerData:data];
        controller.m_currentShowVCModel=kCURRENTISPOPOVER;
    }
    int setPrentView = 0;
    if(callback)callback(controller,&setPrentView);
    controller.m_currentDefaultPresentVC = setPrentView;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
    controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    if(!setPrentView){
        size.width = MIN(size.width, KWidth-20);
        size.height = MIN(size.height, KHeight-KStatusBarHeight-30);
        controller.m_bgViews.frame = CGRectMake((KWidth-size.width)/2, (KHeight-size.height)/2, size.width, size.height);
        controller.m_bgViews.layer.borderWidth=0;
        controller.m_bgViews.layer.cornerRadius=10;
        controller.m_bgViews.layer.masksToBounds=YES;
        controller.m_bgViews.accessibilityFrame = controller.m_bgViews.frame;
    }
 
    [sourcePresent  presentViewController:controller animated:YES completion:nil];//弹出视图
    
    return controller;
    
}
-(UIView*)m_bgViews{
    if(!_m_bgViews){
        _m_bgViews =[UIView funj_getView:CGRectMake(0,0,KWidth,KHeight) :COLOR_WHITE_DARK];
        [_m_bgViews funj_whenTouchedDown:^(UIView *sender) {
            [sender endEditing:YES];
        }];
    }
    return _m_bgViews;
}
-(void)funj_reloadBgViewFrames:(CGSize)size{
    CGRect frame = CGRectMake((KWidth-size.width)/2, (KHeight-size.height)/2, size.width, size.height);
    CGFloat addHeight = size.height- CGRectGetHeight(self.m_bgViews.accessibilityFrame)   ;
    CGFloat addWidth = size.width- CGRectGetWidth(self.m_bgViews.accessibilityFrame) ;
    CGRect frame2 = CGRectMake(CGRectGetMinX(self.m_bgContentView.accessibilityFrame)- addWidth/2, self.m_bgContentView.top, CGRectGetWidth(self.m_bgContentView.accessibilityFrame)+addWidth, CGRectGetHeight(self.m_bgContentView.accessibilityFrame)+addHeight);

    if(!m_currentIsUpState){
         self.m_bgViews.frame = frame;
        self.m_bgContentView.frame = frame2;
    }
    self.m_bgViews.accessibilityFrame =  frame;
    self.m_bgContentView.accessibilityFrame = frame2;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_CREAR;
    
    UIImageView *bgImageView =[UIImageView funj_getBlackAlphaView:CGRectMake(0, 0, KWidth, KHeight)];
     [self.view addSubview:bgImageView];
    
    [self.view addSubview:self.m_bgViews];

    _m_titleLabel =[UILabel funj_getLabel:CGRectMake(0, 0, 0, 40)  :JTextFCMakeAlign(PUBLIC_FONT_SIZE17,COLOR_TEXT_BLACK_DARK,NSTextAlignmentCenter)];
    [self.m_bgViews addSubview:_m_titleLabel];
    
    __weak typeof(self) weakSelf = self;
    _m_sumbitBt =[UIButton funj_getButtonBlocks:CGRectMake(0, 0, 80, 40) :nil :JTextFCMake(PUBLIC_FONT_SIZE14, COLOR_TEXT_GRAY_DARK) : nil  :50 :nil  :^(UIButton *button) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf funj_clickBackButton:button];
    }];
    [self.m_bgViews addSubview:_m_sumbitBt];
    
    _m_line =[UIImageView funj_getLineImageView:CGRectMake(0, _m_titleLabel.bottom, _m_titleLabel.width, 1)];
    [self.m_bgViews addSubview:_m_line];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(funj_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
 }

-(void)funj_reloadTopNavView:(CGRect)titleframe :(CGRect)contentFrame/*top 必须是titleframe.bottom*/ :(NSString*)title  :(NSInteger)leftDelType :(NSString*)deleteStr :(NSString*)deleteImage{
    titleframe.size.width = MIN(self.m_bgViews.width, titleframe.size.width);
    contentFrame.size.width = MIN(contentFrame.size.width, self.m_bgViews.width);
    _m_titleLabel.frame = titleframe;
    _m_titleLabel.text = title;
    _m_sumbitBt.top = _m_titleLabel.top;
    if(leftDelType==0){
        _m_sumbitBt.left =0;
        _m_sumbitBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _m_sumbitBt.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _m_sumbitBt.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);

    }else{
        _m_sumbitBt.left =_m_titleLabel.width-_m_sumbitBt.width;
        _m_sumbitBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _m_sumbitBt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        _m_sumbitBt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    }
    if(deleteStr){
        [_m_sumbitBt setTitle:deleteStr forState:UIControlStateNormal];
    }
    if(!deleteStr && !deleteImage) deleteImage = @"coursecenter_delete_n";
    if(deleteImage)[_m_sumbitBt setImage:[UIImage imageNamed:deleteImage] forState:UIControlStateNormal];
    [_m_sumbitBt funj_addNormalDarkImage:@"ic_close_n"];
    _m_titleLabel.font = self.m_currentShowVCModel == kCURRENTISPOPOVER ?PUBLIC_FONT_SIZE17:PUBLIC_FONT_BOLDSIZE20;
    _m_titleLabel.textColor =self.m_currentShowVCModel == kCURRENTISPOPOVER ? COLOR_TEXT_BLACK_DARK :COLOR_WHITE;
    _m_line.top = _m_titleLabel.bottom;_m_line.width = _m_titleLabel.width;
    
    if(!CGRectEqualToRect(contentFrame, CGRectZero)){
        self.m_bgContentView.frame = contentFrame;
        self.m_bgContentView.accessibilityFrame = contentFrame;
    }
    
    if(self.m_currentShowVCModel == kCURRENTISPRENTVIEW){
        self.m_titleLabel.top = KStatusBarHeight;
        _m_sumbitBt.top = KStatusBarHeight;
        [_m_sumbitBt setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        _m_line.hidden = YES;
        [self topNavView];
    }

}
-(UIView*)topNavView{
    UIView *topNavView =[UIView funj_getView:CGRectMake(0, 0, KWidth, KNavigationBarBottom) :COLOR_WHITE_DARK];
    [self.m_bgViews insertSubview:topNavView belowSubview:_m_titleLabel];
    return topNavView;
}
-(UIScrollView*)m_bgContentView{
    if(!_m_bgContentView){
        _m_bgContentView =[UIScrollView funj_getScrollView:CGRectZero :self];
        _m_bgContentView.bounces= NO;
        [self.m_bgViews addSubview:_m_bgContentView];
//        [_m_bgContentView funj_whenTouchedDown:^(UIView *sender) {
//            [sender endEditing:YES];
//        }];
    }
    return _m_bgContentView;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.m_currentSelectTextField = textField;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.m_currentSelectTextField = textView;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
#pragma mark keyboard action
- (void)funj_keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)(void) = ^{
        [self funj_willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}
- (void)funj_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame{
     if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {//下
        if(!m_currentIsUpState) return;
         if(self.m_bgViews.top != CGRectGetMinY(self.m_bgViews.accessibilityFrame)){
             self.m_bgViews.frame = self.m_bgViews.accessibilityFrame;
         }
         self.m_bgContentView.contentOffset = CGPointMake(self.m_bgContentView.contentOffset.x, self.m_bgContentView.contentOffset.y-loginUpHeight);
        m_currentIsUpState = NO;
        self.m_bgContentView.frame = self.m_bgContentView.accessibilityFrame;
    }else{//上
        if(m_currentIsUpState) return;
        if(!self.m_currentDefaultPresentVC  && CGRectGetMinY(self.m_bgViews.accessibilityFrame) > KStatusBarHeight){
            self.m_bgViews.top = KStatusBarHeight;
            self.m_bgViews.height =MIN(CGRectGetMinY(toFrame)-self.m_bgViews.top, self.m_bgViews.height);
        }
        
        CGPoint point = [self.m_bgContentView convertPoint:self.m_currentSelectTextField.origin fromView:self.m_currentSelectTextField.superview];
 
        self.m_bgContentView.accessibilityFrame = self.m_bgContentView.frame;
        self.m_bgContentView.height = MIN(self.m_bgContentView.height, self.m_bgViews.height - self.m_bgContentView.top);
        
        if(self.m_bgContentView.contentSize.height - point.y - self.m_currentSelectTextField.height > self.m_bgContentView.height){
            loginUpHeight = point.y - fabs(self.m_bgContentView.contentOffset.y);
        }else{
            loginUpHeight = point.y - (self.m_bgContentView.height - ( self.m_bgContentView.contentSize.height - point.y )) + fabs(self.m_bgContentView.contentOffset.y) ;
            loginUpHeight = MIN(point.y-fabs(self.m_bgContentView.contentOffset.y), loginUpHeight);
        }
        loginUpHeight = loginUpHeight<0?0:loginUpHeight;
        self.m_bgContentView.contentOffset = CGPointMake(self.m_bgContentView.contentOffset.x, self.m_bgContentView.contentOffset.y+loginUpHeight);
        m_currentIsUpState = YES;
    }
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    [[JAppViewTools funj_getKeyWindow] endEditing:YES];
    return self.m_isShouldDismissPopover;
}
-(BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController API_AVAILABLE(ios(13.0)){
    [[JAppViewTools funj_getKeyWindow] endEditing:YES];
    return self.m_isShouldDismissPopover;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
