//
//  JBaseImageViewVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/4/9.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#if !TARGET_OS_MACCATALYST
#import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface JBaseImageViewVC : JBaseViewController
@property(nonatomic,assign)CGRect m_cropFrame;
@property(nonatomic,assign)BOOL m_currentIsLoadMultPhoto;//当前是否支持上传多张图片
@property(nonatomic,assign)NSInteger m_currentCanSelectMaxImageCount;//最多支持上传多少张图片

- (void)funj_editPortraitImageView:(id )button;

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;//上传单张图片并且裁剪图片的
//多张图片 或者 视频
-(void)funj_selectPhotosFinishToCallback:(NSArray *)imageOrVideoArr t:(BOOL)isVideo;

-(void)funj_recallSystemCameraOrPhotoLabrary:(UIImagePickerControllerSourceType)type;

@end

