//
//  HBGuidePageViewController.m
//  UniversalMeeting
//
//  Created by hanbing on 14-11-11.
//  Copyright (c) 2014年 cmri. All rights reserved.
//

#import "HBGuidePageViewController.h"
 @interface HBGuidePageViewController (){
    UIViewController *mainVC;
}
@end

@implementation HBGuidePageViewController
-(id)initWithLoadVC:(id)loadViewController{
    if(self=[super init]){
        mainVC=(UIViewController*)loadViewController;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // all settings are basic, pages with custom packgrounds, title image on each page
    [self showIntroWithCrossDissolve];
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    EAIntroPage *page2 = [EAIntroPage page];
    EAIntroPage *page3 = [EAIntroPage page];
    EAIntroPage *page4 = [EAIntroPage page];
 
    
    page1.bgImage = [UIImage imageNamed:@"instopage1.png"];
    page2.bgImage = [UIImage imageNamed:@"instopage2.png"];
    page3.bgImage = [UIImage imageNamed:@"instopage3.png"];
    page4.bgImage = [UIImage imageNamed:@"instopage4.png"];
 
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    intro.delegate=self;
    intro.flag = 0;
    [intro showInView:self.view animateDuration:0.0];
}


- (void)introDidFinish {
    mainVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    mainVC.modalPresentationStyle = UIModalPresentationFullScreen;//配置present类型
    [self presentViewController:mainVC animated:YES completion:nil];
}

@end
