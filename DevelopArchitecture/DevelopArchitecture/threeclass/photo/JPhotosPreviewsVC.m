//
//  JPhotosPreviewsVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JPhotosPreviewsVC.h"
#import "JPhotosPreviewsCell.h"
#import "JPhotoPickerInterface.h"
@interface JPhotosPreviewsVC ()<UICollectionViewDelegate>
@property(nonatomic,assign)BOOL m_isOrigalImage;

@end

@implementation JPhotosPreviewsVC
maddProperyValue(m_selectDataArr, NSMutableArray);

- (void)viewDidLoad {
    [super viewDidLoad];
    [JPhotoPickerInterface funj_addConfigSubView:self];
     [self.m_defaultImageView removeFromSuperview];
    UICollectionViewFlowLayout*flowfayout =(UICollectionViewFlowLayout*)self.m_collectionView.collectionViewLayout;
    flowfayout.minimumLineSpacing=0;
    flowfayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowfayout.minimumInteritemSpacing=0;
    self.m_collectionView.pagingEnabled = YES;
    [self.m_collectionView registerClass:[JPhotosPreviewsCell class] forCellWithReuseIdentifier:kCellIndentifier];
    [self funj_addSubBottomBgView];
    self.m_collectionView.alwaysBounceVertical = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.m_scrollIndex > 0 && self.m_scrollIndex <self.m_dataArray.count){
            [self.m_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self.m_collectionView];
    });
}
-(void)funj_addSubBottomBgView{
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem funj_getNavPublicButton:self  t:nil  a:@"funj_selectToAdd:" img:@"photo_def_photoPickerVc" set:^(UIButton *button) {
        [button setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        [button funj_updateButtonSelectStyle:NO  ischange:NO];
     }];
    
    UIView *bottomBgView =[UIView funj_getView:CGRectMake(0, self.view.height-50, self.view.width, 50) bg:kColor_White_Dark];
    [self.view addSubview:bottomBgView];bottomBgView.tag = 3023;
    
    UIImageView *line =[UIImageView funj_getLineImageView:CGRectMake(0, 0, kWidth, 1)];
    [bottomBgView addSubview:line];
    
    if(![JPhotosConfig share].m_currentIsVideo){
        UIButton *origareBt =[UIButton funj_getButtons:CGRectMake(0, 0, 100, 50) t:LocalStr(@"Original") fc:JTextFCMake(kFont_Size13, kColor_Text_Black_Dark) img:@[@"photo_original_def",@"photo_original_sel"] d:self  a:@"funj_selectItemTo:" tag:3024 set:^(UIButton *button) {
            [button funj_updateContentImageLayout:kLEFT_IMAGECONTENT a:JAlignMake(10, 10, 0)];
            [button funj_updateButtonSelectStyle:NO  ischange:NO];
        }];
        [bottomBgView addSubview:origareBt];
    }
    
    UIButton *sumBt =[UIButton funj_getButtons:CGRectMake(self.view.width-100, 0, 100, 50) t:LocalStr(@"Confirm") fc:JTextFCMake(kFont_Size13, kColor_Text_Black_Dark) img: nil d:self  a:@"funj_selectFinishTo:" tag:3025 set:^(UIButton *button) {
        [button funj_updateContentImageLayout:kRIGHT_CONTENTIMAGE a:JAlignMake(10, 0, 20)];
    }];
    [bottomBgView addSubview:sumBt];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return [self.m_dataArray count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     JPhotosPreviewsCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIndentifier forIndexPath:indexPath];
    self.m_defaultImageView.hidden = YES;
    if(self.m_scrollIndex == -1 || indexPath.row == self.m_scrollIndex){
        self.m_scrollIndex = -1;
        [cell funj_setBaseCollectionData:self.m_dataArray[indexPath.row] ];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    for(JPhotosPreviewsCell *cell in self.m_collectionView.visibleCells){
        [cell funj_stopAllPlayer];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath  {
    return CGSizeMake(collectionView.width,self.m_collectionView.height);
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return NO;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self funj_reloadBaseViewParameter:CGRectZero f:CGRectMake(0, 0, self.view.width, self.view.height-50) hidden:YES];
    UIView *bottomBgView =[self.view viewWithTag:3023];
    bottomBgView.top = self.view.height-50;
    bottomBgView.width = self.view.width;
    UIButton *sumBt =[bottomBgView viewWithTag:3025];
    sumBt.left = bottomBgView.width - 100;
}

-(void)funj_selectItemTo:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.m_isOrigalImage = sender.selected;
}

-(void)funj_selectFinishTo:(UIButton*)sender{
    if(self.m_selectDataArr.count<=0){
        if(self.m_selectDataArr.count >= [JPhotosConfig share].m_maxCountPhotos){
            return;
        }
        UIButton *sender =[self.navigationItem.rightBarButtonItem customView];
        [self funj_selectToAdd:sender];
        if(self.m_selectDataArr.count<=0)return;
    }

    __block NSMutableDictionary *saveImageDic =[[NSMutableDictionary alloc]init];
    [self funj_showProgressView:nil];
    LRWeakSelf(self);
    for(NSInteger i =0;i<self.m_selectDataArr.count;i++){
        JPhotoPickerModel*model =self.m_selectDataArr[i];
        if([JPhotosConfig share].m_currentIsVideo){
            [JPhotoPickerInterface funj_getVideoWithAsset:model.asset completion:^(AVPlayerItem * _Nullable item, NSDictionary * _Nullable dic) {
                LRStrongSelf(self);
                dispatch_main_async_safe(^{
                    [self funj_getDetailInfo:saveImageDic img:nil d:dic  isDegrad:YES item:item index:i];
                });
            }];
        }else{
            [JPhotoPickerInterface funj_getPhotoWithAsset:model.asset type:PHImageRequestOptionsDeliveryModeHighQualityFormat photoWidth:kWidth completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull dic, BOOL isDegraded) {
                LRStrongSelf(self);
                if (isDegraded) {
                    return;
                }
                dispatch_main_async_safe(^{
                    [self funj_getDetailInfo:saveImageDic img:image d:dic  isDegrad:isDegraded item:nil index:i];
                });
            }];
        }
    }
}
-(void)funj_getDetailInfo:(NSMutableDictionary*)saveImageDic img:(UIImage*)image d:(NSDictionary*)dic isDegrad:(BOOL) isDegraded item:(AVPlayerItem*)item index:(NSInteger)index{
    if([JPhotosConfig share].m_currentIsVideo){
        if(item)[saveImageDic setObject:item forKey:@(index)];
    }else{
        if(image)[saveImageDic setObject:image forKey:@(index)];
    }
    if(saveImageDic.count == self.m_selectDataArr.count){
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
-(void)funj_selectToAdd:(UIButton*)sender{
    sender.selected = !sender.selected;
    if(sender.selected && self.m_selectDataArr.count >= [JPhotosConfig share].m_maxCountPhotos){
        sender.selected = NO;
        sender.selected = NO;
        [JAppViewTools funj_showTextToast:self.view msg:[NSString stringWithFormat:LocalStr(@"You can only choose %zd photos"),[JPhotosConfig share].m_maxCountPhotos]];
        return ;
    }
    int index = (self.m_collectionView.contentOffset.x+10)/self.m_collectionView.width;
    if(index<self.m_dataArray.count){
        JPhotoPickerModel*model =self.m_dataArray[index];
        if(sender.selected){
            model.isSelected = YES;
            [self.m_selectDataArr addObject:model];
        }else{
            model.isSelected = NO;
            [self.m_selectDataArr removeObject:model];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x+10)/scrollView.width;
    UIButton *rightBt = [self.navigationItem.rightBarButtonItem  customView];
    rightBt.selected = NO;
    if(index<self.m_dataArray.count){
        JPhotoPickerModel*model =self.m_dataArray[index];
        if([self.m_selectDataArr containsObject:model]){
            rightBt.selected = model.isSelected;
        }
    }
 
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}
-(void)funj_clickBackButton:(UIButton *)sender{
     if(self.m_changeCallback)self.m_changeCallback(self.m_selectDataArr, self.m_isOrigalImage);
    [super funj_clickBackButton:sender];
}
@end
