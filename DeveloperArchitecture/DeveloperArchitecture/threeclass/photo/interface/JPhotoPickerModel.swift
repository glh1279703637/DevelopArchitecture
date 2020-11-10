//
//  JPhotoPickerModel.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import Photos

typealias kselectPhotoCallback = ((_ imageOrVideoArr : [Any] , _ isVideo : Bool) -> ())
var photosConfig : JPhotosConfig?
class JPhotosConfig : NSObject {
    var m_currentIsVideo : Bool = false //是视频，还是图片
    var m_isMultiplePhotos : Bool = false //是否多选
    var m_maxCountPhotos : Int = 0  //最大多选数
    var m_selectCallback : kselectPhotoCallback?
    open class var shared: JPhotosConfig? {
        get {
            if photosConfig == nil {photosConfig = JPhotosConfig()}
            return photosConfig
        }
    }

    class func funj_deallocPhotoConfig() {
        photosConfig = nil
    }
}

class JPhotosDataModel : NSObject {
    var m_name :String? //相册名
    var m_count : Int = 0 //照片个数
    var m_fetchResult : PHFetchResult<PHAsset>?
}

class JPhotoPickerModel : NSObject {
    var m_asset : PHAsset?
    var m_isSelected : Bool = false
    var m_currentIsVideo : Bool = false
    var m_timeLength : String?
    var m_indexCount : Int = 0
    init(asset : PHAsset , isVideo : Bool , timeLenght : String?) {
        super.init()
        self.m_asset = asset
        self.m_currentIsVideo = isVideo
        self.m_timeLength = timeLenght
    }
}
