//
//  JMainPhotoPickerVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JMainPhotoPickerVC.h"
#import "JPhotoPickerInterface.h"
#import "JPhotoPickerVC.h"
#import <PhotosUI/PhotosUI.h>
@interface JMainPhotoPickerVC ()<PHPhotoLibraryChangeObserver>
@property(nonatomic,strong)UILabel* m_tipLabel;
@property(nonatomic,strong)NSTimer *m_timer;
@end

@implementation JMainPhotoPickerVC
+(void)funj_getPopoverPhotoPickerVC:(JBaseViewController*)controller :(setPopverBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return  ;
    JMainPhotoPickerVC *viewController=[[JMainPhotoPickerVC alloc]init];
    viewController.m_delegate = controller;
    JBaseNavigationVC *nav =[[JBaseNavigationVC alloc]initWithRootViewController:viewController];
    nav.m_currentNavColor = kCURRENTISWHITENAV_TAG;
    
    int setPrentView = 0;
    if(callback)callback(viewController,&setPrentView);
    if(!setPrentView){
        [viewController funj_setPresentIsPoperView:nav :CGSizeMake(kphotoPickerViewWidth , kphotoPickerViewHeight) :nil];
        viewController.m_currentShowVCModel = kCURRENTISPOPOVER;
    }else{
        nav.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
        viewController.m_currentShowVCModel = kCURRENTISPRENTVIEW;
    }
    [controller presentViewController:nav animated:YES completion:nil];//弹出视图
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.m_tableView registerClass:[JMainPhotoPickerCell class] forCellReuseIdentifier:kCellIndentifier];
    [JPhotoPickerInterface funj_addConfigSubView:self];
    self.m_defaultImageView.userInteractionEnabled = YES;
    UILabel *contentLabel =[self.m_defaultImageView viewWithTag:9993];
    [contentLabel funj_whenTapped:^(UIView * _Nonnull sender) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url  options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
    }];
    PHAuthorizationStatus statusAuthorized = [JPhotoPickerInterface funj_authorizationStatusAuthorized];
     if (statusAuthorized != PHAuthorizationStatusAuthorized) {
         self.m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(funj_checkIsAuthorize:) userInfo:nil  repeats:YES];
         
         NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
         if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
         NSString *text = [NSString stringWithFormat:LocalStr(@"Please allow %@ to access all photos"), appName];
         
         NSInteger lo = [text rangeOfString:appName].location;
         NSMutableAttributedString *attri = [contentLabel funj_updateAttributedText:text];
         [attri addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:NSMakeRange(lo, appName.length)];
         contentLabel.attributedText = attri;
         if(statusAuthorized == PHAuthorizationStatusNotDetermined){
             self.m_tipLabel.hidden = NO;
         }
         if(statusAuthorized == 4/*PHAuthorizationStatusLimited*/){
             contentLabel.hidden = YES;
             LRWeakSelf(self);
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 LRStrongSelf(self);
                 if(self.m_dataArr.count <=0){
                     UILabel *contentLabel =[self.m_defaultImageView viewWithTag:9993];
                     contentLabel.hidden = NO;
                 }
             });
         }
         
         if (@available(iOS 14.0, *)) {
             [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {}];
         } else {
             [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {}];
         }
     }
     if(statusAuthorized == PHAuthorizationStatusAuthorized || statusAuthorized == 4/*PHAuthorizationStatusLimited*/){
         [self funj_getAllPhotosArray];
     }
    LRWeakSelf(self);
    [[JPhotosConfig share] setM_selectCallback:^(NSArray * _Nonnull imageArr,  BOOL isVideo) {
        LRStrongSelf(self);
        if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(funj_selectPhotosFinishToCallback:t:)]){
            [self.m_delegate funj_selectPhotosFinishToCallback:imageArr t:isVideo];
        }
    } ];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

