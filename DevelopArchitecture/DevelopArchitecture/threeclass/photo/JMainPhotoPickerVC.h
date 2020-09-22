//
//  JMainPhotoPickerVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseTableViewVC.h"
#import "JMainPhotoPickerCell.h"
NS_ASSUME_NONNULL_BEGIN
@protocol JMainPhotoPickerVCDelegate  <NSObject>

// uiimage or  AVPlayerItem
-(void)funj_selectPhotosFinishToCallback:(NSArray*)imageOrVideoArr t:(BOOL)isVideo;

@end

@interface JMainPhotoPickerVC : JBaseTableViewVC
@property(nonatomic,weak)id<JMainPhotoPickerVCDelegate> m_delegate;
 +(void)funj_getPopoverPhotoPickerVC:(JBaseViewController*)controller :(setPopverBaseVC)callback;

-(void)funj_reloadDefaultItems:(BOOL)isVideo :(BOOL)isMulti :(NSInteger)maxPhotos;
@end

NS_ASSUME_NONNULL_END
