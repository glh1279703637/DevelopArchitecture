//
//  JPhotoPickerVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class JPhotoPickerVC : JBaseCollectionVC {
    var m_dataModel : JPhotosDataModel?
    var m_isOrigalImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowlayout = self.m_collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.minimumLineSpacing = 5
        flowlayout.minimumInteritemSpacing = 5
        self.m_collectionView.register(JPhotoPickerCell.self, forCellWithReuseIdentifier: kCellIndentifier)
        funj_sortResultImagesData()
        funj_addSubBottomBgView()
    }
}
extension JPhotoPickerVC {
    func funj_solverDataModelSize() {
        let countBt = self.navigationItem.rightBarButtonItem?.customView as? UIButton
        if self.m_dataArray.count <= 0 || self.m_isOrigalImage == false{
            countBt?.setTitle("", for: .normal) ; return
        }
        if self.m_isOrigalImage == false { return }
        JPhotoPickerInterface.funj_getPhotoBytesWithPhotoArray(photoArray: self.m_dataArray as! [JPhotoPickerModel]) { [weak countBt](totalBytes) in
            countBt?.setTitle(totalBytes, for: .normal)
        }
    }
    func funj_addSubBottomBgView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(i: "", image: nil, setButton: nil, callback: nil)
        let bottomBgView = UIView(i: CGRect(x: 0, y: self.view.height - 50, width: self.view.width, height: 50), bg: kColor_White_Dark)
        self.view.addSubview(bottomBgView) ; bottomBgView.tag = 3023
        
        let line = UIImageView(i_line: CGRect(x: 0, y: 0, width: kWidth, height: 1))
        bottomBgView.addSubview(line)
        
        if JPhotosConfig.shared?.m_currentIsVideo ?? false == false {
            let origareBt = UIButton(i: CGRect(x: 0, y: 0, width: 100, height:50 ), title:kLocalStr("Original") , textFC: JTextFC(f: kFont_Size13, c: kColor_Text_Black_Dark))
                .funj_add(bgImageOrColor: ["photo_original_def","photo_original_sel"], isImage: true)
                .funj_add(autoSelect: false)
                .funj_updateContentImage(layout: .kLEFT_IMAGECONTENT, a: JAlignValue(h: 10, s: 10, f: 0))
                .funj_add(targe: self, action: "funj_selectItemTo:", tag: 3024)
            bottomBgView.addSubview(origareBt)
        }
        let sumBt = UIButton(i: CGRect(x: self.view.width - 100 , y: 0, width: 100, height: 50), title: kLocalStr("Confirm"), textFC: JTextFC(f: kFont_Size13, c: kColor_Text_Black_Dark))
            .funj_add(targe: self, action: "funj_selectFinishTo:", tag: 3025)
            .funj_updateContentImage(layout: .kRIGHT_CONTENTIMAGE, a: JAlignValue(h: 10, s: 0, f: 20))
        bottomBgView.addSubview(sumBt)
    }
    func funj_sortResultImagesData() {
        self.m_dataModel?.m_fetchResult?.enumerateObjects({ (asset, idx, stop) in
            if asset.mediaType == .video {
                let min = asset.duration / 60
                let ss = asset.duration - min * 60
                let timeLength = String(format: "%02d:%02d", min,ss)
                let model = JPhotoPickerModel(asset: asset, isVideo: true, timeLenght: timeLength)
                self.m_dataArr.append(model)
            } else {
                let model = JPhotoPickerModel(asset: asset, isVideo: false, timeLenght: nil)
                self.m_dataArr.append(model)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            let height = (self?.m_collectionView.contentSize.height ?? 0) - (self?.m_collectionView.height ?? 0)
            if height > 0 {
                self?.m_collectionView.setContentOffset(CGPoint(x: 0, y: height), animated: false)
            }
        }
    }
    @objc func funj_selectItemTo(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        self.m_isOrigalImage = sender.isSelected
        self.funj_solverDataModelSize()
    }
    @objc func funj_selectFinishTo(_ sender : UIButton) {
        if self.m_dataArray.count > 0 { self .funj_showProgressView()}
        var saveImageDic : [AnyHashable : Any] = [:]
        for i in 0..<self.m_dataArray.count {
            let model = self.m_dataArray[i] as! JPhotoPickerModel
            if JPhotosConfig.shared?.m_currentIsVideo ?? false {
                JPhotoPickerInterface.funj_getVideoWithAsset(asset: model.m_asset!) { [weak self] (item, dic) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.funj_getDetailInfo(&saveImageDic, image: nil, dic: dic, isDegraded: true, item: item, index: i)
                    }
                }
            } else {
                JPhotoPickerInterface.funj_getPhotoWithAsset(phAsset: model.m_asset, deliveryMode: .highQualityFormat, width: kWidth) { [weak self] (image, dic, isDegraded) in
                    if isDegraded == true { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.funj_getDetailInfo(&saveImageDic, image: image, dic: dic, isDegraded: isDegraded, item: nil, index: i)
                    }
                }
            }
        }
    }
    func funj_getDetailInfo(_ saveImageDic : inout [AnyHashable : Any] , image : UIImage? , dic : [AnyHashable : Any]? , isDegraded : Bool , item : AVPlayerItem? , index : Int){
        var image2 = image
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            if item != nil { saveImageDic["\(index)"] = item }
        }else {
            if self.m_isOrigalImage == false {
                let data = JAppUtility.funj_compressImage(image, sizeM: -1)
                if data != nil { image2 = UIImage.init(data: data!) }
            }
            if image2 != nil { saveImageDic["\(index)"] = image2 }
        }
        
        if saveImageDic.count == self.m_dataArray.count {
            self.funj_closeProgressView()
            var saveArr:[Any] = []
            for j in 0..<saveImageDic.count {
                if saveImageDic["\(j)"] != nil {
                    let image = saveImageDic["\(j)"] as Any
                    saveArr.append(image)
                }
            }
            JPhotosConfig.shared?.m_selectCallback?(saveArr , JPhotosConfig.shared?.m_currentIsVideo ?? false)

            self.m_currentShowVCModel = .kCURRENTISPRENTVIEW
            self.modalTransitionStyle = .crossDissolve
            self.funj_clickBackButton()
        }
    }
    
    override func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let vc = self.navigationController?.viewControllers.first as? JBaseViewController
        let sub = kFilletSubHeight * (vc?.m_currentShowVCModel != .kCURRENTISPOPOVER ? 1 : 0)
        self.funj_reloadTableView(CGRectZero, table: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - 50 - sub))
        let bottomBgView = self.view.viewWithTag(3023)
        bottomBgView?.top = self.view.height - 50 - sub
        bottomBgView?.width = self.view.width
        let sumBt = bottomBgView?.viewWithTag(3025)
        sumBt?.left = (bottomBgView?.width ?? 0) - 100
    }
}

