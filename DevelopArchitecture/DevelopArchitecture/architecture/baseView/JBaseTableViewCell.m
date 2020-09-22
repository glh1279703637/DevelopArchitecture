//
//  JBaseTableViewCell.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/7/16.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseTableViewCell.h"

@implementation JBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self funj_addBaseTableSubView];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_BG_DARK;
        [self funj_addBaseTableSubView];
    }
    return self;
}
-(void)funj_addBaseTableSubView{
    
}
-(void)funj_autoAdjustLabelPosition:(NSArray<UILabel*>*)labelArr s:(CGFloat)addInterval a:(CGFloat)addSub{
    CGFloat left = NSNotFound;
    CGFloat top = 0;
    for(int i=0;i<labelArr.count;i++){
        UILabel *label = labelArr[i];
        CGFloat width = [JAppUtility funj_getTextWidthWithView:label];
        if(width > 0){
            label.width  = width+addSub;label.layer.masksToBounds = NO;
        }else{
            label.width = 0;label.layer.masksToBounds = YES;
        }
        if(left != NSNotFound){
            label.left = left + addInterval;
            label.top = top;
        }else{
            top = label.top;
        }
        left = label.right;
    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(self.selectionStyle != UITableViewCellSelectionStyleNone){
        self.backgroundColor = (highlighted?COLOR_BG_LIGHTGRAY_DARK:COLOR_CREAR);
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(self.selectionStyle != UITableViewCellSelectionStyleNone){
        self.backgroundColor = (selected?COLOR_BG_LIGHTGRAY_DARK:COLOR_CREAR);
    }
}

-(void)funj_setBaseTableCellWithData:(NSDictionary*)data{
    
}

@end
