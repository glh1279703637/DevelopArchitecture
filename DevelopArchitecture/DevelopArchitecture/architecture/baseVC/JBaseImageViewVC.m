//
//  JBaseImageViewVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/4/9.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JBaseImageViewVC.h"
#import "JMainPhotoPickerVC.h"
#import <Photos/Photos.h>

@interface JBaseImageViewVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate>

@end

@implementation JBaseImageViewVC
-(id)init{
    if(self=[super init]){
        self.m_currentIsLoadMultPhoto=NO;
        self.m_currentCanSelectMaxImageCount=10;
        self.m_cropFrame=  CGRectMake(0, (kHeight - kWidth)/2, kWidth, kWidth);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)funj_editPortraitImageView:(id )button {
    [self.view endEditing: YES];
    if(self.m_currentCanSelectMaxImageCount<=0){
        [JAppViewTools funj_showAlertBlock:self :@"Info" :LocalStr(@"The number of images has reached the maximum limit") :0 :nil];
        return ;
    }
    [JAppViewTools funj_showSheetBlock:self  :button :LocalStr(@"Choose photos") :@[LocalStr(@"Photo"),LocalStr(@"Select from album")] block:^(JBaseImageViewVC* strongSelf, NSInteger buttonIndex) {
        if (buttonIndex == 0) {// 拍照
            if ([strongSelf funj_isCameraAvailable] && [strongSelf funj_doesCameraSupportTakingPhotos]) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                    [JAppViewTools funj_showAlertBlock:strongSelf :nil :LocalStr(@"Please set APP to access your camera \nSettings> Privacy> Camera") :@[LocalStr(@"Confirm")] :^(JBaseImageViewVC* strongSelf, NSInteger index) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:url  options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
                        [strongSelf funj_clickBackButton:nil];
                    }];
                }else{
                    [strongSelf funj_recallSystemCameraOrPhotoLabrary:UIImagePickerControllerSourceTypeCamera];
                }
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([strongSelf funj_isPhotoLibraryAvailable]) {
                LRWeakSelf(strongSelf);
                [JMainPhotoPickerVC funj_getPopoverPhotoPickerVC:strongSelf  :^(JBaseViewController *vc, int *isPresentView) {
                    LRStrongSelf(strongSelf);
                    [(JMainPhotoPickerVC*)vc funj_reloadDefaultItems:NO  :strongSelf.m_currentIsLoadMultPhoto :strongSelf.m_currentCanSelectMaxImageCount];
                }];
            }
        }
        
    } ];
    
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)funj_recallSystemCameraOrPhotoLabrary:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = type;
    if(type == UIImagePickerControllerSourceTypeCamera && [self funj_isRearCameraAvailable]){
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    if(type == UIImagePickerControllerSourceTypePhotoLibrary){
        controller.modalPresentationStyle = UIModalPresentationPopover;//配置推送类型
        
        controller.preferredContentSize = CGSizeMake(self.view.width , self.view.height );//设置弹出视图大小必须好推送类型相
        UIPopoverPresentationController *pover = controller.popoverPresentationController;
        [pover setSourceRect:self.view.bounds];//弹出视图显示位置
        [pover setSourceView:self.view];//设置目标视图，这两个是必须设置的。
        [pover setPermittedArrowDirections:0];
        pover.delegate = self;
    }
    [self presentViewController:controller animated:YES completion:nil];//弹出视图
    
    
}

#pragma mark - 用户点击了取消
-(void)funj_selectPhotosFinishToCallback:(NSArray *)imageOrVideoArr t:(BOOL)isVideo{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(isVideo){
            CLog(@"---- %@",imageOrVideoArr);
        }else{
            if(!self.m_currentIsLoadMultPhoto && imageOrVideoArr && imageOrVideoArr.count>0){
                UIImage *portraitImg = [imageOrVideoArr firstObject];
                // 裁剪
                portraitImg = [self funj_imageByScalingToMaxSize:portraitImg];
                if (!portraitImg)  return ;
                VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:self.m_cropFrame limitScaleRatio:3.0];
                imgEditorVC.delegate = self;
                imgEditorVC.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
                [self presentViewController:imgEditorVC animated:YES completion:^{
                    // TO DO
                }];
            }else{
//                NSMutableArray *imageArray = [NSMutableArray array];
//                for (int i = 0; i < imageOrVideoArr.count; i++) {
//                    UIImage *temImage = imageOrVideoArr[i];
//                    NSData* data = [JAppUtility funj_compressImageWithMaxLength:temImage :-1];
//                    [imageArray addObject:[UIImage imageWithData:data]];
//                }
            }
        }
        
    });

}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // 裁剪
        if (!portraitImg)  return ;
        BOOL saveCurrentIsMult = self.m_currentIsLoadMultPhoto;
        self.m_currentIsLoadMultPhoto = NO;
        [self funj_selectPhotosFinishToCallback:@[portraitImg] t:NO];
         self.m_currentIsLoadMultPhoto = saveCurrentIsMult;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark camera utility
- (BOOL) funj_isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) funj_isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) funj_doesCameraSupportTakingPhotos {
    return [self funj_cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) funj_isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) funj_cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)funj_imageByScalingToMaxSize:(UIImage *)sourceImage {
    
    if (sourceImage.size.width < kWidth)
        return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = kHeight;
        btWidth = sourceImage.size.width * (kHeight / sourceImage.size.height);
    } else {
        btWidth = kWidth;
        btHeight = sourceImage.size.height * (kWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self funj_imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)funj_imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }  else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) CLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end

