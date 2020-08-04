//
//  JQRScanCodeVC.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2019/5/31.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JQRScanCodeVC.h"

@interface JQRScanCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureSession*m_session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer*m_preLayer;
@property(nonatomic,assign)CGRect m_captureRectArea;
@property(nonatomic,strong)NSTimer *m_timerScan;

@property(nonatomic,strong)UIImageView*m_scanResutRectImageView;
@end

@implementation JQRScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = MIN(KWidth,KHeight)/2;
    self.m_captureRectArea = CGRectMake((KWidth-width)/2, (KHeight-width)/2, width, width);
    
    [self funj_setupCaptureSession];
    [self funj_addBaseConfigView];
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(funj_OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.m_session.running)[self.m_session stopRunning];
    if(self.m_timerScan.valid)[self.m_timerScan invalidate];
}
-(UIImageView*)m_scanResutRectImageView{
    if(!_m_scanResutRectImageView){
        _m_scanResutRectImageView =[UIImageView funj_getImageView:CGRectMake(0, 0, 20, 20) bgColor:COLOR_ORANGE];
        [self.view addSubview:_m_scanResutRectImageView];
        [_m_scanResutRectImageView funj_setViewCornerRadius:10];
    }
    return _m_scanResutRectImageView;
}
-(void)funj_addBaseConfigView{
    UIButton *backBt =[UIButton funj_getButtons:CGRectMake(0, KStatusBarHeight, 60, 40) :nil :JTextFCZero() :@[@"backBt"] :self :@"funj_clickBackButton:" :0 :nil];
    backBt.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 10);
    [self.view addSubview:backBt];
    
    if(self.title && self.title.length>0){
        UILabel *titleLabel =[UILabel funj_getLabel:CGRectMake(self.m_captureRectArea.origin.x-30, KStatusBarHeight, self.m_captureRectArea.size.width+60, 50) :self.title :JTextFCMakeAlign(PUBLIC_FONT_SIZE17, COLOR_WHITE,NSTextAlignmentCenter)];
        [self.view addSubview:titleLabel];titleLabel.tag= 1001;
    }
    
    UIImageView *bounceImageView =[UIImageView funj_getImageView:self.m_captureRectArea image:@"ZR_ScanFrame.png"];
    [self.view addSubview:bounceImageView];bounceImageView.tag= 1002;
    
    CGRect frame = self.m_captureRectArea;
    CGFloat width = 30*frame.size.width/509;
    frame = CGRectMake(width+frame.origin.x, frame.origin.y+width, frame.size.width-2*width, frame.size.height-2*width);
    UIImageView *lineImageView =[UIImageView funj_getImageView:frame image:@"ZR_ScanLine.png"];
    lineImageView.accessibilityFrame = frame;
    lineImageView.height = 0;
    [self.view addSubview:lineImageView];lineImageView.tag= 1003;
    LRWeakSelf(lineImageView);
    _m_timerScan =[NSTimer scheduledTimerWithTimeInterval:1.3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        LRStrongSelf(lineImageView);
        lineImageView.alpha = 1;
        [UIView animateWithDuration:1.1 animations:^{
            lineImageView.height = lineImageView.accessibilityFrame.size.height;
            lineImageView.alpha = 0.3;
        }completion:^(BOOL finished) {
            lineImageView.height =  0;
        }];
    }];
    
    UILabel *titleLabel2 =[UILabel funj_getLabel:CGRectMake(self.m_captureRectArea.origin.x-30, self.m_captureRectArea.origin.y+self.m_captureRectArea.size.height+30, self.m_captureRectArea.size.width+60, 50) :LocalStr(@"Scan the frame to the two-dimensional code, you can automatically scan") :JTextFCMakeAlign(PUBLIC_FONT_SIZE16, COLOR_WHITE,NSTextAlignmentCenter)];
    [self.view addSubview:titleLabel2];
    titleLabel2.tag= 1004;
}

