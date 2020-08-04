//
//  HBGuidePageViewController.h
//  UniversalMeeting
//
//  Created by hanbing on 14-11-11.
//  Copyright (c) 2014年 cmri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
@interface HBGuidePageViewController : UIViewController<EAIntroDelegate>
-(id)initWithLoadVC:(id)loadViewController;
@end
