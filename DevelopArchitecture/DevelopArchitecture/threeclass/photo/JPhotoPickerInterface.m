//
//  JPhotoPickerInterface.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JPhotoPickerInterface.h"
static JPhotosConfig *config = nil;
@implementation JPhotosConfig

maddShareValue(config, JPhotosConfig)

+(void)m_deallocPhotoConfig{
    config = nil;
}
@end

@implementation JPhotosDataModel

@end
@implementation JPhotoPickerModel
+ (instancetype)modelWithAsset:(PHAsset*)asset type:(BOOL)isVideo timeLength:(nullable NSString *)timeLength {
    JPhotoPickerModel *model = [[JPhotoPickerModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.currentIsVideo = isVideo;
    if(isVideo)model.timeLength = timeLength;
    return model;
}
@end
@implementation JPhotoPickerInterface
+(PHAuthorizationStatus)funj_authorizationStatusAuthorized{
    if (@available(iOS 14.0, *)) {
        return [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    } else {
        return [PHPhotoLibrary authorizationStatus];
    }
}
#pragma mark - 获得相册/相册数组
+ (void)funj_getAllAlbums:(BOOL)isGetVideo completion:(void (^)(NSArray<JPhotosDataModel *> *))completion {
    NSMutableArray *albumArr = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!isGetVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    else option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
         PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) {
            continue;
        }
        if (collection.assetCollectionSubtype == 1000000201 ||  collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue; //最近删除的
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            [albumArr insertObject:[self funj_modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [albumArr addObject:[self funj_modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    for (PHAssetCollection *collection in albums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) {
            continue;
        }
 
        [albumArr addObject:[self funj_modelWithResult:fetchResult name:collection.localizedTitle]];
    }
    if (completion && albumArr.count > 0) completion(albumArr);
}
+ (void)funj_getPhotoWithAsset:(PHAsset*)phAsset type:(PHImageRequestOptionsDeliveryMode)deliveryMode photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *image, NSDictionary *dic, BOOL isDegraded))completion {
 
    photoWidth = MIN(kphotoPickerViewWidth, photoWidth);
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat pixelWidth = photoWidth * multiple;
    pixelWidth = MIN(phAsset.pixelWidth, pixelWidth);
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    if(![JPhotosConfig share].m_currentIsVideo){
        option.synchronous = YES;
    }
    option.resizeMode = (deliveryMode == PHImageRequestOptionsDeliveryModeHighQualityFormat?PHImageRequestOptionsResizeModeExact:PHImageRequestOptionsResizeModeFast);
    option.deliveryMode = deliveryMode;
 
     [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = !( [[info objectForKey:PHImageCancelledKey] boolValue] || [info objectForKey:PHImageErrorKey]);
         if (downloadFinined && result && completion) {
            completion(result, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
         }else{
             CLog(@"---- -- photos cancel :%@",info);
         }
    }];
}
#pragma mark - Get Video
+ (void)funj_getVideoWithAsset:(PHAsset*)asset completion:(void (^)(AVPlayerItem * _Nullable, NSDictionary * _Nullable))completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        if (completion) {
            completion(playerItem, info);
        }
    }];
}
+ (void)funj_getPhotoBytesWithPhotoArray:(NSArray *)photoArray completion:(void (^)(NSString *totalBytes))completion {
    __block NSInteger dataLength = 0;
    [photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JPhotoPickerModel *model = photoArray[idx];
        [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!model.currentIsVideo) {
                dataLength += imageData.length;
            }
            if (idx >= photoArray.count - 1) {
                NSString *bytes = [self funj_getBytesFromDataLength:dataLength];
                if (completion) {
                    completion(bytes);
                }
            }
        }];
    }];
}


+ (NSString *)funj_getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM", dataLength / 1024 / 1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK", dataLength / 1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB", dataLength];
    }
    return bytes;
}







#pragma mark - Private Method
+ (JPhotosDataModel *)funj_modelWithResult:(PHFetchResult*)result name:(NSString *)name {
    JPhotosDataModel *model = [[JPhotosDataModel alloc] init];
    model.fetchResult = result;
    model.name = name;
    PHFetchResult *fetchResult = (PHFetchResult *)result;
    model.count = fetchResult.count;
    return model;
}
+(void)funj_addConfigSubView:(UIViewController*)vc{
    UIButton *backBt =[[vc.navigationItem.leftBarButtonItems firstObject] customView];
    [backBt setImage:[UIImage imageNamed:@"backBt2"] forState:UIControlStateNormal];
    [backBt funj_updateContentImageLayout:kLEFT_CONTENTIMAGE a:JAlignMake(0, 0, 0)];
}


@end
