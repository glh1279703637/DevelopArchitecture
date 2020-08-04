//
//  JSegmentedControl.m
//  GuideApp
//
//  Created by Jeffrey on 15/7/28.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JSegmentedControl.h"
#import "JAppViewExtend.h"

@implementation JSegmentedControl{
    UIImageView *selectBgForBt;
    NSArray *titleArray;
    selectBt m_action;
    
    NSArray *_textColorArray;
    
    SegmentType m_type;
}
-(id)initWithFrame:(CGRect)frame :(NSArray*)titles :(selectBt)action{
    if(self = [super initWithFrame:frame]){
        titleArray=titles;
        m_action=action;
    }
    return self;
}
-(void)funj_setStyleBgView:(NSArray*)bgImageArray textColor:(NSArray*)textColorArray type:(SegmentType)type{
    _textColorArray = textColorArray;
    m_type = type;
    if(bgImageArray.count>0){
        if(!_m_bgImageView){
            _m_bgImageView=[UIImageView funj_getImageView:self.bounds image:nil];
            [self setBgViewStyle:_m_bgImageView];
            _m_bgImageView.userInteractionEnabled=YES;
            [self addSubview:_m_bgImageView];
        }
        if([bgImageArray[0] isKindOfClass:[NSString class]]){
            _m_bgImageView.alpha=0.5;
            _m_bgImageView.image =[UIImage imageNamed:bgImageArray[0]];
        }else{
            _m_bgImageView.backgroundColor = bgImageArray[0];
            
        }
    }
    
    if(bgImageArray.count>1){
        if(!selectBgForBt){
            selectBgForBt=[UIImageView funj_getImageView:CGRectMake(1, 1, self.width/[titleArray count]-2, self.height-2) image:nil];
            [self addSubview:selectBgForBt];
            [self setBgViewStyle:selectBgForBt];
        }
        if([bgImageArray[1] isKindOfClass:[NSString class]]){
            selectBgForBt.image =[UIImage imageNamed:bgImageArray[1]];
        }else{
            selectBgForBt.backgroundColor = bgImageArray[1];
        }
    }
    
    [self addSegBgView];
}
-(void)setBgViewStyle:(UIView*)view {
    int cornerArr[4] = {0,5,view.height/2,0};
    if(m_type == kSegmentTypeBottomLine && [view isEqual:selectBgForBt]){
        view.top = view.bottom;
        view.height = 1;
    }else{
        view.layer.cornerRadius=cornerArr[m_type];
        view.layer.masksToBounds = YES;
    }
    
}

-(void)addSegBgView{
    for(int i=0;i<titleArray.count;i++){
        UIButton *itemBt =[UIButton funj_getButton:CGRectMake(self.width/[titleArray count]*i, 0, self.width/[titleArray count], self.height) :titleArray[i] :JTextFCMaked(PUBLIC_FONT_SIZE17,_textColorArray[0],_textColorArray[1]) :nil :self  :@"funj_selectItemTo:" :i+30];
        [self addSubview:itemBt];
        
        [itemBt.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [itemBt funj_updateButtonSelectStyle:NO  :NO];
    }
    [self funj_setSegmentSelectedIndex:0];
    
}
-(void)funj_selectItemTo:(UIButton*)sender{
    for(int i=0;i<4;i++){
        UIButton*but =[self viewWithTag:i+30];
        but.selected = NO;
    }
    sender.selected = YES;
    if(self->m_type == kSegmentTypeBottomLine){
        self->selectBgForBt.width =[JAppUtility funj_getTextWidthWithView:sender] ;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self->selectBgForBt.center = CGPointMake(sender.center.x, self->selectBgForBt.center.y);
    } completion:^(BOOL finished) {
        
        if(self->m_action)self->m_action(sender.tag-30);
    }];
    
}
-(void)funj_setSegmentSelectedIndex:(NSInteger)index{
    index = index % 4;
    for(UIButton*button in self.subviews){
        if([button isKindOfClass:[UIButton class]]){
            button.selected = index+30 == button.tag;
            if(self->m_type == kSegmentTypeBottomLine ){
                self->selectBgForBt.width =[JAppUtility funj_getTextWidthWithView:button] ;
            }
            if(button.selected){
                self->selectBgForBt.center = CGPointMake(button.center.x, self->selectBgForBt.center.y);
            }
        }
    }
}

@end
