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
        self.backgroundColor = COLOR_BG_DARK
        self.funj_addBaseTableSubView()
    }
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented")}
    
    func funj_addBaseTableSubView(){
//        self.contentView.addSubview(m_imageView)

    }
    func funj_setBaseTableCellWithData(_ data : Any){
        
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if self.selectionStyle != .none {
            self.backgroundColor = highlighted ? COLOR_BG_LIGHTGRAY_DARK : COLOR_CREAR
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.selectionStyle != .none {
            self.backgroundColor = selected ? COLOR_BG_LIGHTGRAY_DARK : COLOR_CREAR
        }
    }
}
