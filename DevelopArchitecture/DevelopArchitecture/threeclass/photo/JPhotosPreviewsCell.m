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
    UIScrollView *m_bgScrollView;
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
         [self addSubview:imageView];
        playButton =[UIButton funj_getButtons:self.bounds :nil  :JTextFCZero() :@[@"MMVideoPreviewPlay"] :self  :@"funj_selectToPlay:" :0 :nil];
         [self addSubview:playButton];
        [playButton funj_updateButtonSelectStyle:NO  :NO];
    }else{
        m_bgScrollView =[UIScrollView funj_getScrollView:self.bounds :nil];
        [self addSubview:m_bgScrollView];
        m_bgScrollView.bouncesZoom = YES;
        m_bgScrollView.maximumZoomScale = 2.5;
        m_bgScrollView.minimumZoomScale = 1.0;
        m_bgScrollView.multipleTouchEnabled = YES;
        m_bgScrollView.delegate = self;
        m_bgScrollView.scrollsToTop = NO;
        m_bgScrollView.showsHorizontalScrollIndicator = NO;
        m_bgScrollView.showsVerticalScrollIndicator = NO;
        m_bgScrollView.delaysContentTouches = NO;
        m_bgScrollView.canCancelContentTouches = YES;
        m_bgScrollView.alwaysBounceVertical = NO;
        [m_bgScrollView addSubview:imageView];
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
    [m_bgScrollView setZoomScale:1.0 animated:NO];
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
