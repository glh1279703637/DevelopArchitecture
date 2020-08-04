//
//  JCollectionViewFlowLayout.m
//  test
//
//  Created by Jeffrey on 15/9/24.
//  Copyright © 2015年 Jeffrey. All rights reserved.
//

#import "JCollectionViewFlowLayout.h"

@implementation JCollectionViewFlowLayout
//-(CGSize)collectionViewContentSize
//{
//    float width = self.collectionView.frame.size.width *([self.collectionView numberOfItemsInSection:0 ]+1);
// 
//    float height= self.collectionView.frame.size.height;
//    CGSize  size = CGSizeMake(width, height);
//    return size;
//}

//#pragma mark - UICollectionViewLayout
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //3D代码
//    UICollectionViewLayoutAttributes* attributes = attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    attributes.frame=CGRectMake(indexPath.row*self.collectionView.frame.size.width/2, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
//    
//    
//    return attributes;
//}
//
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
//    if ([arr count] >0) {
//        return arr;
//    }
//    NSMutableArray* attributes = [NSMutableArray array];
//    for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:0 ]; i++) {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    }
//    return attributes;
//}

@end
