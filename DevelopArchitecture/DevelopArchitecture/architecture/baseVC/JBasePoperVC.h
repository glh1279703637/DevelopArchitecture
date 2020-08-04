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
@property(nonatomic,strong) UIImageView *m_line;
@property(nonatomic,strong) UIScrollView *m_bgContentView;

@property(nonatomic,assign) BOOL m_isShouldDismissPopover;
@property(nonatomic,weak) UIView *m_currentSelectTextField;// 只是为了textfield 或者textviewb附值
@property(nonatomic,strong)UIView *m_bgViews; //弹出中心整个背影 包括（nav + line +  bgContentView)
-(void)funj_reloadBgViewFrames:(CGSize)size;


-(void)funj_reloadTopNavView:(CGRect)titleframe :(CGRect)contentFrame/*top 必须是titleframe.bottom*/ :(NSString*)title  :(NSInteger)leftDelType :(NSString*)deleteStr :(NSString*)deleteImage;

+(JBasePoperVC*)funj_getPopoverVCs:(NSString *)className :(UIViewController*)sourcePresent :(id)data :(CGSize)size :(setPopverBaseVC)callback;
@end
