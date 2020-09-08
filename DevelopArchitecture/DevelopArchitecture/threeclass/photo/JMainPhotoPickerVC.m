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
@interface JMainPhotoPickerVC ()
@property(nonatomic,strong)UILabel* m_tipLabel;

@end

@implementation JMainPhotoPickerVC
+(void)funj_getPopoverPhotoPickerVC:(JBaseViewController*)controller :(setPopverBaseVC)callback{
    if(![JHttpReqHelp funj_checkNetworkType])return  ;
    JMainPhotoPickerVC *viewController=[[JMainPhotoPickerVC alloc]init];
    viewController.m_delegate = controller;
    JBaseNavigationVC *nav =[[JBaseNavigationVC alloc]initWithRootViewController:viewController];
    
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
     if (![JPhotoPickerInterface funj_authorizationStatusAuthorized]) {
         [NSTimer scheduledTimerWithTimeInterval:1 target:self  selector:@selector(funj_checkIsAuthorize:) userInfo:nil  repeats:YES];
         
         NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
         if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
          NSString *text = [NSString stringWithFormat:NSLocalizedString(@"In %@ \'Settings - privacy - photo \' option,  \r  please allow %@ to access your phone album", nil),[UIDevice currentDevice].model, appName];
         
         UILabel *contentLabel =[self.m_defaultImageView viewWithTag:9993];
         contentLabel.height = 50;
         contentLabel.text = text;
         [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { }];
     }else{
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

-(void)funj_checkIsAuthorize:(NSTimer*)timer{
    if([JPhotoPickerInterface funj_authorizationStatusAuthorized]){
        if([timer isValid]){
            [timer invalidate];timer = nil;
        }
        dispatch_main_async_safe(^{
            [self.m_defaultImageView removeFromSuperview];
            [self funj_getAllPhotosArray];
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
    contentLabel.width = self.view.width-20;
    contentLabel.left = -self.m_defaultImageView.left+10;
    
}
-(void)funj_reloadDefaultItems:(BOOL)isVideo :(BOOL)isMulti :(NSInteger)maxPhotos{
    [JPhotosConfig share].m_currentIsVideo = isVideo;
    [JPhotosConfig share].m_isMultiplePhotos = isMulti;
    [JPhotosConfig share].m_maxCountPhotos = isMulti?maxPhotos:1;
}
-(void)dealloc{
    [JPhotosConfig m_deallocPhotoConfig];
}
@end
