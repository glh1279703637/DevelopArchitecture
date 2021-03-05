//
//  JPhotoPickerCell.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

typealias selectPhotoItemCallback = (UIButton , JPhotoPickerModel?) -> ()

class JPhotoPickerCell : JBaseCollectionViewCell {
    var m_selectItemCallback : selectPhotoItemCallback?
    private var m_coverImageView : UIImageView?
    private var m_countLabel : UILabel?
    private var m_timeLabel : UIButton?
    private var m_selectBt : UIButton?
    private var m_dataModel : JPhotoPickerModel?
    
    override func funj_addBaseCollectionView() {
        let width = self.width
        
        m_coverImageView = UIImageView(i: CGRect(x: 0, y: 0, width: width, height: kImageViewHeight(width)), image: nil)
        m_coverImageView?.contentMode = .scaleAspectFill
        self.contentView.addSubview(m_coverImageView!)
        m_coverImageView?.layer.masksToBounds = true
        
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            m_timeLabel = UIButton(i: CGRect(x: 30, y: m_coverImageView!.height - 20, width: m_coverImageView!.width - 40, height: 15), title: "00:00", textFC: JTextFC(f: kFont_Size10, c: UIColor.gray))
                .funj_add(bgImageOrColor: ["VideoSendIcon"], isImage: true)
                .funj_updateContentImage(layout: .kRIGHT_IMAGECONTENT, a: JAlignValue(h: 0, s: 10, f: 0))
            self.contentView.addSubview(m_timeLabel!)
        }
        
        m_selectBt = UIButton(i: CGRect(x: m_coverImageView!.width - 60, y: 0, width: 60, height: 60), title: nil, textFC: JTextFC())
            .funj_add(bgImageOrColor: ["photo_def_photoPickerVc","photo_sel_photoPickerVc"], isImage: true)
            .funj_add(targe: self, action: "funj_selectToAdd:", tag: 0)
            .funj_add(autoSelect: false)
        self.contentView.addSubview(m_selectBt!)
        m_selectBt?.contentHorizontalAlignment = .right
        m_selectBt?.contentVerticalAlignment = .top
        
        if JPhotosConfig.shared?.m_isMultiplePhotos ?? false == false {
            m_countLabel = UILabel(i: CGRect(x: 5, y: m_coverImageView!.height - 20, width: 15, height: 15), title: nil, textFC: JTextFC(f: kFont_Size10, c: kColor_White, a:.center))
                .funj_addCornerLayer(JFilletValue(w: 0, r: 15 / 2, c: kColor_Clear))
            self.contentView.addSubview(m_countLabel!)
            m_countLabel?.backgroundColor = kColor_Red
        }
    }
    override func funj_setBaseCollectionData(_ data: Any) {
        m_dataModel = data as? JPhotoPickerModel
        m_timeLabel?.setTitle(m_dataModel?.m_timeLength, for: .normal)
        _ = m_timeLabel?.funj_updateContentImage(layout: .kRIGHT_IMAGECONTENT, a: JAlignValue(h: 0, s: 10, f: 0))
        m_countLabel?.text = "\(m_dataModel!.m_indexCount)"
        m_selectBt?.isSelected = m_dataModel?.m_isSelected ?? false
        m_countLabel?.isHidden = (m_dataModel?.m_indexCount ?? 0) <= 0
        JPhotoPickerInterface.funj_getPhotoWithAsset(phAsset: m_dataModel?.m_asset, deliveryMode: .fastFormat, width: m_coverImageView!.width) { [weak self] (image, dic , isDegraded) in
            self?.m_coverImageView?.image = image
        }
    }
    func funj_reloadCountIndex(_ index : Int) {
        m_countLabel?.text = "\(index)"
        m_countLabel?.isHidden = index <= 0
    }
    @objc func funj_selectToAdd(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        m_dataModel?.m_isSelected = sender.isSelected
        m_selectItemCallback?(sender, m_dataModel)
    }
}
