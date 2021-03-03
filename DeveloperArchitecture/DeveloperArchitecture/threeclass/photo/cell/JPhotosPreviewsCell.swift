//
//  JPhotosPreviewsCell.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class JPhotosPreviewsCell : JBaseCollectionViewCell, UIScrollViewDelegate {
    var m_BgScrollView : UIScrollView?
    var m_imageView : UIImageView?
    var m_player : AVPlayer?
    var m_playerLayer : AVPlayerLayer?
    var m_playButton : UIButton?
    var m_dataModel : JPhotoPickerModel?
    
    override func funj_addBaseCollectionView() {
        m_imageView = UIImageView(i: self.bounds, image: nil)
        m_imageView?.contentMode = .scaleAspectFit
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            self.contentView.addSubview(m_imageView!)
            m_playButton = UIButton(i: self.bounds, title: nil, textFC: JTextFC())
                .funj_add(bgImageOrColor: ["MMVideoPreviewPlay"], isImage: true)
                .funj_add(targe: self, action: "funj_selectToPlay:", tag: 0)
                .funj_add(autoSelect: false)
        } else {
            m_BgScrollView = UIScrollView(i: self.bounds, delegate: nil)
            self.contentView.addSubview(m_BgScrollView!)
            m_BgScrollView!.bouncesZoom = true;
            m_BgScrollView!.maximumZoomScale = 2.5;
            m_BgScrollView!.minimumZoomScale = 1.0;
            m_BgScrollView!.isMultipleTouchEnabled = true;
            m_BgScrollView!.delegate = self;
            m_BgScrollView!.scrollsToTop = false;
            m_BgScrollView!.showsHorizontalScrollIndicator = false;
            m_BgScrollView!.showsVerticalScrollIndicator = false;
            m_BgScrollView!.delaysContentTouches = false;
            m_BgScrollView!.canCancelContentTouches = true;
            m_BgScrollView!.alwaysBounceVertical = false;
            m_BgScrollView?.addSubview(m_imageView!)
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return m_imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let width = scrollView.width
        let height = scrollView.height
        let offsetX = width > scrollView.contentSize.width ? (width - scrollView.contentSize.width ) * 0.5 : 0.0
        let offsetY = height > scrollView.contentSize.height ? (height - scrollView.contentSize.height) * 0.5 : 0.0
        m_imageView?.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    override func funj_setBaseCollectionData(_ data: Any) {
        m_dataModel = data as? JPhotoPickerModel
        m_BgScrollView?.setZoomScale(1.0, animated: false)
        JPhotoPickerInterface.funj_getPhotoWithAsset(phAsset: m_dataModel?.m_asset, deliveryMode: .opportunistic , width: m_imageView!.width) { [weak self] (image, dic, isDegraded) in
            self?.m_imageView?.image = image
        }
        self.funj_stopAllPlayer()
    }
    func funj_stopAllPlayer() {
        if JPhotosConfig.shared?.m_currentIsVideo ?? false {
            m_playerLayer?.removeFromSuperlayer()
            m_playerLayer = nil
            m_playButton?.setImage(UIImage(named: "MMVideoPreviewPlay"), for: .normal)
            m_imageView?.isHidden = false
            m_player?.pause()
            m_player = nil
        }
    }
    func funj_selectToPlay(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if m_playerLayer != nil {
                m_player?.play()
            }else {
                JPhotoPickerInterface.funj_getVideoWithAsset(asset: m_dataModel?.m_asset) { [weak self](item, dic) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
                        self?.m_player = AVPlayer(playerItem: item)
                        self?.m_playerLayer = AVPlayerLayer(player: self?.m_player)
                        self?.m_playerLayer?.frame = self?.bounds ?? CGRectZero
                        if self?.m_playerLayer != nil {self?.layer.insertSublayer(self!.m_playerLayer!, at: 0)}
                        self?.m_player?.play()
                        
                        self?.m_imageView?.isHidden = true
                        sender.setImage(nil, for: .normal)
                    }
                }
            }
        } else {
            self.funj_stopAllPlayer()
        }
        
    }
}
