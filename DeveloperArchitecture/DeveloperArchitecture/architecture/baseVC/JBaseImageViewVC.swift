//
//  JBaseImageViewVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import Photos
import CoreServices

class JBaseImageViewVC : JBaseViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate ,JMainPhotoPickerVCDelegate {
    
//    var m_cropFrame : CGRect = CGRect(x: 0, y: (kHeight - kWidth)/2, width: kWidth, height: kWidth)
    var m_currentIsLoadMultPhoto : Bool = false //当前是否支持上传多张图片
    var m_currentCanSelectMaxImageCount :Int = 10  //最多支持上传多少张图片
    
    func funj_editPortraitImageView(_ sender : UIButton) {
        self.view.endEditing(true)
        
        if self.m_currentCanSelectMaxImageCount <= 0 {
            _ = JAppViewTools.funj_showAlertBlock(message: "The number of images has reached the maximum limit")
            return
        }
        JAppViewTools.funj_showSheetBlock(sender, title: kLocalStr("Choose photos"), buttonArr: [kLocalStr("Photo"),kLocalStr("Select from album")]) { [weak self](index) in
            if index == 0 {// 拍照
                let status = JPhotoPickerInterface.funj_authorizationStatusAuthorized()
                if status.rawValue < 3 {
                    _ = JAppViewTools.funj_showAlertBlock(nil, message: "Please set APP to access your camera \nSettings> Privacy> Camera", buttonArr: [kLocalStr("Confirm")]) { (index) in
                        let url = URL(string: UIApplication.openSettingsURLString)
                        UIApplication.shared.open(url!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
                        self?.funj_clickBackButton()
                    }
                } else {
                    self?.funj_recallSystemCameraOrPhotoLabrary(type: .camera)
                }
            } else { // 从相册中选取
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && self != nil {
                    JMainPhotoPickerVC.funj_getPopoverPhotoPickerVC(self!) { (vc, isPresent) in
                        (vc as? JMainPhotoPickerVC)?.funj_reloadDefaultItems(isVideo: false, isMulti: self!.m_currentIsLoadMultPhoto, maxPhotos: self!.m_currentCanSelectMaxImageCount)
                    }
                }
            }
        }
    }
    func funj_recallSystemCameraOrPhotoLabrary(type : UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.sourceType = type
        if type == .camera  {
            controller.cameraDevice = .rear
        }
        controller.mediaTypes = [kUTTypeImage as String]
        controller.delegate = self
        if type == .photoLibrary {
            controller.modalPresentationStyle = .popover
            controller.preferredContentSize = CGSize(width: self.view.width, height: self.view.height)
            let popver = controller.popoverPresentationController
            popver?.sourceRect = self.view.bounds
            popver?.sourceView = self.view
            popver?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popver?.delegate = self
        }
        self.present(controller, animated: true, completion: nil)
    }
}
extension JBaseImageViewVC {
    func funj_selectPhotosFinishToCallback(_ imageOrVideoArr: [Any], isVideo: Bool) {
        if isVideo {
            Cprint("-- -- \(imageOrVideoArr)")
        }else {
            if self.m_currentIsLoadMultPhoto == false && imageOrVideoArr.count > 0 {
                
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage]
            if image == nil { return }
            let saveCurrentIsMult = self.m_currentIsLoadMultPhoto
            self.m_currentIsLoadMultPhoto = false
            self.funj_selectPhotosFinishToCallback([image!], isVideo: false)
            self.m_currentIsLoadMultPhoto = saveCurrentIsMult
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
