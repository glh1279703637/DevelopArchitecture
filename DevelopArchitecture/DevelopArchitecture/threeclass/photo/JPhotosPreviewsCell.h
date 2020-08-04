//
//  JPhotosPreviewsCell.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPhotosPreviewsCell : JBaseCollectionViewCell<UIScrollViewDelegate> 
-(void)funj_setBaseCollectionData:(id)data ;
-(void)funj_stopAllPlayer;
@end

NS_ASSUME_NONNULL_END
