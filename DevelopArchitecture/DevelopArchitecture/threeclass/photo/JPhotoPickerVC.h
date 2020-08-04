//
//  JPhotoPickerVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseCollectionVC.h"
#import "JPhotoPickerInterface.h"
NS_ASSUME_NONNULL_BEGIN

@interface JPhotoPickerVC : JBaseCollectionVC
@property(nonatomic,strong)JPhotosDataModel*m_dataModel;
@end

NS_ASSUME_NONNULL_END
