//
//  JBaseNavigationVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/6/19.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,currentNavColor){
    kCURRENTISBLUENAV_TAG,
    kCURRENTISGRAYNAV_TAG,
    kCURRENTISWHITENAV_TAG
};

@interface JBaseNavigationVC : UINavigationController
@property(nonatomic,assign)currentNavColor m_currentNavColor;
@end
