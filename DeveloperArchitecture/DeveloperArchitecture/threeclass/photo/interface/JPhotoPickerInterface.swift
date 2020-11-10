//
//  JPhotoPickerInterface.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/7.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
import Photos

typealias kPickImageCallback = ((_ imageArr : [JPhotosDataModel]) ->())
typealias kSelectPickImageCallback = ((_ image : UIImage? ,_ dic : [AnyHashable : Any]? , _ isDegraded : Bool) ->())
typealias kgetPickVideoCallback = ((_ video : AVPlayerItem? ,_ dic : [AnyHashable : Any]? ) ->())
typealias kgetPhotoBytesCallback = ((_ totalBytes : String) ->())



var kphotoPickerViewWidth : CGFloat { KWidth - 40 }
var kphotoPickerViewHeight : CGFloat { KHeight - KNavigationBarBottom - 60 }


class JPhotoPickerInterface : JBaseInterfaceManager {
    
    //返回1如果得到了授权  0:没有得到权限 1：得到，2受限制
    class func funj_authorizationStatusAuthorized() -> PHAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }
    
    class func funj_getAllAlbums(isVideo : Bool , callback :kPickImageCallback?) {
        var albumArr : [JPhotosDataModel] = []
        
        let option = PHFetchOptions()
        if isVideo == false {
            option.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        } else {
            option.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        }
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        for index in 0..<smartAlbums.count {
            let collection = smartAlbums[index] as PHAssetCollection
            let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
            if fetchResult.count < 1 { continue }
            
            if collection.assetCollectionSubtype.rawValue == 1000000201 || collection.assetCollectionSubtype == .smartAlbumAllHidden { continue }//最近删除的
            let model = self.funj_modelWithResult(result: fetchResult, name: collection.localizedTitle!)
            if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                albumArr.insert(model, at: 0)
            }else {
                albumArr.append(model)
            }
        }
        
        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        for index in 0..<albums.count {
            let collection = albums[index] as PHAssetCollection
            let fetchResult = PHAsset.fetchAssets(in: collection, options: option)
            if fetchResult.count < 1 { continue }
            
            let model = self.funj_modelWithResult(result: fetchResult, name: collection.localizedTitle!)
            albumArr.append(model)
        }
        if albumArr.count > 0 { callback?(albumArr)}
    }
    class func funj_getPhotoWithAsset(phAsset : PHAsset? , deliveryMode : PHImageRequestOptionsDeliveryMode , width : CGFloat ,callback : kSelectPickImageCallback?) {
        if phAsset == nil { return }
        let photoWidth = min( kphotoPickerViewWidth, width)
        let aspectRatio = CGFloat(phAsset!.pixelWidth) / CGFloat(phAsset!.pixelHeight)
        let multiple = UIScreen.main.scale
        var pixelWidth = photoWidth * multiple
        pixelWidth = min(CGFloat(phAsset!.pixelWidth), pixelWidth)
        let pixelHeight = pixelWidth / aspectRatio
        
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        if JPhotosConfig.shared?.m_currentIsVideo  == false {
            option.isSynchronous = true
        }
        option.resizeMode = deliveryMode == .highQualityFormat ? .exact : .fast
        option.deliveryMode = deliveryMode
        
        PHImageManager.default().requestImage(for: phAsset!, targetSize: CGSize(width: pixelWidth, height: pixelHeight), contentMode: .aspectFit, options: option) { (result, info) in
            let cancelKey = info?[PHImageCancelledKey] as? Bool ?? false
            let errorKey = info?[PHImageErrorKey] != nil

            let downloadFinined = !(cancelKey || errorKey )
            if downloadFinined && result != nil && callback != nil  {
                let isdegra = info?[PHImageResultIsDegradedKey] as? Bool
                callback?(result ,info ,isdegra ?? false)
            }
        }
    }
    class func funj_getVideoWithAsset(asset : PHAsset , callback : @escaping kgetPickVideoCallback) {
        let option = PHVideoRequestOptions()
        option.isNetworkAccessAllowed = true
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: option, resultHandler: callback)
    }
    class func funj_getPhotoBytesWithPhotoArray(photoArray : [JPhotoPickerModel] , callback : kgetPhotoBytesCallback?) {
        var dataLength = 0.0
        for model in photoArray {
            PHImageManager.default().requestImageData(for: model.m_asset!, options: nil) { (imageData, dataUTI, orientation, info) in
                if model.m_currentIsVideo == false {
                    dataLength += Double(imageData?.count ?? 0)
                }
            }
        }
        let bytes = funj_getBytesFromDataLength(dataLength: dataLength)
        callback?(bytes)
    }
    class func funj_getBytesFromDataLength(dataLength : Double ) -> String{
        var bytes = ""
        if (dataLength >= (0.1 * 1024 * 1024)) {
            bytes += String(format: "%.2fM", dataLength / 1024 / 1024 )
        }else if(dataLength >= 1024 ){
            bytes += String(format: "%.0fK", dataLength / 1024)
        }else {
            bytes += String(format: "%.0fB", dataLength)
        }
        return bytes
    }
}

extension JPhotoPickerInterface {
     class func funj_modelWithResult(result : PHFetchResult<PHAsset> , name : String) -> JPhotosDataModel{
        let model  = JPhotosDataModel()
        model.m_fetchResult = result
        model.m_name = name
        model.m_count = result.count
        return model
    }
    class func funj_addConfigSubView(_ vc : UIViewController) {
        let backBt = vc.navigationItem.leftBarButtonItems?.first?.customView as? UIButton
        backBt?.setImage(UIImage(named: "backBt2"), for: .normal)
        _ = backBt?.funj_updateContentImage(layout: .kLEFT_CONTENTIMAGE, a: JAlignValue(h: 0, s: 0, f: 0))
    }
}
