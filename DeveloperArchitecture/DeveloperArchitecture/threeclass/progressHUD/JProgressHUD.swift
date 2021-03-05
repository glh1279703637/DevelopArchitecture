//
//  JProgressHUD.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

protocol JProgressHUDExtApi {
    func funj_showProgressView(_ title : String?)
    
    func funj_stopProgressView()

}

class JProgressHUD: UIView ,JProgressHUDExtApi{
    private var progressBgImageView : UIImageView?
    private var progressImageView : UIImageView?
    
    lazy var m_titleLabel : UILabel = {
        let titleLabel = UILabel(i: CGRect(x: 0, y: 0, width: 0, height: 30), title: nil, textFC: JTextFC(f: kFont_Size17, c: kColor_Text_Black, a: .center))
        self.addSubview(titleLabel)
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        self.backgroundColor = kColor_Clear
        progressBgImageView = UIImageView(i: CGRect(x: (kWidth-202/2.5)/2, y: (kHeight-202/2.5)/2, width: 202/2.5, height: 202/2.5), image: "reloadProgress_center")
        self.addSubview(progressBgImageView!)
        progressImageView = UIImageView(i: CGRect(x: (progressBgImageView!.frame.size.width-188/2.5)/2, y: (progressBgImageView!.frame.size.height-188/2.5)/2, width: 188/2.5, height: 188/2.5), image: "reloadProgress_route")
        progressBgImageView?.addSubview(progressImageView!)
        self.tag = NSNotFound - 1
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(funj_stopProgressView))
        self.addGestureRecognizer(tapGest)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    func funj_addProgressAnimate() {
        let anima = CABasicAnimation(keyPath: "opacity")
        anima.fromValue = 0.3
        anima.toValue = 1.0
        anima.duration = 1.0
        progressBgImageView?.layer.add(anima, forKey: "opacityAniamtion")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 0.6
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = HUGE
        progressImageView?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func funj_showProgressView(_ title : String? = nil) {
        let supView = JAppViewTools.funj_getKeyWindow()
        let upProgressView = superview?.viewWithTag(NSNotFound - 1)
        (upProgressView as? JProgressHUD)?.funj_stopProgressView()
        self.frame = CGRect(x: 0,y: 0,width: kWidth,height: kHeight)
        progressBgImageView?.frame = CGRect(x: (kWidth-202/2.5)/2, y: (kHeight-202/2.5)/2, width: 202/2.5, height: 202/2.5)
        
        if title != nil {
            m_titleLabel.frame = CGRect(x: progressBgImageView!.frame.origin.x-20, y: progressBgImageView!.frame.size.height+progressBgImageView!.frame.origin.y, width: progressBgImageView!.frame.size.width+40, height: 30)
            m_titleLabel.text = title
        }
        supView?.addSubview(self)
        self.funj_addProgressAnimate()
    }

    @objc func funj_stopProgressView() {
        progressBgImageView?.layer .removeAllAnimations()
        progressImageView?.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
}
enum MprogressType {
    case kprogressType
    case kprogressType_OnlyText
}
var mprogressHUD : JMProgressHUD? = nil
class JMProgressHUD : UIView {
    var m_blackAlphaView : UIImageView?
    var m_progressType : MprogressType = .kprogressType
    var m_superView : UIView?
    var m_time : TimeInterval = 2
    var m_callback : kcompleteCallback?
    var m_timerIsStart : Bool = false
    
    lazy var m_titleLabel : UILabel = {
        let titleLabel = UILabel(i: CGRectZero, title: nil, textFC: JTextFC(f: kFont_Size15, c: kColor_White, a: .center))
        self.addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    lazy var m_timer : Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(funj_stopProgressAnimate), userInfo: nil, repeats: true)
        return timer
    }()
    lazy var m_activityView : UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityView)
        return activityView
    }()
    
    static let shared: JMProgressHUD = JMProgressHUD()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        funj_addblackView()
    }
    convenience init(superView : UIView , type : MprogressType) {
        self.init(frame : CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented")}

    func funj_reloadSuperView(superView : UIView ,type : MprogressType){
        m_progressType = type ; m_superView = superView
    }
    
    func funj_addblackView (){
        m_blackAlphaView = UIImageView(i: self.bounds, bg: kColor_Text_Black)
        .funj_addCornerLayer(JFilletValue(w: 0, r: 10, c: kColor_Clear))
        m_blackAlphaView?.alpha = 0.7
        self.addSubview(m_blackAlphaView!)
    }
    func funj_showProgressViews(title : String? , t time : TimeInterval = 2 ,complete : kcompleteCallback? = nil) {
        funj_stopProgressAnimate()
        m_timerIsStart = true
        m_timer.fireDate = Date.init(timeIntervalSinceNow: time)
        if m_progressType == .kprogressType {
            if title?.count ?? 0 > 0 && m_superView != nil {
                self.frame = CGRect(x: (m_superView!.width - 200 )/2, y: (m_superView!.height - 140 )/2, width: 200, height: 140)
                m_activityView.top = 30;
            } else {
                self.frame = CGRect(x: (m_superView!.width - 100 )/2, y: (m_superView!.height - 100 )/2, width: 100, height: 100)
                m_activityView.top = (self.height - m_activityView.height)/2;
            }
            if kcurrentUserInterfaceStyleModel == 2 /*UIUserInterfaceStyleDark*/ {
                m_activityView.style = .white
            }
            m_activityView.startAnimating()
            m_activityView.left = (self.width - m_activityView.width) / 2
        }
        m_titleLabel.isHidden = true
        if title?.count ?? 0 > 0 {
            m_titleLabel.isHidden = false
            _ = m_titleLabel.funj_updateAttributedText(title!)
            var top : CGFloat = 0.0
            if m_progressType == .kprogressType {
                top = m_activityView.bottom
            } else {
                var width = JAppUtility.funj_getTextWidthWithView(m_titleLabel) + 40
                if kis_IPad {
                    width = min(kWidth / 3 * 2, width)
                } else {
                    width = kWidth > kHeight ? min(kWidth / 3 * 2, width) : min(kWidth - 60 , width)
                }
                self.frame = CGRect(x: ((m_superView?.width ?? 0) - width) / 2, y: ((m_superView?.height ?? 0) - 70 ) / 2, width: width, height: 70)
            }
            m_titleLabel.frame = CGRect(x: 20, y: top, width: self.width - 40 , height: self.height - top)
        }
        m_time = time
        m_blackAlphaView?.frame = self.bounds
        m_superView?.addSubview(self)
        m_callback = complete
    }
    
    @objc private func funj_stopProgressAnimate() {
        if m_activityView.isAnimating { m_activityView.stopAnimating()}
        if m_timerIsStart && m_timer.isValid { m_timer.invalidate()}
        self.removeFromSuperview()
        m_callback?()
        m_callback = nil
    }
    deinit {
        if m_timer.isValid { m_timer.invalidate()}
    }
}
