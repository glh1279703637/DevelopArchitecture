//
//  JMainPhotoPickerVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/5.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI
protocol JMainPhotoPickerVCDelegate : NSObjectProtocol{
    func funj_selectPhotosFinishToCallback(_ imageOrVideoArr : [Any] , isVideo : Bool)
}

class JMainPhotoPickerVC : JBaseTableViewVC, PHPhotoLibraryChangeObserver {
    
    var m_delegate : JMainPhotoPickerVCDelegate?
    
    lazy var m_tipLabel : UILabel = {
        let tipLabel = UILabel(i: CGRect(x: 0, y: 0, width: 200, height: 30), title: "建议请优先选择所有照片", textFC: JTextFC(f: FONT_SIZE14, c: COLOR_ORANGE, a: .center))
        self.view.addSubview(tipLabel)
        return tipLabel
    }()
    var m_timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.funj_addTableContentView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHPhotoLibrary.shared().register(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    func funj_reloadDefaultItems(isVideo : Bool , isMulti : Bool , maxPhotos : Int) {
        JPhotosConfig.shared?.m_currentIsVideo = isVideo
        JPhotosConfig.shared?.m_isMultiplePhotos = isMulti
        JPhotosConfig.shared?.m_maxCountPhotos = isMulti ? maxPhotos : 1
    }
    @objc func funj_checkIsAuthorize(_ timer : Timer) {
        let statusAuthorized = JPhotoPickerInterface.funj_authorizationStatusAuthorized()
        if statusAuthorized == .authorized {
            if m_timer?.isValid ?? false { m_timer?.invalidate() ; m_timer = nil }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.m_defaultImageView.removeFromSuperview()
                self?.funj_getAllPhotosArray()
                self?.m_tipLabel.removeFromSuperview()
            }
        } else if statusAuthorized == .notDetermined && m_tipLabel.superview != nil {
            JAppUtility.funj_shakeAnimationForView(m_tipLabel, offset: CGSize(width: 0, height: 8))
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.m_tipLabel.removeFromSuperview()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.funj_reloadTableView(CGRectZero, table: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        let contentLabel = self.m_defaultImageView.viewWithTag(9993)
        contentLabel?.frame = CGRect(x: -self.m_defaultImageView.left + 10 , y: self.m_defaultImageView.height - 40, width: self.view.width - 20 , height: 40)
        m_tipLabel.top = self.view.height - 60
        m_tipLabel.left = (self.view.width - 200) / 2
    }
    public override func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    @objc override func funj_clickBackButton(_ sender : UIButton? = nil ){
        if self.m_timer?.isValid ?? false {
            self.m_timer?.invalidate()
        }
        super.funj_clickBackButton()
    }
    deinit {
        JPhotosConfig.funj_deallocPhotoConfig()
    }
}
extension JMainPhotoPickerVC {
    func funj_addTableContentView() {
        self.m_tableView.register(JMainPhotoPickerCell.self, forCellReuseIdentifier: kCellIndentifier)
        JPhotoPickerInterface.funj_addConfigSubView(self)
        self.m_defaultImageView.isUserInteractionEnabled = true
        let contentLabel = self.m_defaultImageView.viewWithTag(9993) as? UILabel
        contentLabel?.funj_whenTapped({ (sender) in
            let url = URL(string: UIApplication.openSettingsURLString)
            UIApplication.shared.open(url!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
        })
        let statusAuthorized = JPhotoPickerInterface.funj_authorizationStatusAuthorized()
        if statusAuthorized != .authorized {
            m_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(funj_checkIsAuthorize(_ :)), userInfo: nil, repeats: true)
            let appName = ( Bundle.main.infoDictionary?["CFBundleDisplayName"] ?? Bundle.main.infoDictionary?["CFBundleName"] ) as? String
            let text = kLocalStr("Please allow \(appName!) to access all photos")
            let lo = (text as NSString).range(of: appName!).location
            let attri = contentLabel?.funj_updateAttributedText(text)
            attri?.addAttributes([NSAttributedString.Key.foregroundColor : COLOR_ORANGE], range: NSRange(location: lo, length: appName!.count))
            contentLabel?.attributedText = attri
            if statusAuthorized == .notDetermined {
                m_tipLabel.isHidden = false
            }
            if statusAuthorized.rawValue == 4 /* PHAuthorizationStatusLimited*/ {
                contentLabel?.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    if (self?.m_dataArr.count ?? 0) <= 0  {
                        let contentLabel = self?.m_defaultImageView .viewWithTag(9993)
                        contentLabel?.isHidden = false
                    }
                }
            }
            
            if #available(iOS 14.0, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in }
            } else {
                PHPhotoLibrary.requestAuthorization { (status) in }
            }
        }
        if statusAuthorized == .authorized || statusAuthorized.rawValue == 4 /*PHAuthorizationStatusLimited*/ {
            self.funj_getAllPhotosArray()
        }
        JPhotosConfig.shared?.m_selectCallback = { [weak self] (_ imageOrVideoArr : [Any] , _ isVideo : Bool) -> () in
            if self?.m_delegate?.responds(to: NSSelectorFromString("funj_selectPhotosFinishToCallback:isVideo:")) != nil {
                self?.m_delegate?.funj_selectPhotosFinishToCallback(imageOrVideoArr, isVideo: isVideo)
            }
        }
    }
    func funj_getAllPhotosArray() {
        self.funj_showProgressView()
        JPhotoPickerInterface.funj_getAllAlbums(isVideo: JPhotosConfig.shared?.m_currentIsVideo ?? false) {[weak self] (dataArr) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.funj_closeProgressView()
                self?.m_dataArr.removeAll()
                self?.m_dataArr += dataArr
                self?.m_tableView.reloadData()
                self?.m_tipLabel.isHidden = self?.m_dataArr.count ?? 0 > 0
            }
        }
    }
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
            self?.m_dataArr.removeAll()
            self?.funj_getAllPhotosArray()
        }
    }
}
extension JMainPhotoPickerVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_dataArr.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kImageViewHeight(100 + kIS_IPAD_1 * 20 ) + 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableviewCell = tableView.dequeueReusableCell(withIdentifier: kCellIndentifier) as? JMainPhotoPickerCell
        tableviewCell?.funj_setBaseTableCellWithData( self.m_dataArr[indexPath.row])
        return tableviewCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.m_dataArr[indexPath.row] as! JPhotosDataModel
        _ = self.funj_getPushVC(className: JPhotoPickerVC.self, title: model.m_name, data: model.m_name) { (vc) in
            let vcs = vc as! JPhotoPickerVC
            vcs.m_dataModel = model
        }
    }
}
extension JMainPhotoPickerVC {
    class func funj_getPopoverPhotoPickerVC(_ delegate :UIViewController, callback : ksetPopverBaseVC?){
        if JHttpReqHelp.funj_checkNetworkType() == false { return }
        let controller = JMainPhotoPickerVC.init()
        controller.m_delegate = delegate as? JMainPhotoPickerVCDelegate
        let nav = JBaseNavigationVC(rootViewController: controller)
        nav.m_currentNavColor = .kCURRENTISWHITENAV_TAG
        
        var setPresentView = false
        callback?(controller , &setPresentView)
        if setPresentView == false {
            controller.funj_setPresentIsPoperView(nav, size: CGSize(width: kphotoPickerViewWidth, height: kphotoPickerViewHeight), target: nil)
            controller.m_currentShowVCModel = .kCURRENTISPOPOVER
        } else {
            nav.modalPresentationStyle = .fullScreen
            controller.m_currentShowVCModel = .kCURRENTISPRENTVIEW
        }
        
        delegate.present(nav, animated: true, completion: nil)
    }
}

