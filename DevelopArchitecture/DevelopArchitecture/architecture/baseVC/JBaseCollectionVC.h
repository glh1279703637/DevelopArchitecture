//
//  JBaseCollectionVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/10/24.
//  Copyright © 2015年 Jeffrey. All rights reserved.
//

#import "JBaseTableViewVC.h"
#import "JCollectionViewFlowLayout.h"
#import "JBaseCollectionViewCell.h"

typedef void (^reloadToCollectionSolveDataCallback)(BOOL isHead,NSInteger page);

@interface JBaseCollectionVC : JBaseTableViewVC<JSearchBarDelegate>
@property(nonatomic,strong)UICollectionView *m_collectionView;
-(void)funj_addCellCallbackHeight:(JBaseCollectionViewCell*)cell :(NSString*)idKey;
@end

#define kcreateCollectViewWithDelegate(delegateVC) ({ \
    JCollectionViewFlowLayout *flowfayout=[[JCollectionViewFlowLayout alloc]init]; \
    flowfayout.minimumLineSpacing=2; \
    flowfayout.minimumInteritemSpacing=0; \
                                           \
    UICollectionView * collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KWidth,KHeight) collectionViewLayout:flowfayout];\
    collectionView.showsHorizontalScrollIndicator=NO;\
    collectionView.showsVerticalScrollIndicator=NO;\
    collectionView.delegate=delegateVC;\
    collectionView.allowsSelection=YES;\
    collectionView.dataSource=delegateVC;\
                                       \
    collectionView.backgroundColor=[UIColor clearColor];\
    [collectionView registerClass:[JBaseCollectionViewCell class] forCellWithReuseIdentifier:kCellIndentifier];\
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headsection"];\
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footsection"];\
    collectionView.alwaysBounceVertical= YES; \
    if (@available(iOS 11.0, *)) {\
       collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
    }\
    (collectionView); \
})
///collectionView.alwaysBounceVertical= YES; 垂直方向遇到边框是否总是反弹
