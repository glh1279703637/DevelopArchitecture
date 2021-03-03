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
        size.width = MIN(size.width, kWidth-20);
        size.height = MIN(size.height, kHeight-kStatusBarHeight-30);
        controller.m_BgViews.frame = CGRectMake((kWidth-size.width)/2, (kHeight-size.height)/2, size.width, size.height);
        controller.m_BgViews.layer.borderWidth=0;
        controller.m_BgViews.layer.cornerRadius=10;
        controller.m_BgViews.layer.masksToBounds=YES;
        controller.m_BgViews.accessibilityFrame = controller.m_BgViews.frame;
    }
 
    [sourcePresent  presentViewController:controller animated:YES completion:nil];//弹出视图
    
    return controller;
    
}
-(UIView*)m_BgViews{
    if(!_m_BgViews){
        _m_BgViews =[UIView funj_getView:CGRectMake(0,0,kWidth,kHeight) :kColor_White_Dark];
        [_m_BgViews funj_whenTouchedDown:^(UIView *sender) {
            [sender endEditing:YES];
        }];
    }
    return _m_BgViews;
}
-(void)funj_reloadBgViewFrames:(CGSize)size{
    CGRect frame = CGRectMake((kWidth-size.width)/2, (kHeight-size.height)/2, size.width, size.height);
    CGFloat addHeight = size.height- CGRectGetHeight(self.m_BgViews.accessibilityFrame)   ;
    CGFloat addWidth = size.width- CGRectGetWidth(self.m_BgViews.accessibilityFrame) ;
    CGRect frame2 = CGRectMake(CGRectGetMinX(self.m_BgContentView.accessibilityFrame)- addWidth/2, self.m_BgContentView.top, CGRectGetWidth(self.m_BgContentView.accessibilityFrame)+addWidth, CGRectGetHeight(self.m_BgContentView.accessibilityFrame)+addHeight);

    if(!m_currentIsUpState){
         self.m_BgViews.frame = frame;
        self.m_BgContentView.frame = frame2;
    }
    self.m_BgViews.accessibilityFrame =  frame;
    self.m_BgContentView.accessibilityFrame = frame2;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_Clear;
    
    UIImageView *bgImageView =[UIImageView funj_getBlackAlphaView:CGRectMake(0, 0, kWidth, kHeight)];
     [self.view addSubview:bgImageView];
    
    [self.view addSubview:self.m_BgViews];

    _m_titleLabel =[UILabel funj_getLabel:CGRectMake(0, 0, 0, 40)  :JTextFCMakeAlign(kFont_Size17,kColor_Text_Black_Dark,NSTextAlignmentCenter)];
    [self.m_BgViews addSubview:_m_titleLabel];
    
    __weak typeof(self) weakSelf = self;
    _m_sumbitBt =[UIButton funj_getButtonBlocks:CGRectMake(0, 0, 80, 40) :nil :JTextFCMake(kFont_Size14, kColor_Text_Gray_Dark) : nil  :50 :nil  :^(UIButton *button) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf funj_clickBackButton:button];
    }];
    [self.m_BgViews addSubview:_m_sumbitBt];
    
    _m_Line =[UIImageView funj_getLineImageView:CGRectMake(0, _m_titleLabel.bottom, _m_titleLabel.width, 1)];
    [self.m_BgViews addSubview:_m_Line];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(funj_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
 }

-(void)funj_reloadTopNavView:(CGRect)titleframe :(CGRect)contentFrame/*top 必须是titleframe.bottom*/ :(NSString*)title  :(NSInteger)leftDelType :(NSString*)deleteStr :(NSString*)deleteImage{
    titleframe.size.width = MIN(self.m_BgViews.width, titleframe.size.width);
    contentFrame.size.width = MIN(contentFrame.size.width, self.m_BgViews.width);
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
    _m_titleLabel.font = self.m_currentShowVCModel == kCURRENTISPOPOVER ?kFont_Size17:kFont_BoldSize20;
    _m_titleLabel.textColor =self.m_currentShowVCModel == kCURRENTISPOPOVER ? kColor_Text_Black_Dark :kColor_White;
    _m_Line.top = _m_titleLabel.bottom;_m_Line.width = _m_titleLabel.width;
    
    if(!CGRectEqualToRect(contentFrame, CGRectZero)){
        self.m_BgContentView.frame = contentFrame;
        self.m_BgContentView.accessibilityFrame = contentFrame;
    }
    
    if(self.m_currentShowVCModel == kCURRENTISPRENTVIEW){
        self.m_titleLabel.top = kStatusBarHeight;
        _m_sumbitBt.top = kStatusBarHeight;
        [_m_sumbitBt setTitleColor:kColor_White forState:UIControlStateNormal];
        _m_Line.hidden = YES;
        [self topNavView];
    }

}
-(UIView*)topNavView{
    UIView *topNavView =[UIView funj_getView:CGRectMake(0, 0, kWidth, kNavigationBarBottom) :kColor_White_Dark];
    [self.m_BgViews insertSubview:topNavView belowSubview:_m_titleLabel];
    return topNavView;
}
-(UIScrollView*)m_BgContentView{
    if(!_m_BgContentView){
        _m_BgContentView =[UIScrollView funj_getScrollView:CGRectZero :self];
        _m_BgContentView.bounces= NO;
        [self.m_BgViews addSubview:_m_BgContentView];
//        [_m_BgContentView funj_whenTouchedDown:^(UIView *sender) {
//            [sender endEditing:YES];
//        }];
    }
    return _m_BgContentView;
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
         if(self.m_BgViews.top != CGRectGetMinY(self.m_BgViews.accessibilityFrame)){
             self.m_BgViews.frame = self.m_BgViews.accessibilityFrame;
         }
         self.m_BgContentView.contentOffset = CGPointMake(self.m_BgContentView.contentOffset.x, self.m_BgContentView.contentOffset.y-loginUpHeight);
        m_currentIsUpState = NO;
        self.m_BgContentView.frame = self.m_BgContentView.accessibilityFrame;
    }else{//上
        if(m_currentIsUpState) return;
        if(!self.m_currentDefaultPresentVC  && CGRectGetMinY(self.m_BgViews.accessibilityFrame) > kStatusBarHeight){
            self.m_BgViews.top = kStatusBarHeight;
            self.m_BgViews.height =MIN(CGRectGetMinY(toFrame)-self.m_BgViews.top, self.m_BgViews.height);
        }
        
        CGPoint point = [self.m_BgContentView convertPoint:self.m_currentSelectTextField.origin fromView:self.m_currentSelectTextField.superview];
 
        self.m_BgContentView.accessibilityFrame = self.m_BgContentView.frame;
        self.m_BgContentView.height = MIN(self.m_BgContentView.height, self.m_BgViews.height - self.m_BgContentView.top);
        
        if(self.m_BgContentView.contentSize.height - point.y - self.m_currentSelectTextField.height > self.m_BgContentView.height){
            loginUpHeight = point.y - fabs(self.m_BgContentView.contentOffset.y);
        }else{
            loginUpHeight = point.y - (self.m_BgContentView.height - ( self.m_BgContentView.contentSize.height - point.y )) + fabs(self.m_BgContentView.contentOffset.y) ;
            loginUpHeight = MIN(point.y-fabs(self.m_BgContentView.contentOffset.y), loginUpHeight);
        }
        loginUpHeight = loginUpHeight<0?0:loginUpHeight;
        self.m_BgContentView.contentOffset = CGPointMake(self.m_BgContentView.contentOffset.x, self.m_BgContentView.contentOffset.y+loginUpHeight);
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
