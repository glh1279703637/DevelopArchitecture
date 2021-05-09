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
    
    NSArray *_TextColorArray;
    
    SegmentType m_type;
}
-(id)initWithFrame:(CGRect)frame t:(NSArray*)titles c:(selectBt)action{
    if(self = [super initWithFrame:frame]){
        titleArray=titles;
        m_action=action;
    }
    return self;
}
-(void)funj_setStyleBgView:(NSArray*)bgImageArray textColor:(NSArray*)textColorArray type:(SegmentType)type{
    _TextColorArray = textColorArray;
    m_type = type;
    if(bgImageArray.count>0){
        if(!_m_BgImageView){
            _m_BgImageView=[UIImageView funj_getImageView:self.bounds img:nil];
            [self setBgViewStyle:_m_BgImageView];
            _m_BgImageView.userInteractionEnabled=YES;
            [self addSubview:_m_BgImageView];
        }
        if([bgImageArray[0] isKindOfClass:[NSString class]]){
            _m_BgImageView.alpha=0.5;
            _m_BgImageView.image =[UIImage imageNamed:bgImageArray[0]];
        }else{
            _m_BgImageView.backgroundColor = bgImageArray[0];
            
        }
    }
    
    if(bgImageArray.count>1){
        if(!selectBgForBt){
            selectBgForBt=[UIImageView funj_getImageView:CGRectMake(1, 1, self.width/[titleArray count]-2, self.height-2) img:nil];
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
        UIButton *itemBt =[UIButton funj_getButton:CGRectMake(self.width/[titleArray count]*i, 0, self.width/[titleArray count], self.height) t:titleArray[i] fc:JTextFCMaked(kFont_Size17,_TextColorArray[0],_TextColorArray[1]) bg:nil d:self  a:@"funj_selectItemTo:" tag:i+30];
        [self addSubview:itemBt];
        
        [itemBt.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [itemBt funj_updateButtonSelectStyle:NO  ischange:NO];
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
            if(button.selected){
                if(self->m_type == kSegmentTypeBottomLine ){
                    self->selectBgForBt.width =[JAppUtility funj_getTextWidthWithView:button] ;
                }
                self->selectBgForBt.center = CGPointMake(button.center.x, self->selectBgForBt.center.y);
            }
        }
    }
}

@end
