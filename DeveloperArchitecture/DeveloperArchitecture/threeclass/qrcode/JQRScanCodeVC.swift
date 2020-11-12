//
//  JQRScanCodeVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/12.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

typealias kQRScanCallback = (_ string : String) -> ()

class JQRScanCodeVC : JBaseViewController , AVCaptureMetadataOutputObjectsDelegate{
    var m_qrCallback : kQRScanCallback?
    
    private var m_session : AVCaptureSession?
    private var m_preLayer : AVCaptureVideoPreviewLayer?
    private var m_captureRectArea : CGRect?
    private var m_timerScan : Timer?
    lazy private var m_scanResutRectImageView : UIImageView = {
        let imageView = UIImageView(i: CGRect(x: 0, y: 0, width: 20, height: 20), bg: COLOR_ORANGE)
        _ = imageView.funj_addCornerRadius(10)
        self.view.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = min(KWidth, KHeight) / 2
        self.m_captureRectArea = CGRect(x: (KWidth - width) / 2 , y: (KHeight - width) / 2, width: width, height: width)
        
        funj_setupCaptureSession()
        funj_addBaseConfigView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(funj_OrientationDidChange(_ :)), name: UIDevice.orientationDidChangeNotification , object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.m_session?.isRunning ?? false { self.m_session?.stopRunning()}
        if self.m_timerScan?.isValid ?? false { self.m_timerScan?.invalidate()}
    }

    func funj_addBaseConfigView() {
        let backBt = UIButton(i: CGRect(x: 0, y: KStatusBarHeight, width: 60, height: 40), title: nil, textFC: JTextFC())
            .funj_add(bgImageOrColor: ["backBt"], isImage: true)
            .funj_add(targe: self, action: "funj_clickBackButton:", tag: 0)
        backBt.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        self.view.addSubview(backBt)
        
        if self.title?.count ?? 0 > 0 {
            let titleLabel = UILabel(i: CGRect(x: self.m_captureRectArea!.origin.x - 30, y: KStatusBarHeight, width: self.m_captureRectArea!.size.width + 60, height: 50), title: self.title!, textFC: JTextFC(f: FONT_SIZE17, c: COLOR_WHITE, a: .center))
            self.view.addSubview(titleLabel) ; titleLabel.tag = 1001
        }
        let bounceImageView = UIImageView(i: self.m_captureRectArea!, image: "ZR_ScanFrame")
        self.view.addSubview(bounceImageView) ; bounceImageView.tag = 1002
        
        var frame = self.m_captureRectArea
        let width = 30 * frame!.size.width / 509
        frame = CGRect(x: width + frame!.origin.x , y: frame!.origin.y + width, width: frame!.size.width - 2 * width, height: frame!.size.height - 2 * width)
        let lineImageView = UIImageView(i: frame!, image: "ZR_ScanLine")
        lineImageView.accessibilityFrame = frame!
        lineImageView.height = 0
        self.view.addSubview(lineImageView); lineImageView.tag = 1003
        
        m_timerScan = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true, block: { [weak lineImageView](timer) in
            lineImageView?.alpha = 1
            UIView.animate(withDuration: 1.1) {
                lineImageView?.height = lineImageView?.accessibilityFrame.size.height ?? 0
                lineImageView?.alpha = 0.3
            }completion: { (finished) in
                lineImageView?.height = 0
            }
        })
        
        let titleLabel2 = UILabel(i: CGRect(x: self.m_captureRectArea!.origin.x - 30 , y: self.m_captureRectArea!.origin.y + self.m_captureRectArea!.size.height + 30, width: self.m_captureRectArea!.size.width + 60, height: 50), title: kLocalStr("Scan the frame to the two-dimensional code, you can automatically scan"), textFC: JTextFC(f: FONT_SIZE16, c: COLOR_WHITE, a: .center))
        self.view.addSubview(titleLabel2) ; titleLabel2.tag = 1004
    }
    func funj_setupCaptureSession() {
        if let device = AVCaptureDevice.default(for: .video) {
            let input = try? AVCaptureDeviceInput(device: device)
            if input == nil {
                _ = JAppViewTools.funj_showAlertBlock(nil, message: kLocalStr("Please set APP to access your camera \nSettings> Privacy> Camera"), buttonArr: [kLocalStr("Confirm")]) { (index) in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    UIApplication.shared.open(url!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
                }
                return
            }
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            m_session = AVCaptureSession()
            m_session?.sessionPreset = .high
            if input != nil { self.m_session?.addInput(input!)}
            self.m_session?.addOutput(output)
            
            output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
            
            m_preLayer = AVCaptureVideoPreviewLayer(session: self.m_session!)
            if m_preLayer == nil { return }
            m_preLayer?.videoGravity = .resizeAspectFill
            m_preLayer?.frame = self.view.layer.bounds
            self.view.layer.addSublayer(m_preLayer!)
            m_preLayer?.connection?.videoOrientation = self.funj_orientationFromDeviceOrientation()
            
            self.m_session?.startRunning()
            
            self.funj_changeDeviceVideoZoomFactor(device:device , time: 6, factor: 2)
            self.funj_changeDeviceVideoZoomFactor(device:device , time: 18, factor: 1)
        }
    }
    func funj_changeDeviceVideoZoomFactor(device : AVCaptureDevice , time : TimeInterval , factor : CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            try? device.lockForConfiguration()
            device.videoZoomFactor = factor
            device.unlockForConfiguration()
        }
    }
    func funj_orientationFromDeviceOrientation() -> AVCaptureVideoOrientation{
        switch UIApplication.shared.statusBarOrientation {
            case .portrait: return .portrait
            case .landscapeLeft: return .landscapeLeft
            case .landscapeRight: return .landscapeRight
            case .portraitUpsideDown: return .portraitUpsideDown
            default: return .portraitUpsideDown
        }
    }
    
    @objc func funj_OrientationDidChange(_ noti : Notification?) {
        var width = min(self.view.width, self.view.height) / 2
        self.m_preLayer?.frame = self.view.layer.bounds
        if noti != nil {
            self.m_captureRectArea = CGRect(x: (self.view.width - width) / 2 , y: (self.view.height - width)/2, width: width, height: width)
            let titleLabel = self.view.viewWithTag(1001)
            titleLabel?.left = self.m_captureRectArea!.origin.x - 30
            
            let titleLabel2 = self.view.viewWithTag(1004)
            titleLabel2?.top = self.m_captureRectArea!.origin.y + self.m_captureRectArea!.size.height + 30
            titleLabel2?.left = self.m_captureRectArea!.origin.x - 30
        }
        
        let bounceImageView = self.view.viewWithTag(1002)
        bounceImageView?.frame = self.m_captureRectArea!
        let lineImageView = self.view.viewWithTag(1003)
        var frame = self.m_captureRectArea
        width = 30 * frame!.size.width / 509
        frame = CGRect(x: width + frame!.origin.x , y: frame!.origin.y + width , width: frame!.size.width - 2 * width, height: frame!.size.height - 2 * width)
        lineImageView?.frame = frame!
        lineImageView?.accessibilityFrame = frame!
    }
}
