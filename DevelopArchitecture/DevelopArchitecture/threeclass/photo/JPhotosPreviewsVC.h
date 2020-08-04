//
//  JPhotosPreviewsVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseCollectionVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^changeCallback)(NSArray*dataArr,BOOL isOrigal);
@interface JPhotosPreviewsVC : JBaseCollectionVC
@property(nonatomic,copy)changeCallback m_changeCallback;
@property(nonatomic,assign)NSInteger m_scrollIndex;
@property(nonatomic,strong)NSMutableArray*m_selectDataArr;
@end

NS_ASSUME_NONNULL_END
