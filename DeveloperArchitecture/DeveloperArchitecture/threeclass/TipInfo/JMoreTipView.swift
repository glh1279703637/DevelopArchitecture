//
//  JMoreTipView.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/4.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
enum TipPointPostion {
    case kshowLeftPostion
    case kshowTopPostion
    case kshowRightPostion
    case kshowBottomPostion
}

class JMoreTipView : JBaseView {
    private var m_tipType : TipPointPostion?
    private var m_tipPoint : CGPoint?
    
    class func funj_addMainBottomSwipeView(superView : UIView) {
//        if (UserDefaults.standard.object(forKey: "funj_addMainBottomSwipeView") != nil) { return }
        
        UserDefaults.standard.set("", forKey: "funj_addMainBottomSwipeView")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let moreTip = JMoreTipView(title: "上滑查看更多课程", superV: superView)
            moreTip.funj_reloadType(type: .kshowTopPostion, tipPoint: CGPoint(x: kWidth / 2, y: kHeight - 50 - 70), offset: 0)
//            moreTip.funj_addAutoHiddenViews()
        }
    }
    init(title : String , superV : UIView) {
        let size = JAppUtility.funj_getTextW_Height(title, textFont: kFont_Size14, layoutwidth: CGFloat(MAXFLOAT), layoutheight: 60)
        let frame = CGRect(x: 0, y: 0, width: size.width + 50, height: 60)
        super.init(frame: frame)
        let titleLabel = UILabel(i: CGRect(x: 10, y: 10, width: size.width + 30, height: 40), title: title, textFC: JTextFC(f: kFont_Size14, c: kColor_White, a: .center))
        self.addSubview(titleLabel)
        superV.addSubview(self)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    func funj_reloadType(type : TipPointPostion , tipPoint : CGPoint , offset : CGFloat){
        m_tipType = type
        var point : CGPoint = CGPoint(x: 0, y: 0) ; var point2 : CGPoint = CGPoint(x: 0, y: 0)
        if m_tipType == .kshowTopPostion || m_tipType == .kshowBottomPostion {
            point2.x = offset
            point.x = tipPoint.x - self.width / 2
            point.y = tipPoint.y - (m_tipType == .kshowBottomPostion ? 1 : 0) * self.height
            if point.x < 10 { point.x = 10}
            if point.x + self.width > (self.superview?.width ?? 0) - 10 {
                point.x = (self.superview?.width ?? 0) - 10 - self.width
            }
        }else {
            point2.y = offset
            point.x = tipPoint.x - (self.m_tipType == .kshowRightPostion ? 1 : 0) * self.width
            point.y = tipPoint.y - self.height / 2
            if point.y < 10 { point.y = 10}
            if point.y + self.height > (self.superview?.height ?? 0) - 10 {
                point.y = (self.superview?.height ?? 0) - 10 - self.height
            }
        }
        self.m_tipPoint = CGPoint(x: tipPoint.x - point.x + point2.x, y: tipPoint.y - point.y + point2.y)
        let frame = CGRect(x: point.x, y: point.y, width: self.width, height: self.height)
        self.frame = frame
        self.funj_shakeAnimationForView()
    }
    func funj_addAutoHiddenViews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            self.removeFromSuperview()
        }
    }
    func funj_shakeAnimationForView() {
        JAppUtility.funj_shakeAnimationForView(self, offset: CGSize(width: 0, height: 10))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            self.funj_shakeAnimationForView()
        }
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 15))
        path.addQuadCurve(to: CGPoint(x: 15, y: 10), controlPoint: CGPoint(x: 10, y: 10))
       
        if self.m_tipType == .kshowTopPostion && self.m_tipPoint != nil{ // 上边
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x - 10, y: 10))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x, y: self.m_tipPoint!.y))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x + 10, y: 10))
        }
        path.addLine(to: CGPoint(x: self.width - 15, y: 10))
        path.addQuadCurve(to: CGPoint(x: self.width - 10, y: 15), controlPoint: CGPoint(x: self.width - 10, y: 10))
        
        if self.m_tipType == .kshowRightPostion && self.m_tipPoint != nil { //右边
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x - 10, y: self.m_tipPoint!.y - 10))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x, y: self.m_tipPoint!.y))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x - 10, y: self.m_tipPoint!.y + 10))
        }
        path.addLine(to: CGPoint(x: self.width - 10, y: self.height - 15))
        path.addQuadCurve(to: CGPoint(x: self.width - 15, y: self.height - 10), controlPoint: CGPoint(x: self.width - 10, y: self.height - 10))
        
        if self.m_tipType == .kshowBottomPostion && self.m_tipPoint != nil { //下边
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x + 10, y: self.height - 10))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x, y: self.m_tipPoint!.y))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x - 10, y: self.height + 10))
        }
        path.addLine(to: CGPoint(x: 15, y: self.height - 10))
        path.addQuadCurve(to: CGPoint(x: 10, y: self.height - 15), controlPoint: CGPoint(x: 10, y: self.height - 10))
        
        if self.m_tipType == .kshowLeftPostion && self.m_tipPoint != nil { //左边
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x + 10, y: self.m_tipPoint!.y + 10))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x, y: self.m_tipPoint!.y))
            path.addLine(to: CGPoint(x: self.m_tipPoint!.x + 10, y: self.m_tipPoint!.y - 10))
        }
        path.close() ; path.fill()
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        self.layer.mask = lineLayer
    }
    
}
