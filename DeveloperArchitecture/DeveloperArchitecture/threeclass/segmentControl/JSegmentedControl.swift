//
//  JSegmentedControl.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/4.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
enum SegmentType : Int {
    case kSegmentTypeNone
    case kSegmentType5CornerRadius
    case kSegmentTypeAllCornerRadius
    case kSegmentTypeBottomLine
}
//typealias kalertBlockCallback = ((_ index :Int) -> ())

protocol JSegmentedControlDelegate {
    func funj_addStyleBgView(_ bgImageArray : [Any] ,textColor : [UIColor] , type : SegmentType)
    
    func funj_setSegmentSelectedIndex(_ index : Int)
}

class JSegmentedControl : JBaseView {
    var m_BgImageView : UIImageView?
    private var m_titleArray :[String]?
    private var m_alertCallback : kalertBlockCallback?
    private var m_TextColorArray : [UIColor]?
    private var m_type : SegmentType = .kSegmentTypeNone
    private var m_selectBgForBt : UIImageView?
    
    init(frame : CGRect ,titles : [String] ,callback :@escaping kalertBlockCallback){
        super.init(frame: frame)
        m_titleArray = titles
        m_alertCallback = callback
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func funj_addStyleBgView(_ bgImageArray : [Any] ,textColor : [UIColor] , type : SegmentType) {
        m_TextColorArray = textColor
        m_type = type
        if bgImageArray.count > 0 {
            if m_BgImageView == nil {
                m_BgImageView = UIImageView(i: self.bounds, image: nil)
                self.funj_setBgViewStyle(view: m_BgImageView!)
                m_BgImageView?.isUserInteractionEnabled = true
                self.addSubview(m_BgImageView!)
            }
        }
        if bgImageArray[0] is String {
            m_BgImageView?.alpha = 0.5
            m_BgImageView?.image = UIImage(named: bgImageArray[0] as! String)
        } else if bgImageArray[0] is UIColor{
            m_BgImageView?.backgroundColor = bgImageArray[0] as? UIColor
        }
        if bgImageArray.count > 1 {
            if m_selectBgForBt == nil {
                m_selectBgForBt = UIImageView(i: CGRect(x: 1, y: 1, width: self.width / CGFloat(m_titleArray!.count) - 2, height: self.height - 2), image: nil)
                self.addSubview(m_selectBgForBt!)
                self.funj_setBgViewStyle(view: m_selectBgForBt!)
            }
            if bgImageArray[1] is String {
                m_selectBgForBt?.image = UIImage(named: bgImageArray[1] as! String)
            }else {
                m_selectBgForBt?.backgroundColor = bgImageArray[1] as? UIColor
            }
        }
        funj_addSegBgView()
    }
    func funj_setBgViewStyle(view : UIView) {
        let cornerArr : [CGFloat]  = [0 , 5 , view.height / 2 , 0]
        if m_type == .kSegmentTypeBottomLine && view == m_selectBgForBt {
            view.top = view.bottom ;view.height = 1
        } else {
            view.layer.cornerRadius = cornerArr[m_type.rawValue]
            view.layer.masksToBounds = true
        }
    }
    func funj_addSegBgView() {
        let width = self.width / CGFloat(m_titleArray!.count)
        for i in 0..<m_titleArray!.count  {
            let itemBt = UIButton(i: CGRect(x: width * CGFloat(i), y: 0, width: width, height: self.height), title: m_titleArray?[i], textFC: JTextFC(f: kFont_Size17, c: m_TextColorArray![0] , sc: m_TextColorArray![1]))
                .funj_add(targe: self, action: "funj_selectItemTo:", tag: i + 30 )
            self.addSubview(itemBt)
            itemBt.titleLabel?.adjustsFontSizeToFitWidth = true
            _ = itemBt.funj_add(autoSelect: false)
        }
        self.funj_setSegmentSelectedIndex(0)
    }
    @objc func funj_selectItemTo(_ sender : UIButton){
        for i in 0..<4 {
            let but = self.viewWithTag(i + 30) as? UIButton
            but?.isSelected = false
        }
        sender.isSelected = false
        if m_type == .kSegmentTypeBottomLine {
            m_selectBgForBt?.width = JAppUtility.funj_getTextWidthWithView(sender)
        }
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.m_selectBgForBt?.center = CGPoint(x: sender.center.x, y: self?.m_selectBgForBt?.center.y ?? 0)
        } completion: { [weak self] (finish) in
            self?.m_alertCallback?(sender.tag - 30)
        }
    }
    func funj_setSegmentSelectedIndex(_ index : Int){
        let index1 = index % 4
        for button in self.subviews {
            if button is UIButton {
                (button as? UIButton)?.isSelected = (index1 + 30 == button.tag)
                if (button as? UIButton)?.isSelected == true {
                    if m_type == .kSegmentTypeBottomLine {
                        m_selectBgForBt?.width = JAppUtility.funj_getTextWidthWithView(button)
                    }
                    m_selectBgForBt?.center = CGPoint(x: button.center.x, y: m_selectBgForBt?.center.y ?? 0)
                }
            }
        }
    }
}
