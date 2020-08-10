//
//  JPhotoPickerVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JPhotoPickerVC.h"
#import "JMainPhotoPickerCell.h"
#import "JPhotosPreviewsVC.h"

@interface JPhotoPickerVC ()
@property(nonatomic,assign)BOOL m_isOrigalImage;
@end

@implementation JPhotoPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [JPhotoPickerInterface funj_addConfigSubView:self];
     UICollectionViewFlowLayout*flowfayout =(UICollectionViewFlowLayout*)self.m_collectionView.collectionViewLayout;
    flowfayout.minimumLineSpacing=5;
    flowfayout.minimumInteritemSpacing=5;
    [self.m_collectionView registerClass:[JPhotoPickerCell class] forCellWithReuseIdentifier:cellIndentifier];
    [self funj_sortResultImagesData];
    [self funj_addSubBottomBgView];
    
 }
-(void)funj_addSubBottomBgView{
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem funj_getNavPublicButton:nil title:@"" action:nil  image:nil  :^(UIButton *button) {
    }];
    
    UIView *bottomBgView =[UIView funj_getView:CGRectMake(0, self.view.height-50, self.view.width, 50) :COLOR_WHITE];
    [self.view addSubview:bottomBgView];bottomBgView.tag = 3023;
    
    UIImageView *line =[UIImageView funj_getLineImageView:CGRectMake(0, 0, KWidth, 1)];
    [bottomBgView addSubview:line];
    
    if(![JPhotosConfig share].m_currentIsVideo){
        UIButton *origareBt =[UIButton funj_getButtons:CGRectMake(0, 0, 100, 50) :LocalStr(@"Original") :JTextFCMake(PUBLIC_FONT_SIZE13, COLOR_TEXT_BLACK) :@[@"photo_original_def",@"photo_original_sel"] :self  :@"funj_selectItemTo:" :3024 :^(UIButton *button) {
            [button funj_updateContentImageLayout:kLEFT_IMAGECONTENT a:JAlignMake(10, 10, 0)];
            [button funj_updateButtonSelectStyle:NO  :NO];
        }];
        [bottomBgView addSubview:origareBt];
    }
    
    UIButton *sumBt =[UIButton funj_getButtons:CGRectMake(self.view.width-100, 0, 100, 50) :LocalStr(@"Confirm") :JTextFCMake(PUBLIC_FONT_SIZE13, COLOR_TEXT_BLACK) : nil :self  :@"funj_selectFinishTo:" :3025 :^(UIButton *button) {
        [button funj_updateContentImageLayout:kRIGHT_CONTENTIMAGE a:JAlignMake(10, 0, 20)];
    }];
    [bottomBgView addSubview:sumBt];
}
-(void)funj_sortResultImagesData{
    [self.m_dataModel.fetchResult enumerateObjectsUsingBlock:^(PHAsset*  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            int min = asset.duration / 60;
            int ss = asset.duration - min*60;
            NSString *timeLength=  [NSString stringWithFormat:@"%02d:%02d", min,ss];
            [self.m_dataArr addObject:[JPhotoPickerModel modelWithAsset:asset type:YES timeLength:timeLength]];
        } else if (asset.mediaType == PHAssetMediaTypeImage) {
            [self.m_dataArr addObject:[JPhotoPickerModel modelWithAsset:asset type:NO timeLength:nil]];
        }
    }];
    LRWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LRStrongSelf(self);
        CGFloat height = self.m_collectionView.contentSize.height - self.m_collectionView.height;
        if(height > 0){
            [self.m_collectionView setContentOffset:CGPointMake(0, height) animated:NO];
        }
    });
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     JPhotoPickerCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
     [cell funj_setBaseCollectionData:self.m_dataArr[indexPath.row]];
    LRWeakSelf(self);
    LRWeakSelf(cell);
    [cell setM_selectItemCallback:^(UIButton*sender, JPhotoPickerModel * _Nonnull model){
        LRStrongSelf(self);
        LRStrongSelf(cell);
        if(sender.isSelected){
            if(self.m_dataArray.count >= [JPhotosConfig share].m_maxCountPhotos){
                sender.selected = NO;
                model.isSelected = NO;
                [JAppViewTools funj_showTextToast:self.view message:[NSString stringWithFormat:LocalStr(@"You can only choose %zd photos"),[JPhotosConfig share].m_maxCountPhotos]];
                return ;
            }
            [self.m_dataArray addObject:model];
            model.indexCount = self.m_dataArray.count;
            [cell funj_reloadCountIndex:model.indexCount];
        }else{
            [self.m_dataArray removeObject:model];
            model.indexCount = 0;
            for(int i=0;i<self.m_dataArray.count;i++){
                JPhotoPickerModel*mo = self.m_dataArray[i];
                mo.indexCount = i +1;
            }
            [self.m_collectionView reloadData];
        }
        self.title = [NSString stringWithFormat:@"%@(%zd/%zd)",self.m_dataString,self.m_dataArray.count,[JPhotosConfig share].m_maxCountPhotos];
        [self funj_solverDataModelSize];
        UIView *bottomBgView =[self.view viewWithTag:3023];
        UIButton *sumBt =[bottomBgView viewWithTag:3025];
        sumBt.enabled = self.m_dataArray.count;
    }];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath  {
    CGFloat width = 0;
    if(IS_IPAD){
        width = (kphotoPickerViewWidth-5*5)/4;
    }else{
        width = (kphotoPickerViewWidth-4*5)/3;
    }
    return CGSizeMake(width, kImageViewHeight(width));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section  {
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    JPhotosPreviewsVC*vcs = (JPhotosPreviewsVC*)[self funj_getPushCallbackVCWithController:@"JPhotosPreviewsVC" title:self.m_dataString :self.m_dataArr :^(JBaseViewController *vc) {
        JPhotosPreviewsVC*vcs = (JPhotosPreviewsVC*)vc;
        vcs.m_scrollIndex = indexPath.row;
        [vcs.m_selectDataArr addObjectsFromArray:self.m_dataArray];
    }];
    LRWeakSelf(self);
    [vcs setM_changeCallback:^(NSArray * _Nonnull dataArr, BOOL isOrigal) {
        LRStrongSelf(self);
        self.m_isOrigalImage = isOrigal;
        UIView *bottomBgView =[self.view viewWithTag:3023];
        UIButton *origareBt =[bottomBgView viewWithTag:3024];
        origareBt.selected = isOrigal;
        [self.m_dataArray removeAllObjects];
        [self.m_dataArray addObjectsFromArray:dataArr];
        [self.m_collectionView reloadData];
    }];
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return NO;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self funj_reloadBaseViewParameter:CGRectZero :CGRectMake(0, 0, self.view.width, self.view.height-50-KFilletSubHeight) :YES];
    UIView *bottomBgView =[self.view viewWithTag:3023];
    bottomBgView.top = self.view.height-50-KFilletSubHeight;
    bottomBgView.width = self.view.width;
    UIButton *sumBt =[bottomBgView viewWithTag:3025];
    sumBt.left = bottomBgView.width - 100;
    
}