-(void)funj_checkIsAuthorize:(NSTimer*)timer{
    PHAuthorizationStatus statusAuthorized = [JPhotoPickerInterface funj_authorizationStatusAuthorized];
    if(statusAuthorized == PHAuthorizationStatusAuthorized){
        if([timer isValid]){
            [timer invalidate];timer = nil;
        }
        LRWeakSelf(self);
        dispatch_main_async_safe(^{LRStrongSelf(self);
            [self.m_defaultImageView removeFromSuperview];
            [self funj_getAllPhotosArray];
            [self->_m_tipLabel removeFromSuperview];
            self->_m_tipLabel = nil;
        });
    }else if(statusAuthorized == PHAuthorizationStatusNotDetermined && _m_tipLabel){
        [JAppUtility funj_shakeAnimationForView:_m_tipLabel :CGSizeMake(0, 8)];
    }else{
        LRWeakSelf(self);
        dispatch_main_async_safe(^{LRStrongSelf(self);
            [self->_m_tipLabel removeFromSuperview];
            self->_m_tipLabel = nil;
        });
    }
}
-(void)funj_getAllPhotosArray{
    [self funj_showProgressView:nil];
    LRWeakSelf(self);
     [JPhotoPickerInterface funj_getAllAlbums:[JPhotosConfig share].m_currentIsVideo completion:^(NSArray<JPhotosDataModel *> * _Nonnull dataArr) {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             LRStrongSelf(self);
             [self funj_closeLoadingProgressView];
             [self.m_dataArr removeAllObjects];
             [self.m_dataArr addObjectsFromArray:dataArr];
             [self.m_tableView reloadData];
         });
     }];
}




#pragma mark - TableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return kImageViewHeight(90+IS_IPAD*40)+20;
}
//继承的此类的，要覆盖这个方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JMainPhotoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier];
    [cell funj_setBaseTableCellWithData:self.m_dataArr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JPhotosDataModel *model = self.m_dataArr[indexPath.row];
    [self funj_getPushCallbackVCWithController:@"JPhotoPickerVC" title:model.name :model.name  :^(JBaseViewController *vc) {
        JPhotoPickerVC *pickVC = (JPhotoPickerVC*)vc;
        pickVC.m_dataModel = model;
    }];
 }
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return NO;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self funj_reloadBaseViewParameter:CGRectZero :CGRectMake(0, 0, self.view.width, self.view.height-KFilletSubHeight) :YES];
    UILabel *contentLabel =[self.m_defaultImageView viewWithTag:9993];
    contentLabel.frame = CGRectMake(-self.m_defaultImageView.left+10, self.m_defaultImageView.height-40, self.view.width-20, 40);
    _m_tipLabel.top = self.view.height - 60;
    _m_tipLabel.left = (self.view.width - 200)/2;
}
-(void)funj_reloadDefaultItems:(BOOL)isVideo :(BOOL)isMulti :(NSInteger)maxPhotos{
    [JPhotosConfig share].m_currentIsVideo = isVideo;
    [JPhotosConfig share].m_isMultiplePhotos = isMulti;
    [JPhotosConfig share].m_maxCountPhotos = isMulti?maxPhotos:1;
}
-(UILabel *)m_tipLabel{
    if(!_m_tipLabel){
        _m_tipLabel =[UILabel funj_getLabel:CGRectMake(0, 0, 200, 30) :@"建议请优先选择所有照片" :JTextFCMakeAlign(PUBLIC_FONT_SIZE14, COLOR_ORANGE,NSTextAlignmentCenter)];
        [self.view addSubview:_m_tipLabel];
    }
    return _m_tipLabel;
}
-(void)funj_clickBackButton:(UIButton *)sender{
    if([self.m_timer isValid]){
        [self.m_timer invalidate];self.m_timer = nil;
    }
    [super funj_clickBackButton:sender];
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    LRWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LRStrongSelf(self);
        [self.m_dataArr removeAllObjects];
        [self funj_getAllPhotosArray];
    });
}
-(void)dealloc{
    [JPhotosConfig m_deallocPhotoConfig];
}
@end
