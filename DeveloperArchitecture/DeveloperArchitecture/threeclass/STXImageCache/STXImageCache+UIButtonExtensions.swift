//
//  STXImageCache+UIButtonExtensions.swift
//  STXImageCache
//
//  Created by Norbert Sroczyński on 07.02.2017.
//  Copyright © 2017 STX Next Sp. z o.o. All rights reserved.
//

import UIKit

extension STXImageCache where Base: Button {
    /**
     Get an image at URL.
     `STXCacheManager` will seek the image in memory and disk first.
     If not found, it will download the image at from given URL and cache it.
     
     - parameter url:               URL for the image
     - parameter placeholder:       An image that is used during downloading image
     - parameter forceRefresh:      A Boolean value indicating whether the operation should force refresh
     - parameter controlState:      The state that uses the specified image.
     - parameter renderingMode:     Determines how an image is rendered.
     - parameter progress:          Periodically informs about the download’s progress.
     - parameter completion:        Called when the whole retrieving process finished.
     
     - returns: A `STXImageOperation` task object. You can use this object to cancel the task.
    */
    @discardableResult
    public func image(atURL url: URL, placeholder: Image? = nil, forceRefresh: Bool = false, controlState: UIControl.State = .normal, renderingMode: UIImage.RenderingMode = .alwaysOriginal, progress: STXImageCacheProgress? = nil, completion: STXImageCacheCompletion? = nil) -> STXImageOperation {
        return image(atURL: url, forceRefresh: forceRefresh) { image, error in
            var image = image
            if let completion = completion {
                image = completion(image, error)
            }
            DispatchQueue.main.async {
                self.base.setImage(image?.withRenderingMode(renderingMode), for: controlState)
            }
        }
    }
    
    /**
     Get an image at URL.
     `STXCacheManager` will seek the image in memory and disk first.
     If not found, it will download the image at from given URL and cache it.
     
     - parameter url:               URL for the image
     - parameter placeholder:       An image that is used during downloading image
     - parameter forceRefresh:      A Boolean value indicating whether the operation should force refresh
     - parameter controlState:      The state that uses the specified image.
     - parameter renderingMode:     Determines how an image is rendered.
     - parameter progress:          Periodically informs about the download’s progress.
     - parameter completion:        Called when the whole retrieving process finished.
     
     - returns: A `STXImageOperation` task object. You can use this object to cancel the task.
    */
    @discardableResult
    public func backgroundImage(atURL url: URL, placeholder: Image? = nil, forceRefresh: Bool = false, controlState: UIControl.State = .normal, renderingMode: UIImage.RenderingMode = .alwaysOriginal, progress: STXImageCacheProgress? = nil, completion: STXImageCacheCompletion? = nil) -> STXImageOperation {
        return image(atURL: url, forceRefresh: forceRefresh) { image, error in
            var image = image
            if let completion = completion {
                image = completion(image, error)
            }
            DispatchQueue.main.async {
                self.base.setImage(image?.withRenderingMode(renderingMode), for: controlState)
            }
        }
    }
    
    private func image(atURL url: URL, placeholder: Image? = nil, forceRefresh: Bool, controlState: UIControl.State = .normal, renderingMode: UIImage.RenderingMode = .alwaysOriginal, progress: STXImageCacheProgress? = nil, completion: @escaping (Image?, NSError?) -> ()) -> STXImageOperation {
        if let placeholderImage = placeholder {
            self.base.setImage(placeholderImage.withRenderingMode(renderingMode), for: controlState)
        }
        return STXCacheManager.shared.image(atURL: url, forceRefresh: forceRefresh, progress: progress) { data, error in
            var image: Image?
            
            guard let sourceData = data else { return  }
            guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil) else {
                return
            }
            let count = CGImageSourceGetCount(source)
            if count <= 1 {
                image = Image(data: data!)
            } else {
                var animatedImages: Array<UIImage> = []
                var duration: TimeInterval = 0.0;
                
                for i in 0 ..< count {
                    guard let cgimage = CGImageSourceCreateImageAtIndex(source, i, nil) else {  continue }
                    var subDuration = xm_frameDurationAtIndex(index: i, source: source)

                    if subDuration < 0.011 {
                        subDuration = 0.1
                    }
                    duration = duration + subDuration
                    let image = UIImage.init(cgImage: cgimage, scale: UIScreen.main.scale, orientation: .up)
                    animatedImages.append(image)
                }
                image = UIImage.animatedImage(with: animatedImages, duration: duration)
            }

            completion(image, error)
        }
    }
    func xm_frameDurationAtIndex(index: Int, source: CGImageSource)  -> TimeInterval {
        guard let dict = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? Dictionary<AnyHashable, Any> else {
            return 0.1
        }
        guard let gifProperties = dict[kCGImagePropertyGIFDictionary] as? Dictionary<AnyHashable, Any> else {
            return 0.1
        }
        guard let delayTimeUnclampedProp = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval else {
            guard let delayTimeProp = gifProperties[kCGImagePropertyGIFDelayTime] as? TimeInterval else {
                return 0.1
            }
            return delayTimeProp
        }
        return delayTimeUnclampedProp
    }
}
extension UIButton {
    func funj_setInternetImage(_ url : String ,placeholder : String?) {
        funj_setInternetImage(url, placeholder: placeholder, callback: nil)
    }
    func funj_setInternetImage(_ url : String ,placeholder : String? ,callback : STXImageCacheCompletion?) {
        guard let url = URL(string: url) else { return  }//be safe
        
        self.stx.image(atURL: url, placeholder:  placeholder != nil ? UIImage(named: placeholder!) : nil , forceRefresh: false, controlState: .normal, renderingMode: UIImage.RenderingMode.automatic, progress: nil, completion: callback)
    }
    
    func funj_setInternetBgImage(_ url : String ,placeholder : String?) {
        funj_setInternetBgImage(url, placeholder: placeholder, callback: nil)
    }
    func funj_setInternetBgImage(_ url : String ,placeholder : String? ,callback : STXImageCacheCompletion?) {
        guard let url = URL(string: url) else { return  }//be safe
        
        self.stx.backgroundImage(atURL: url, placeholder:  placeholder != nil ? UIImage(named: placeholder!) : nil , forceRefresh: false, controlState: .normal, renderingMode: UIImage.RenderingMode.automatic, progress: nil, completion: callback)
    }
}
