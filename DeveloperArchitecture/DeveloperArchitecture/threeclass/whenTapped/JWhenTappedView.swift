//
//  JWhenTappedView.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

private var kWhenTappedBlockKey = "WhenTappedBlockKey"
private var kWhenDoubleTappedBlockKey = "WhenDoubleTappedBlockKey"
private var kWhenLongPressedBlockKey = "WhenLongPressedBlockKey"
private var kWhenTouchedDownBlockKey = "WhenTouchedDownBlockKey"
private var kWhenTouchedUpBlockKey = "WhenTouchedUpBlockKey"

typealias JWhenTappedViewBlock = ((_ view : UIView)->())

extension UIView {
    func funj_whenTapped(_ block :@escaping JWhenTappedViewBlock){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(funj_viewWasTapped))
        self.addGestureRecognizer(gesture)
        self.m_whenTapped = block
    }
    func funj_whenDoubleTapped(_ block :@escaping JWhenTappedViewBlock){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(funj_viewWasDoubleTapped))
        gesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(gesture)
        self.m_whenDoubleTapped = block
    }
    func funj_whenLongPressed(_ block :@escaping JWhenTappedViewBlock){
        let gesture = UILongPressGestureRecognizer(target: self , action: #selector(funj_viewWasLongPressed))
        self.addGestureRecognizer(gesture)
        self.m_whenLongPressed = block
    }
    func funj_whenTouchedDown(_ block :@escaping JWhenTappedViewBlock){
        self.m_whenTouchedDown = block
    }
    func funj_whenTouchedUp(_ block :@escaping JWhenTappedViewBlock){
        self.m_whenTouchedUp = block
    }
}
extension UIView {
    var m_whenTapped : JWhenTappedViewBlock? {
        get { return objc_getAssociatedObject(self, &kWhenTappedBlockKey) as? JWhenTappedViewBlock }
        set {objc_setAssociatedObject(self, &kWhenTappedBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}}
    var m_whenDoubleTapped : JWhenTappedViewBlock? {
        get { return objc_getAssociatedObject(self, &kWhenDoubleTappedBlockKey) as? JWhenTappedViewBlock }
        set {objc_setAssociatedObject(self, &kWhenDoubleTappedBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}}
    var m_whenLongPressed : JWhenTappedViewBlock? {
        get { return objc_getAssociatedObject(self, &kWhenLongPressedBlockKey) as? JWhenTappedViewBlock }
        set {objc_setAssociatedObject(self, &kWhenLongPressedBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}}
    var m_whenTouchedDown : JWhenTappedViewBlock? {
        get { return objc_getAssociatedObject(self, &kWhenTouchedDownBlockKey) as? JWhenTappedViewBlock }
        set {objc_setAssociatedObject(self, &kWhenTouchedDownBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}}
    var m_whenTouchedUp : JWhenTappedViewBlock? {
        get { return objc_getAssociatedObject(self, &kWhenTouchedUpBlockKey) as? JWhenTappedViewBlock }
        set {objc_setAssociatedObject(self, &kWhenTouchedUpBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}}
    
    @objc func funj_viewWasTapped(){
        self.m_whenTapped?(self)
    }
    @objc func funj_viewWasDoubleTapped(){
        self.m_whenDoubleTapped?(self)
    }
    @objc func funj_viewWasLongPressed(){
        self.m_whenLongPressed?(self)
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.m_whenTouchedUp?(self)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.m_whenTouchedDown?(self)
    }
}
