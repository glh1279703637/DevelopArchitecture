//
//  JBaseCollectionViewCell.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/10/27.
//  Copyright © 2015年 Jeffrey. All rights reserved.
//

#import "JBaseCollectionViewCell.h"

@implementation JBaseCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.backgroundColor = COLOR_BG_DARK;
        [self funj_addBaseCollectionView];
    }
    return self;
}
-(void)funj_addBaseCollectionView{
//    self.contentView addSubview:
}
-(void)funj_setBaseCollectionData:(NSDictionary*)data{
    
}
@end
