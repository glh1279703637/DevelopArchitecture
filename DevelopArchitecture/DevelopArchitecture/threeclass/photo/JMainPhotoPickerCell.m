//
//  JMainPhotoPickerCell.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/4/1.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JMainPhotoPickerCell.h"
#import "JPhotoPickerInterface.h"
@implementation JMainPhotoPickerCell{
    UIImageView *headImageView;
    UILabel *titleLabel;
    JPhotosDataModel *m_dataModel;
}
-(void)funj_addBaseTableSubView{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    headImageView =[UIImageView funj_getImageView:CGRectMake(10, 10, (90+IS_IPAD*40), kImageViewHeight(90+IS_IPAD*40)) img:@""];
    headImageView.layer.masksToBounds = YES;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headImageView];
    titleLabel =[UILabel funj_getLabel:CGRectMake(headImageView.right+10, headImageView.top, kphotoPickerViewWidth-headImageView.right-40, headImageView.height) fc:JTextFCMake(kFont_Size15, kColor_Text_Black_Dark)];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *line =[UIImageView funj_getLineImageView:CGRectMake(headImageView.right+10, headImageView.bottom+9, kphotoPickerViewWidth-30-headImageView.right-10, 1)];
    [self.contentView addSubview:line];
}
-(void)funj_setBaseTableCellWithData:(JPhotosDataModel *)data{
    m_dataModel = data;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:data.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:kColor_Text_Black_Dark}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)", data.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    titleLabel.attributedText = nameString;
    LRWeakSelf(self);
    [JPhotoPickerInterface funj_getPhotoWithAsset:[m_dataModel.fetchResult lastObject] type:PHImageRequestOptionsDeliveryModeFastFormat photoWidth:80 completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull dic, BOOL isDegraded) {
        LRStrongSelf(self);
        self->headImageView.image = image;
    }];
    
    
}

@end

@implementation JPhotoPickerCell{
    UIImageView *coverImageView;
    UIButton *selectBt;
    UILabel *countLabel;
    UIButton*timeLabel;
    JPhotoPickerModel *m_dataModel;
}
-(void)funj_addBaseCollectionView{
    CGFloat width =  self.width;

    coverImageView =[UIImageView funj_getImageView:CGRectMake(0,0,width, kImageViewHeight(width)) img:@""];
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:coverImageView];
    coverImageView.layer.masksToBounds = YES;
    
    //VideoSendIcon
    if([JPhotosConfig share].m_currentIsVideo){
        timeLabel =[UIButton funj_getButtons:CGRectMake(30, coverImageView.height-20, coverImageView.width-40, 15) t:@"00:00"  fc:JTextFCMake(kFont_Size10, [UIColor grayColor]) img:@[@"VideoSendIcon"] d:nil  a:nil  tag:0 set:^(UIButton *button) {
            [button funj_updateContentImageLayout:kRIGHT_IMAGECONTENT a:JAlignMake(0, 10, 0)];
        }];
        [self.contentView addSubview:timeLabel];
    }
    
    selectBt =[UIButton funj_getButtons:CGRectMake(coverImageView.width-60, 0, 60, 60) t:nil  fc:JTextFCZero() img:@[@"photo_def_photoPickerVc",@"photo_sel_photoPickerVc"] d:self  a:@"funj_selectToAdd:" tag:0 set:nil];
    [self.contentView addSubview:selectBt];
    selectBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    selectBt.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [selectBt funj_updateButtonSelectStyle:NO  ischange:NO];
    
    if([JPhotosConfig share].m_isMultiplePhotos){
        countLabel =[UILabel funj_getOneLabel:CGRectMake(5, coverImageView.height-20, 15, 15) fc:JTextFCMakeAlign(kFont_Size10, kColor_White,NSTextAlignmentCenter)];
        [self.contentView addSubview:countLabel];
        [countLabel funj_setViewCornerLayer:JFilletMake(0, 15/2, kColor_Clear)];
        countLabel.backgroundColor = [UIColor redColor];
    }
}
-(void)funj_setBaseCollectionData:(JPhotoPickerModel *)data{
    m_dataModel = data;
    [timeLabel setTitle:data.timeLength forState:UIControlStateNormal];
    [timeLabel funj_updateContentImageLayout:kRIGHT_IMAGECONTENT a:JAlignMake(0, 10, 0)];
    countLabel.text = [NSString stringWithFormat:@"%zd",data.indexCount];
    selectBt.selected = data.isSelected;
    countLabel.hidden = data.indexCount <=0;
    LRWeakSelf(self);
    [JPhotoPickerInterface funj_getPhotoWithAsset:data.asset type:PHImageRequestOptionsDeliveryModeFastFormat photoWidth:coverImageView.width completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull dic, BOOL isDegraded) {
        LRStrongSelf(self);
        self->coverImageView.image = image;
    }];
    
}

-(void)funj_reloadCountIndex:(NSInteger)index{
    countLabel.text =[NSString stringWithFormat:@"%zd",index];
    countLabel.hidden = index <=0;
}
-(void)funj_selectToAdd:(UIButton*)sender{
    sender.selected = !sender.selected;
    m_dataModel.isSelected = sender.selected;
    if(self.m_selectItemCallback)self.m_selectItemCallback(sender,m_dataModel);
}
@end