- (void)funj_setupCaptureSession{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(device){
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if(!input) {// Handling the error appropriately.
            [JAppViewTools funj_showTextToast:[JAppViewTools funj_getKeyWindow] message:LocalStr(@"Please set APP to access your camera \nSettings> Privacy> Camera")];
            return;
        }
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //Set delegate on running the main thread
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _m_session = [[AVCaptureSession alloc]init];
        //Adopted rate in High Capture Quality
        [self.m_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if(input)[self.m_session addInput:input];
        [self.m_session addOutput:output];
        
        //Setup QR code encoding format
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode128Code];
        
        _m_preLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.m_session];
        self.m_preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.m_preLayer.frame = self.view.layer.bounds;
        [self.view.layer addSublayer:self.m_preLayer];
         self.m_preLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];;
        
//        //Capture Area
//         CGRect rect = CGRectMake( self.m_captureRectArea.origin.y/self.view.height,self.m_captureRectArea.origin.x/self.view.width, self.m_captureRectArea.size.height/self.view.height, self.m_captureRectArea.size.width/self.view.width);
//        if([self preferredInterfaceOrientationForPresentation] == UIInterfaceOrientationLandscapeRight){
//            rect = CGRectMake( self.m_captureRectArea.origin.x/self.view.width,self.m_captureRectArea.origin.y/self.view.height, self.m_captureRectArea.size.width/self.view.width, self.m_captureRectArea.size.height/self.view.height);
//
//        }
//         [output setRectOfInterest:rect];
        
        //Starting Capture
        [self.m_session startRunning];
    }

    [self funj_changeDeviceVideoZoomFactor:device :6  :2];
    [self funj_changeDeviceVideoZoomFactor:device :18  :1];
}
-(void)funj_changeDeviceVideoZoomFactor:(AVCaptureDevice*)device :(CGFloat)time :(CGFloat)factor{
    LRWeakSelf(device);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LRStrongSelf(device);
        if ([device lockForConfiguration:nil] ) {
            device.videoZoomFactor = factor;
            [device unlockForConfiguration];
        }
    });
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate event
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AudioServicesDisposeSystemSoundID (1108);
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        AVMetadataObject *transformCode = [self.m_preLayer transformedMetadataObjectForMetadataObject:metadataObject];
        self.m_scanResutRectImageView.center = CGPointMake(transformCode.bounds.origin.x + transformCode.bounds.size.width/2, transformCode.bounds.origin.y + transformCode.bounds.size.height/2);
        self.m_captureRectArea = transformCode.bounds;
        NSString *svalue = metadataObject.stringValue;
        [self.m_session stopRunning];
        [self funj_clickBackButton:nil];

//        [self funj_OrientationDidChange:nil];
        if(self.m_qrCallback)self.m_qrCallback(svalue);
      }
}


- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;;
    }
    return AVCaptureVideoOrientationLandscapeRight;
}
//- (BOOL)shouldAutorotate{
//    return NO;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
////    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
////        return UIInterfaceOrientationPortrait;
////    }else if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight){
////        return UIInterfaceOrientationLandscapeRight;
////    }
//    return UIInterfaceOrientationLandscapeRight;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    self.m_preLayer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];;
//    return UIInterfaceOrientationMaskAll;
//}

-(void)funj_OrientationDidChange:(NSNotification*)noti{
    CGFloat width = MIN(self.view.width,self.view.height)/2;
    self.m_preLayer.frame = self.view.layer.bounds;

    if(noti){
        self.m_captureRectArea = CGRectMake((self.view.width-width)/2, (self.view.height-width)/2, width, width);
        UILabel *titleLabel =[self.view viewWithTag:1001];
        titleLabel.left = self.m_captureRectArea.origin.x-30;
        
        UILabel *titleLabel2 =[self.view viewWithTag:1004];
        titleLabel2.top = self.m_captureRectArea.origin.y+self.m_captureRectArea.size.height+30;
        titleLabel2.left = self.m_captureRectArea.origin.x-30;
    }
    UIImageView *bounceImageView =[self.view viewWithTag:1002];
    bounceImageView.frame = self.m_captureRectArea;
    UIImageView *lineImageView =[self.view viewWithTag:1003];
    CGRect frame = self.m_captureRectArea;
    width = 30*frame.size.width/509;
    frame = CGRectMake(width+frame.origin.x, frame.origin.y+width, frame.size.width-2*width, frame.size.height-2*width);
    lineImageView.frame =frame;
    lineImageView.accessibilityFrame = frame;
}

@end
