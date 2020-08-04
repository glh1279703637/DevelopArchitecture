//
//  JQRScanCodeVC.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/5/31.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void  (^QRScanCallback)(NSString*string);
@interface JQRScanCodeVC : JBaseViewController

@property(nonatomic,copy)QRScanCallback m_qrCallback;

@end

NS_ASSUME_NONNULL_END