-(void)funj_solverDataModelSize{
    UIButton *countBt =[self.navigationItem.rightBarButtonItem  customView];
     if(self.m_dataArray.count<=0){
        [countBt setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    if(!self.m_isOrigalImage)return;
    [JPhotoPickerInterface funj_getPhotoBytesWithPhotoArray:self.m_dataArray completion:^(NSString * _Nonnull totalBytes) {
        [countBt setTitle:totalBytes forState:UIControlStateNormal];
    }];
}
-(void)funj_selectItemTo:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.m_isOrigalImage = sender.selected;
    if(sender.selected){
         [self funj_solverDataModelSize];
    }
}

-(void)funj_selectFinishTo:(UIButton*)sender{
    if(self.m_dataArray.count<=0)return;

    __block NSMutableDictionary *saveImageDic =[[NSMutableDictionary alloc]init];
    [self funj_showProgressView:nil];
    LRWeakSelf(self);
    for(NSInteger i =0;i<self.m_dataArray.count;i++){
        JPhotoPickerModel*model =self.m_dataArray[i];
        if([JPhotosConfig share].m_currentIsVideo){
            [JPhotoPickerInterface funj_getVideoWithAsset:model.asset completion:^(AVPlayerItem * _Nullable item, NSDictionary * _Nullable dic) {
                LRStrongSelf(self);
                dispatch_main_async_safe(^{
                    [self funj_getDetailInfo:saveImageDic :nil :dic  :YES :item :i];
                });
            }];
        }else{
            [JPhotoPickerInterface funj_getPhotoWithAsset:model.asset :PHImageRequestOptionsDeliveryModeHighQualityFormat  photoWidth:KWidth completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull dic, BOOL isDegraded) {
                LRStrongSelf(self);
                if (isDegraded) {
                    return;
                }
                dispatch_main_async_safe(^{
                    [self funj_getDetailInfo:saveImageDic :image :dic  :isDegraded :nil :i];
                });
            }];
        }
    }
}
-(void)funj_getDetailInfo:(NSMutableDictionary*)saveImageDic :(UIImage*)image :(NSDictionary*)dic :(BOOL) isDegraded :(AVPlayerItem*)item :(NSInteger)index{
    if([JPhotosConfig share].m_currentIsVideo){
        if(item)[saveImageDic setObject:item forKey:@(index)];
    }else{
        if(!self.m_isOrigalImage){
            //得到图片的data
            NSData* data = [JAppUtility funj_compressImageWithMaxLength:image :-1];
            image =[UIImage imageWithData:data];
        }
         if(image)[saveImageDic setObject:image forKey:@(index)];
    }
    if(saveImageDic.count == self.m_dataArray.count){
        [self funj_closeLoadingProgressView];
        NSMutableArray *saveArr =[[NSMutableArray alloc]init];
        for(int j=0;j<saveImageDic.count;j++){
            if([saveImageDic objectForKey:@(j)])
                [saveArr addObject:[saveImageDic objectForKey:@(j)]];
        }
        if([JPhotosConfig share].m_selectCallback){
            [JPhotosConfig share].m_selectCallback(saveArr, [JPhotosConfig share].m_currentIsVideo);
        }
        self.m_currentShowVCModel = kCURRENTISPRENTVIEW;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self funj_clickBackButton:nil];
    }
}
@end
