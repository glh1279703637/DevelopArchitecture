//
//  JBasePoperVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2017/11/14.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "JBaseViewController.h"
/*
 *一般使用于还有textfield 等输入框 的时候。
 *主要是由于版本不同，使用原本的popervc 会导致输入框点中后位置 无法确定的问题。
 */



@interface JBasePoperVC : JBaseViewController
@property(nonatomic,assign)BOOL m_currentIsUpState;
@property(nonatomic,strong) UILabel *m_titleLabel;
@property(nonatomic,strong) UIButton *m_sumbitBt;
@property(nonatomic,strong) UIImageView *m_Line;
@property(nonatomic,strong) UIScrollView *m_BgContentView;

@property(nonatomic,assign) BOOL m_isShouldDismissPopover;
@property(nonatomic,weak) UIView *m_currentSelectTextField;// 只是为了textfield 或者textviewb附值
@property(nonatomic,strong)UIView *m_BgViews; //弹出中心整个背影 包括（nav + line +  bgContentView)
-(void)funj_reloadBgViewFrames:(CGSize)size;


-(void)funj_reloadTopNavView:(CGRect)titleframe f:(CGRect)contentFrame/*top 必须是titleframe.bottom*/ t:(NSString*)title  lType:(NSInteger)leftDelType dStr:(NSString*)deleteStr dImg:(NSString*)deleteImage;

+(JBasePoperVC*)funj_getPopoverVCs:(NSString *)className sourceVC:(UIViewController*)sourcePresent d:(id)data s:(CGSize)size set:(setPopverBaseVC)callback;
@end
