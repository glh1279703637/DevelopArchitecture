//
//  JPhotoPickerInterface.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseInterfaceManager.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

#define kphotoPickerViewWidth (IS_IPAD ? KWidth-40 : KWidth)
#define kphotoPickerViewHeight (KHeight-KNavigationBarHeight-30)

typedef void (^selectPhotoCallback)(NSArray*imageOrVideoArr,BOOL isVideo);
@interface JPhotosConfig :NSObject
@property(nonatomic,assign)BOOL m_currentIsVideo; //是视频，还是图片
@property(nonatomic,assign)BOOL m_isMultiplePhotos;//是否多选
@property(nonatomic,assign)NSInteger m_maxCountPhotos; //最大多选数
@property(nonatomic,copy)selectPhotoCallback m_selectCallback;
+(JPhotosConfig*)share;
+(void)m_deallocPhotoConfig;
@end

@interface JPhotosDataModel : NSObject

//相册名
@property (nonatomic, strong) NSString *name;

//照片个数
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) PHFetchResult *fetchResult;

@end

@interface JPhotoPickerModel : NSObject

@property (nonatomic, strong)  PHAsset* asset;             ///< PHAsset

@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No

@property (nonatomic, assign) BOOL currentIsVideo;

@property (nonatomic, copy) NSString *timeLength;

@property(nonatomic,assign)NSInteger indexCount;
//初始化照片模型
+ (instancetype)modelWithAsset:(PHAsset*)asset type:(BOOL)isVideo timeLength:(nullable NSString *)timeLength;

@end


@interface JPhotoPickerInterface : JBaseInterfaceManager
//返回YES如果得到了授权
+(BOOL)funj_authorizationStatusAuthorized;

//获得相册/相册数组
+ (void)funj_getAllAlbums:(BOOL)isGetVideo completion:(void (^)(NSArray<JPhotosDataModel *> *))completion;
//获得照片
+ (void)funj_getPhotoWithAsset:(PHAsset*)phAsset :(PHImageRequestOptionsDeliveryMode)deliveryMode photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *image, NSDictionary *dic, BOOL isDegraded))completion ;
+ (void)funj_getVideoWithAsset:(PHAsset*)asset completion:(void (^)(AVPlayerItem * _Nullable, NSDictionary * _Nullable))completion;

+ (void)funj_getPhotoBytesWithPhotoArray:(NSArray *)photoArray completion:(void (^)(NSString *totalBytes))completion;

+(void)funj_addConfigSubView:(UIViewController*)vc;
@end

NS_ASSUME_NONNULL_END