extension JPhotoPickerVC {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = (collectionView.width - 4 * 5) / 3
        if kis_IPad { width  = (collectionView.width - 5 * 5) / 4}
        return CGSize(width: width, height: kImageViewHeight(width))
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> JPhotoPickerCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIndentifier, for: indexPath) as! JPhotoPickerCell
        cell.funj_setBaseCollectionData(self.m_dataArr[indexPath.row])
        cell.m_selectItemCallback = { [weak self , cell](sender , model) in
            if sender.isSelected {
                if self?.m_dataArray.count ?? 0 >= JPhotosConfig.shared?.m_maxCountPhotos ?? 1 || (JPhotosConfig.shared?.m_maxCountPhotos ?? 0 <= 0) {
                    sender.isSelected = false
                    model?.m_isSelected = false
                    let str = String(format: "You can only choose %zd photos", JPhotosConfig.shared?.m_maxCountPhotos ?? 0)
                    JAppViewTools.funj_showTextToast(self?.view, message: kLocalStr(str))
                    return
                }
                self?.m_dataArray.append(model!)
                model?.m_indexCount = self?.m_dataArray.count ?? 0
                cell.funj_reloadCountIndex(model!.m_indexCount )
            } else {
                self?.m_dataArray.removeAll(where: { (mo) -> Bool in
                    return (mo as? JPhotoPickerModel) == model
                })

                model?.m_indexCount = 0
                for i in 0..<(self?.m_dataArray.count ?? 0){
                    let mo = self?.m_dataArray[i] as? JPhotoPickerModel
                    mo?.m_indexCount = i + 1
                }
                self?.m_collectionView.reloadData()
            }
            if let s = self {
                self?.title = "\(s.m_dataString)(\(s.m_dataArray.count)/\(JPhotosConfig.shared!.m_maxCountPhotos))"
            }
            
            self?.funj_solverDataModelSize()
            let sumBt = self?.view.viewWithTag(3023) as? UIButton
            sumBt?.isEnabled = self?.m_dataArray.count ?? 0 > 0 ? true : false
        }
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcs = self.funj_getPushVC(className: JPhotosPreviewsVC.self, title: self.m_dataString, data: self.m_dataArr, callback: { [weak self] (vc) in
            let vcs = vc as? JPhotosPreviewsVC
            vcs?.m_scrollIndex = indexPath.row
            vcs?.m_selectDataArr = self?.m_dataArray
        })
        (vcs as? JPhotosPreviewsVC)?.m_changeCallback = { [weak self] (dataArr ,isOrigalImage) in
            self?.m_isOrigalImage = isOrigalImage
            let bottomBgView = self?.view.viewWithTag(3023)
            let origareBt = bottomBgView?.viewWithTag(3024) as? UIButton
            origareBt?.isSelected = isOrigalImage
            self?.m_dataArray.removeAll()
            self?.m_dataArray += dataArr!
            self?.m_collectionView.reloadData()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)//分别为上、左、下、右
    }
}
