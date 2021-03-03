//
//  JPhotosPreviewsVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

typealias kchangeCallback = (_ dataArr : [Any]? , _ isOrigalImage : Bool) -> ()

class JPhotosPreviewsVC : JBaseCollectionVC {
    var m_scrollIndex : Int = -1
    var m_selectDataArr : [Any]? = []
    var m_isOrigalImage : Bool = false
    var m_changeCallback : kchangeCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JPhotoPickerInterface.funj_addConfigSubView(self)
        self.m_defaultImageView.removeFromSuperview()
        let flowlayout = self.m_collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowlayout?.minimumLineSpacing = 0
        flowlayout?.minimumInteritemSpacing = 0
        flowlayout?.scrollDirection = .horizontal
        self.m_collectionView.isPagingEnabled = true
        
        self.m_collectionView.register(JPhotosPreviewsCell.self, forCellWithReuseIdentifier: kCellIndentifier)
        self.funj_addSubBottomBgView()
        self.m_collectionView.alwaysBounceVertical = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            if (self?.m_scrollIndex ?? 0) > 0 && (self?.m_scrollIndex ?? 0) < (self?.m_dataArray.count ?? 0) {
                self?.m_collectionView.scrollToItem(at: IndexPath(row: (self?.m_scrollIndex ?? 0), section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.scrollViewDidEndDecelerating(self!.m_collectionView)
        }
    }
    func funj_addSubBottomBgView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(i: nil , image: "photo_def_photoPickerVc", setButton: { (button) in
            button.funj_add(autoSelect: false)
            .setImage(UIImage(named: "photo_sel_photoPickerVc"), for: .selected)

        }, target: self, action: "funj_selectToAdd:")
        
        let bottomBgView = UIView(i: CGRect(x: 0, y: self.view.height - 50, width: self.view.width, height: 50), bg: kColor_White_Dark)
        self.view.addSubview(bottomBgView) ; bottomBgView.tag = 3023
        
        let line = UIImageView(i_line: CGRect(x: 0, y: 0, width: kWidth, height: 1))
        bottomBgView.addSubview(line)
        
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            let origareBt = UIButton(i: CGRect(x: 0, y: 0, width: 100, height: 50), title: kLocalStr("Original"), textFC: JTextFC(f: kFont_Size13, c: kColor_Text_Black_Dark))
                .funj_add(bgImageOrColor: ["photo_original_def","photo_original_sel"], isImage: true)
                .funj_add(targe: self, action: "funj_selectItemTo:", tag: 3024)
                .funj_add(autoSelect: false)
            bottomBgView.addSubview(origareBt)
        }
        let sumBt = UIButton(i: CGRect(x: self.view.width - 100, y: 0, width: 100, height: 50), title: kLocalStr("Confirm"), textFC: JTextFC(f: kFont_Size13, c: kColor_Text_Black_Dark))
            .funj_add(targe: self, action: "funj_selectFinishTo:", tag: 3025)
            .funj_updateContentImage(layout: .kRIGHT_CONTENTIMAGE, a: JAlignValue(h: 10, s: 0, f: 20))
        bottomBgView.addSubview(sumBt)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.funj_reloadTableView(CGRectZero, table: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - 50))
        let bottomBgView = self.view.viewWithTag(3023)
        bottomBgView?.top = self.view.height - 50
        bottomBgView?.width = self.view.width
        let sumBt = bottomBgView?.viewWithTag(3025)
        sumBt?.left = (bottomBgView?.width ?? 0) - 100
    }
}
extension JPhotosPreviewsVC {
    @objc func funj_selectItemTo (_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        self.m_isOrigalImage = sender.isSelected
    }
    @objc func funj_selectFinishTo (_ sender : UIButton) {
        if self.m_selectDataArr?.count ?? 0 <= 0 {
            if self.m_selectDataArr?.count ?? 0 >= (JPhotosConfig.shared?.m_maxCountPhotos ?? 0) {return }
            let sender = self.navigationItem.rightBarButtonItem!.customView as! UIButton
            self.funj_selectToAdd(sender)
            if self.m_selectDataArr?.count ?? 0 <= 0 { return }
        }
        self.funj_showProgressView()

        var saveImageDic : [AnyHashable : Any] = [:]

        for i in 0..<(self.m_selectDataArr?.count ?? 0) {
            let model = self.m_selectDataArr?[i] as? JPhotoPickerModel
            if JPhotosConfig.shared?.m_currentIsVideo ?? false {
                JPhotoPickerInterface.funj_getVideoWithAsset(asset: model?.m_asset) { [weak self ](item , dic) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self?.funj_getDetailInfo(&saveImageDic, image: nil, dic: dic, isDegraded: true, item: item, index: i)
                    }
                }
            } else {
                JPhotoPickerInterface.funj_getPhotoWithAsset(phAsset: model?.m_asset, deliveryMode: .highQualityFormat, width: kWidth) { [weak self] (image, dic , isDegraded) in
                    if isDegraded { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self?.funj_getDetailInfo(&saveImageDic, image: image, dic: dic , isDegraded: isDegraded, item: nil, index: i)
                    }
                }
            }
            
        }
    }
    @objc func funj_selectToAdd (_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected && (self.m_selectDataArr?.count ?? 0) >= (JPhotosConfig.shared?.m_maxCountPhotos ?? 0) {
            sender.isSelected = false
            JAppViewTools.funj_showTextToast(self.view , message: String(format: "You can only choose %zd photos", JPhotosConfig.shared?.m_maxCountPhotos ?? 0))
            return
        }
        let index = Int((self.m_collectionView.contentOffset.x + 10 ) / self.m_collectionView.width)
        
        if index < self.m_dataArray.count {
            let model = self.m_dataArray[index] as? JPhotoPickerModel
            if sender.isSelected {
                model?.m_isSelected = true
                self.m_selectDataArr?.append(model!)
            } else {
                model?.m_isSelected = false
                self.m_selectDataArr?.removeAll(where: { (mo) -> Bool in
                    return (mo as? JPhotoPickerModel) == model
                })
            }
        }
        
    }
    func funj_getDetailInfo(_ saveImageDic : inout [AnyHashable : Any] , image : UIImage? , dic : [AnyHashable : Any]? , isDegraded : Bool , item : AVPlayerItem? , index : Int){
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            if item != nil { saveImageDic["\(index)"] = item }
        } else {
            if image != nil { saveImageDic["\(index)"] = image }
        }
        if saveImageDic.count == self.m_selectDataArr!.count {
            self.funj_closeProgressView()
            var saveArr :[Any] = []
            for j in 0..<saveImageDic.count {
                if saveImageDic["\(j)"] != nil {
                    saveArr.append(saveImageDic["\(j)"] as Any)
                }
            }
            JPhotosConfig.shared?.m_selectCallback?(saveArr , JPhotosConfig.shared?.m_currentIsVideo ?? false )
            self.m_currentShowVCModel = .kCURRENTISPRENTVIEW
            self.modalTransitionStyle = .crossDissolve
            self.funj_clickBackButton()
        }
    }
    override func funj_clickBackButton(_ sender: UIButton? = nil) {
        self.m_changeCallback?(self.m_selectDataArr,self.m_isOrigalImage)
        super.funj_clickBackButton()
    }
}
extension JPhotosPreviewsVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.m_dataArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIndentifier, for: indexPath) as! JPhotosPreviewsCell
        self.m_defaultImageView.isHidden = true
        if self.m_scrollIndex == -1 || indexPath.row == self.m_scrollIndex {
            self.m_scrollIndex = -1
            cell.funj_setBaseCollectionData(self.m_dataArray[indexPath.row])
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for cell in self.m_collectionView.visibleCells {
            (cell as? JPhotosPreviewsCell)?.funj_stopAllPlayer()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + 10 ) / scrollView.width)
        let rightBt = self.navigationItem.rightBarButtonItem?.customView as? UIButton
        rightBt?.isSelected = false
        if index < self.m_dataArray.count {
            let model = self.m_dataArray[index] as? JPhotoPickerModel

            let isHas = self.m_selectDataArr?.contains(where: { (mo) -> Bool in
                return (mo as! JPhotoPickerModel) == model
            })
            if isHas ?? false {
                rightBt?.isSelected = model?.m_isSelected ?? false
            }
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }

}
