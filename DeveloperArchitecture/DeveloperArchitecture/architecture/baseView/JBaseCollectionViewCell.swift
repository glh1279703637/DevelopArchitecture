//
//  JBaseCollectionViewCell.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

class JBaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kColor_Bg_Dark
        self.funj_addBaseCollectionView()
    }
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented")}
    
    func funj_addBaseCollectionView(){
        
    }
    func funj_setBaseCollectionData(_ data : Any){
        
    }
}
