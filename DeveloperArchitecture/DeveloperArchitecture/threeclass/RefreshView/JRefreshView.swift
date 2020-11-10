//
//  JRefreshView.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/4.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

let krefreshHeight :CGFloat = 70.0
let delayTime : TimeInterval = 1.0
private var kScrollViewModel = "kScrollViewModel"

typealias JRefreshHeadle = ((_ type : String,_ page : Int) -> ())

enum JRefreshState{
    case kRefreshStateNone
    case kRefreshStateBeganDrag       // 开始拉。
    case kRefreshStateDragEnd        //松手,开始加载。
    case kRefreshStateEnd        //回到原位，整个环节结束。
}

extension UIScrollView {
    func funj_addHeader(callback : @escaping JRefreshHeadle ) {
        if m_scrollViewModel.m_headView == nil {
            m_scrollViewModel.m_headView = JRefreshView(frame: CGRect(x: 0, y: -krefreshHeight, width: self.width, height: krefreshHeight))
            self.addSubview(m_scrollViewModel.m_headView!)
            m_scrollViewModel.m_headView?.m_isHead = true
            m_scrollViewModel.m_headView?.accessibilityLabel = "jrefresh"
            if m_scrollViewModel.m_isHasContentOffset == false {
                self.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
                m_scrollViewModel.m_isHasContentOffset = true
            }
        }
        m_scrollViewModel.m_headView?.m_refreshHeadle = callback
    }
    func funj_addFooter(callback : @escaping JRefreshHeadle ) {
        if m_scrollViewModel.m_footView == nil {
            m_scrollViewModel.m_footView = JRefreshView(frame:CGRect(x: 0, y: max(self.contentSize.height, self.height), width: self.width, height: krefreshHeight))
            self.addSubview(m_scrollViewModel.m_footView!)
            m_scrollViewModel.m_footView?.m_isHead = false
            m_scrollViewModel.m_footView?.accessibilityLabel = "jrefresh"
            self.addObserver(self, forKeyPath: "contentSize", options: [.old,.new], context: nil)
            if m_scrollViewModel.m_isHasContentOffset == false {
                self.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
                m_scrollViewModel.m_isHasContentOffset = true
            }
        }
        m_scrollViewModel.m_footView?.m_refreshHeadle = callback
    }
    func funj_stopRefresh() {
        self.funj_stopRefresh(m_scrollViewModel.m_headView)
        self.funj_stopRefresh(m_scrollViewModel.m_footView)
    }
    func funj_removeHeaderView() {
        m_scrollViewModel.m_headView?.removeFromSuperview()
        m_scrollViewModel.m_headView?.m_refreshHeadle = nil
        m_scrollViewModel.m_headView = nil
    }
    func funj_removeFooterView() {
        m_scrollViewModel.m_footView?.removeFromSuperview()
        m_scrollViewModel.m_footView?.m_refreshHeadle = nil
        m_scrollViewModel.m_footView = nil
    }
    func funj_startRefresh(refreshView : JRefreshView){
        refreshView.funj_addProgressAnimate()
        var page = m_scrollViewModel.m_refreshPageDic[m_scrollViewModel.m_currentPageType] ?? 1
        page = refreshView == m_scrollViewModel.m_headView ? 1 : page + 1
        m_scrollViewModel.m_refreshPageDic[m_scrollViewModel.m_currentPageType] = page
        refreshView.m_refreshHeadle?(m_scrollViewModel.m_currentPageType , page)
    }
    
    @objc func funj_stopRefresh(_ refreshView : JRefreshView?){
        if refreshView == nil { return }
        UIView.animate(withDuration: 0.5) {
            self.contentInset = UIEdgeInsetsZero
        }
        refreshView?.funj_stopProgressAnimate()
        refreshView?.m_state = .kRefreshStateEnd
    }
}

extension UIScrollView {
    private var m_scrollViewModel : JScrollViewModel {
        get {
            var scrollViewModel = objc_getAssociatedObject(self, &kScrollViewModel) as? JScrollViewModel
            if scrollViewModel == nil { scrollViewModel = JScrollViewModel()
                objc_setAssociatedObject(self, &kScrollViewModel, scrollViewModel!, .OBJC_ASSOCIATION_RETAIN) }
            return scrollViewModel! }
        set {objc_setAssociatedObject(self, &kScrollViewModel, newValue, .OBJC_ASSOCIATION_RETAIN)}}


    func funj_setCurrentPageType(_ type : String){
        m_scrollViewModel.m_currentPageType = type
        let page = m_scrollViewModel.m_refreshPageDic[type]
        if page == nil {
            funj_setPageWithType(type, page: 1)
        }
    }
    
