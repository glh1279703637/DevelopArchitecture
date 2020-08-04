//
//  JBaseCollectionViewCell.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/10/27.
//  Copyright © 2015年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAppViewExtend.h"
 #import "JWhenTappedView.h"
#import "JReloadImageView.h"
typedef void (^CollectionCallbackHeight)(NSString*idKey,CGFloat height);

@interface JBaseCollectionViewCell : UICollectionViewCell
@property(nonatomic,copy)CollectionCallbackHeight m_callbackHeight;

-(void)funj_addBaseCollectionView;
-(void)funj_setBaseCollectionData:(NSDictionary*)data;
@end
