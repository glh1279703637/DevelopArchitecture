//
//  JMainPhotoPickerCell.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

class JMainPhotoPickerCell : JBaseTableViewCell {
    var m_imageView : UIImageView?
    var m_titleLabel : UILabel?
    var m_lineImageView : UIImageView?
    
    override func funj_addBaseTableSubView() {
        self.accessoryType = .disclosureIndicator
        
        m_imageView = UIImageView(i: CGRect(x: 20, y: 10, width: 90, height: kImageViewHeight(100 + kis_IPad_1 * 20 )), image: nil)
        self.contentView.addSubview(m_imageView!)
        m_imageView?.contentMode = .scaleAspectFill
        m_imageView?.layer.masksToBounds = true
        
        m_titleLabel = UILabel(i: CGRect(x:m_imageView!.right + 20 , y: m_imageView!.center.y - 10, width: kWidth - m_imageView!.width - 40, height: 20), title: "", textFC: JTextFC(f: kFont_Size17, c: kColor_Text_Black))
        self.contentView.addSubview(m_titleLabel!)
        
        m_lineImageView = UIImageView(i_line: CGRect(x: m_titleLabel!.left, y: m_imageView!.bottom + 9 , width: kWidth - m_imageView!.right - 20 * 2, height: 1))
        self.contentView.addSubview(m_lineImageView!)
    }
    override func funj_setBaseTableCellWithData(_ data: Any) {
        let model = data as? JPhotosDataModel
        let nameString = NSMutableAttributedString(string: model!.m_name ?? "", attributes: [NSAttributedString.Key.font : kFont_Size16 , NSAttributedString.Key.foregroundColor : kColor_Text_Black_Dark])
        let countStr = NSMutableAttributedString(string: String(format: "  (%d)", model!.m_count), attributes: [NSAttributedString.Key.font : kFont_Size16 , NSAttributedString.Key.foregroundColor : kColor_Text_GRAY_Dark])
        nameString.append(countStr)

        m_titleLabel?.attributedText = nameString
        
        JPhotoPickerInterface.funj_getPhotoWithAsset(phAsset: model?.m_fetchResult?.lastObject, deliveryMode: .fastFormat, width: 80) { [weak self](image, dic, isDegraded) in
            self?.m_imageView?.image = image
        }
        
    }
}
