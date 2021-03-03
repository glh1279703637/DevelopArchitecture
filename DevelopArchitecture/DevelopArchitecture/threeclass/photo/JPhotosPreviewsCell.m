//
//  JPhotosPreviewsCell.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JPhotosPreviewsCell.h"
#import "JPhotoPickerInterface.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation JPhotosPreviewsCell{
    UIScrollView *m_BgScrollView;
     UIImageView *imageView;
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    UIButton *playButton;
    
    JPhotoPickerModel*m_data;
}
-(void)funj_addBaseCollectionView{

    
    imageView =[UIImageView funj_getImageView:self.bounds image:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if([JPhotosConfig share].m_currentIsVideo){
         [self.contentView addSubview:imageView];
        playButton =[UIButton funj_getButtons:self.bounds :nil  :JTextFCZero() :@[@"MMVideoPreviewPlay"] :self  :@"funj_selectToPlay:" :0 :nil];
         [self.contentView addSubview:playButton];
        [playButton funj_updateButtonSelectStyle:NO  :NO];
    }else{
        m_BgScrollView =[UIScrollView funj_getScrollView:self.bounds :nil];
        [self.contentView addSubview:m_BgScrollView];
        m_BgScrollView.bouncesZoom = YES;
        m_BgScrollView.maximumZoomScale = 2.5;
        m_BgScrollView.minimumZoomScale = 1.0;
        m_BgScrollView.multipleTouchEnabled = YES;
        m_BgScrollView.delegate = self;
        m_BgScrollView.scrollsToTop = NO;
        m_BgScrollView.showsHorizontalScrollIndicator = NO;
        m_BgScrollView.showsVerticalScrollIndicator = NO;
        m_BgScrollView.delaysContentTouches = NO;
        m_BgScrollView.canCancelContentTouches = YES;
        m_BgScrollView.alwaysBounceVertical = NO;
        [m_BgScrollView addSubview:imageView];
    }

    
 
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat height = CGRectGetHeight(scrollView.frame);
    
    CGFloat offsetX = (width > scrollView.contentSize.width) ? (width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (height > scrollView.contentSize.height) ? (height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
-(void)funj_setBaseCollectionData:(JPhotoPickerModel*)data {
    m_data = data;
    [m_BgScrollView setZoomScale:1.0 animated:NO];
    LRWeakSelf(self);
    [JPhotoPickerInterface funj_getPhotoWithAsset:data.asset :PHImageRequestOptionsDeliveryModeOpportunistic photoWidth:imageView.width  completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        LRStrongSelf(self);
        self->imageView.image = photo;
    }];
    [self funj_stopAllPlayer];

}
-(void)funj_stopAllPlayer{
    if([JPhotosConfig share].m_currentIsVideo){
        [playerLayer removeFromSuperlayer];
        playerLayer = nil;
        [playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
        imageView.hidden = NO;
        [player pause];
        player = nil;
    }
}


#pragma mark video
-(void)funj_selectToPlay:(UIButton*)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        if(playerLayer){
            [player play];
        }else{
            LRWeakSelf(self);
            [JPhotoPickerInterface funj_getVideoWithAsset:m_data.asset completion:^(AVPlayerItem * _Nullable item, NSDictionary * _Nullable dic) {
                LRStrongSelf(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->player = [AVPlayer playerWithPlayerItem:item];
                    self->playerLayer = [AVPlayerLayer playerLayerWithPlayer:self->player];
                    self->playerLayer.frame = self.bounds;
                    [self.layer insertSublayer:self->playerLayer atIndex:0];
                    [self->player play];
                    
                    self->imageView.hidden = YES;
                    [sender setImage:nil  forState:UIControlStateNormal];
                });
            }];
        }
    }else{
        [self funj_stopAllPlayer];
    }

 }

@end