    func funj_setPageWithType(_ type : String , page : Int){
        m_scrollViewModel.m_refreshPageDic[type] = page
    }
    func funj_getPage(_ type : String) -> Int{
        var page = m_scrollViewModel.m_refreshPageDic[type]
        if page == nil { m_scrollViewModel.m_refreshPageDic[type] = 1 ; page = 1}
        return page!
    }
    func funj_scrollViewDidScrollOffset(_ offsety : CGFloat ) {
        let maxOffsetY = abs(self.contentSize.height - self.height)
        let headView = offsety < 0 ? m_scrollViewModel.m_headView : (offsety > 0 && offsety > maxOffsetY - 30  ? m_scrollViewModel.m_footView : nil)
        if headView == nil { return }
        print("\(maxOffsetY) \(self.contentSize.height) \(self.height) \(offsety)")
        if self.isDragging {
            if headView?.m_state != .kRefreshStateBeganDrag {
                headView?.m_state = .kRefreshStateBeganDrag
                self.funj_startRefresh(refreshView: headView!)
            }
        } else if(self.isDragging == false && self.isDecelerating == true) {
            if headView?.m_state != .kRefreshStateDragEnd {
                headView?.m_state = .kRefreshStateDragEnd
                if offsety < -krefreshHeight - 2 {
                    UIView.animate(withDuration: 0.1) {[weak self] in
                        self?.contentInset = UIEdgeInsets(top: krefreshHeight, left: 0, bottom: 0, right: 0)
                    }
                } else if ( offsety > krefreshHeight + 2 + max(0, self.contentSize.height - self.height)){
                    UIView.animate(withDuration: 0.1) {[weak self] in
                        let s = (self?.contentSize.height ?? 0) - (self?.height ?? 0)
                        self?.contentInset = UIEdgeInsets(top: -(krefreshHeight + 2 + max(s , 0) ), left: 0, bottom: 0, right: 0)
                    }
                }
                self.perform(#selector(funj_stopRefresh(_:)), with: headView, afterDelay: delayTime)
            }
        }
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let point = change?[NSKeyValueChangeKey.newKey] as? CGPoint
            if point != nil {self.funj_scrollViewDidScrollOffset(point!.y)}
        } else if keyPath == "contentSize" {
            let size1 = change?[NSKeyValueChangeKey.oldKey] as? CGSize
            let size2 = change?[NSKeyValueChangeKey.newKey] as? CGSize

            if (size1?.width == size2?.width && size1?.height == size2?.height) {} else {
                m_scrollViewModel.m_footView?.frame = CGRect(x: 0, y: max(self.contentSize.height, self.height), width: self.width, height: 30)
            }
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        m_scrollViewModel.m_footView?.frame = CGRect(x: 0, y: max(self.contentSize.height, self.height), width: self.width, height: krefreshHeight)
        m_scrollViewModel.m_headView?.frame = CGRect(x: 0, y: m_scrollViewModel.m_headView?.top ?? 0, width: self.width, height: krefreshHeight)
    }
}
class JScrollViewModel : NSObject {
    lazy var m_refreshPageDic : [String : Int] = { return [:] }()
    var m_headView : JRefreshView?
    var m_footView : JRefreshView?
    var m_currentPageType : String = "default"
    var m_isHasContentOffset = false
}

class JRefreshView: JBaseView {
    lazy var m_arrowImageView : UIImageView = {
        let arrowImageView = UIImageView(i: CGRect(x: (frame.width - 30)/2, y: (frame.height - 30)/2, width: 30, height: 30), image: "reloading_fresh")
        self.addSubview(arrowImageView)
        return arrowImageView
    }()
    var m_arrowLabel : UILabel?
    var m_refreshHeadle : JRefreshHeadle?
    var m_isHead : Bool = false {
        willSet {if newValue == true {
            m_arrowLabel = UILabel(i: CGRect(x: m_arrowImageView.right + 10, y: m_arrowImageView.top, width: 0, height: m_arrowImageView.height), textFC: JTextFC(f: FONT_SIZE12, c: COLOR_TEXT_GRAY_DARK))
                self.addSubview(m_arrowLabel!)
        }}}
    var m_state : JRefreshState =  .kRefreshStateNone {
        willSet {
            if newValue == .kRefreshStateBeganDrag {
                m_arrowLabel?.text = m_isHead == true ? kLocalStr("Pull down to refresh") : kLocalStr("Pull up to load more")
            }else if newValue == .kRefreshStateDragEnd {
                m_arrowLabel?.text = kLocalStr("Refresh...")
            }else if newValue == .kRefreshStateEnd {
                m_arrowLabel?.text = kLocalStr("Refresh finished")
            }
            self.funj_reloadProgressViews()
        }
    }
    func funj_reloadProgressViews() {
        if m_arrowLabel != nil { m_arrowLabel?.width = JAppUtility.funj_getTextWidthWithView(m_arrowLabel!) }
        m_arrowImageView.left = (self.width - self.m_arrowImageView.width - 10 - (m_arrowLabel?.width ?? 0))/2
        m_arrowLabel?.left = m_arrowImageView.right + 10
    }
    func funj_addProgressAnimate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 0.7
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = HUGE
        m_arrowImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    func funj_stopProgressAnimate() {
        m_arrowImageView.layer.removeAllAnimations()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil && self.superview != nil {
            let scrollView = self.superview as? UIScrollView
            if self.accessibilityLabel != nil { return }
            self.accessibilityLabel = nil
            if self.m_isHead {
                scrollView?.removeObserver(self, forKeyPath:"contentOffset")
            }else {
                scrollView?.removeObserver(self, forKeyPath: "contentSize")
            }
        }
    }
}
