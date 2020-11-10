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
        if self.m_dataArray.count <= 0 {
            countBt?.setTitle("", for: .normal) ; return
        }
        
    }
    func funj_addSubBottomBgView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(i: "", image: nil, setButton: nil, callback: nil)
        let bottomBgView = UIView(i: CGRect(x: 0, y: self.view.height - 50, width: self.view.width, height: 50), bg: COLOR_WHITE_DARK)
        self.view.addSubview(bottomBgView) ; bottomBgView.tag = 3023
        
        let line = UIImageView(i_line: CGRect(x: 0, y: 0, width: KWidth, height: 1))
        bottomBgView.addSubview(line)
        
        if JPhotosConfig.shared?.m_currentIsVideo ?? false == false {
            let origareBt = UIButton(i: CGRect(x: 0, y: 0, width: 100, height:50 ), title:kLocalStr("Original") , textFC: JTextFC(f: FONT_SIZE13, c: COLOR_TEXT_BLACK_DARK))
                .funj_add(autoSelect: false)
                .funj_updateContentImage(layout: .kLEFT_IMAGECONTENT, a: JAlignValue(h: 10, s: 10, f: 0))
            bottomBgView.addSubview(origareBt)
        }
        let sumBt = UIButton(i: CGRect(x: self.view.width - 100 , y: 0, width: 100, height: 50), title: kLocalStr("Confirm"), textFC: JTextFC(f: FONT_SIZE13, c: COLOR_TEXT_BLACK_DARK))
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
    @objc func funj_selectFinishTo(_ sender : UIButton) {
        if self.m_dataArray.count > 0 { self .funj_showProgressView()}
        
        for i in 0..<self.m_dataArray.count {
            let model = self.m_dataArray[i] as! JPhotoPickerModel
            if JPhotosConfig.shared?.m_currentIsVideo ?? false {
                JPhotoPickerInterface.funj_getVideoWithAsset(asset: model.m_asset!) { [weak self] (item, dic) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                        self?.funj_getDetailInfo(<#T##saveImageDic: [AnyHashable : Any]##[AnyHashable : Any]#>, image: <#T##UIImage#>, dic: <#T##[String : Any]#>, isDegraded: <#T##Bool#>, item: <#T##<<error type>>#>, index: <#T##Int#>)
                    }
                }
            } else {
                JPhotoPickerInterface.funj_getPhotoWithAsset(phAsset: model.m_asset, deliveryMode: .highQualityFormat, width: KWidth) { [weak self] (image, dic, isDegraded) in
                    if isDegraded == true { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                        self.funj_getdeta
                    }
                }
            }
        }
    }
    func funj_getDetailInfo(_ saveImageDic : [AnyHashable : Any] ,image : UIImage , dic : [String : Any] , isDegraded : Bool , item : AVPlayerItem , index : Int){
        var saveImageDic : [AnyHashable : Any] = [:]
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            if item != nil { saveImageDic["\(index)"] = item }
            
        }
    }
    
    override func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let vc = self.navigationController?.viewControllers.first as? JBaseViewController
        let sub = KFilletSubHeight * (vc?.m_currentShowVCModel != .kCURRENTISPOPOVER ? 1 : 0)
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
        if kIS_IPAD { width  = (collectionView.width - 5 * 5) / 4}
        return CGSize(width: width, height: kImageViewHeight(width))
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> JPhotoPickerCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIndentifier, for: indexPath) as! JPhotoPickerCell
        cell.funj_setBaseCollectionData(self.m_dataArr[indexPath.row])
        cell.m_selectItemCallback = { [weak self , cell](sender , model) in
            if sender.isSelected {
                if self?.m_dataArray.count ?? 0 > JPhotosConfig.shared?.m_maxCountPhotos ?? 0 {
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
                self?.m_dataArray.removeAll(where: { (m) -> Bool in
                    if model == m as? JPhotoPickerModel {
                        return true
                    }
                    return false
                })
                model?.m_indexCount = 0
                for i in 0..<(self?.m_dataArray.count ?? 0){
                    let mo = self?.m_dataArray[i] as? JPhotoPickerModel
                    mo?.m_indexCount = i + 1
                }
                self?.m_collectionView.reloadData()
            }
            self?.title = "\(String(describing: self?.m_dataString))(\(String(describing: self?.m_dataArray.count))/\([JPhotosConfig.shared?.m_maxCountPhotos]))"
            self?.funj_solverDataModelSize()
            let sumBt = self?.view.viewWithTag(3023) as? UIButton
            sumBt?.isEnabled = self?.m_dataArray.count ?? 0 > 0 ? true : false
        }
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = COLOR_WHITE_DARK
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)//分别为上、左、下、右
    }
}
