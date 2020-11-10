//
//  JBaseCollectionVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

class JBaseCollectionVC : JBaseTableViewVC ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    @objc lazy var m_collectionView : UICollectionView = {
        let collectionView =  kcreateCollectViewWithDelegate(self)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        m_defaultImageView.isHidden = (m_collectionView.visibleCells.count > 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(m_collectionView)
    }
}

extension JBaseCollectionVC {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.m_dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: KWidth, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIndentifier, for: indexPath)
        cell.backgroundColor = krandomColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = COLOR_WHITE_DARK
    }
}

extension JBaseCollectionVC {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//分别为上、左、下、右
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0) //特别注意 横向滚动时，这两个值可能相反 导致第一页空格页
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0) //特别注意 横向滚动时，这两个值可能相反 导致第一页空格页
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var resultIdentifier = "headsection"
        if kind == UICollectionView.elementKindSectionFooter {
            resultIdentifier = "footsection"
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: resultIdentifier, for: indexPath)
        return view
    }
}

extension JBaseCollectionVC {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.m_defaultImageView.isHidden = true
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

func kcreateCollectViewWithDelegate(_ delegate : AnyObject) -> UICollectionView {
    let flowlayout = JCollectionViewFlowLayout()
    flowlayout.minimumLineSpacing = 2
    flowlayout.minimumInteritemSpacing = 0
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: KWidth, height: KHeight), collectionViewLayout: flowlayout)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = (delegate as? UICollectionViewDelegate)
    collectionView.dataSource = (delegate as? UICollectionViewDataSource)
    collectionView.allowsSelection = true
    collectionView.backgroundColor = UIColor.clear
    collectionView.register(JBaseCollectionViewCell.self, forCellWithReuseIdentifier: kCellIndentifier)
    collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headsection")
    collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: "footsection")
    collectionView.alwaysBounceVertical = true
    if #available(iOS 11.0, *) {
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    return collectionView
}
