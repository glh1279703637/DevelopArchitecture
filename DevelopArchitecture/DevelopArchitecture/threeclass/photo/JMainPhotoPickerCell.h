//
//  JMainPhotoPickerCell.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseTableViewCell.h"
#import "JBaseCollectionViewCell.h"
@class  JPhotoPickerModel;
typedef void (^selectPhotoItemCallback)(UIButton *sender ,JPhotoPickerModel*model);

NS_ASSUME_NONNULL_BEGIN

@interface JMainPhotoPickerCell : JBaseTableViewCell

@end
@interface JPhotoPickerCell : JBaseCollectionViewCell
@property(nonatomic,copy)selectPhotoItemCallback m_selectItemCallback;
-(void)funj_reloadCountIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
