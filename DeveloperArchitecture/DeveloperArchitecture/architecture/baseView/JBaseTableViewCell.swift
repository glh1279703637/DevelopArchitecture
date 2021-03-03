//
//  JBaseTableViewCell.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

typealias kCallbackHeight = (_ idKey : String , _ height : CGFloat) ->()

class JBaseTableViewCell : UITableViewCell {
    var m_callback : kCallbackHeight?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kColor_Bg_Dark
        self.funj_addBaseTableSubView()
    }
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented")}
    
    func funj_addBaseTableSubView(){
//        self.contentView.addSubview(m_imageView)

    }
    func funj_setBaseTableCellWithData(_ data : Any){
        
    }
}
extension JBaseTableViewCell {
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if self.selectionStyle != .none {
            self.backgroundColor = highlighted ? kColor_Bg_Lightgray_Dark : kColor_Clear
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.selectionStyle != .none {
            self.backgroundColor = selected ? kColor_Bg_Lightgray_Dark : kColor_Clear
        }
    }
}
