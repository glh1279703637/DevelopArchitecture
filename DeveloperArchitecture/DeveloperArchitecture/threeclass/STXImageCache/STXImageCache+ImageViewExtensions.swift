//
//  STXImageCache+Extensions.swift
//  STXImageCache
//
//  Created by Norbert Sroczyński on 07.02.2017.
//  Copyright © 2017 STX Next Sp. z o.o. All rights reserved.
//

#if os(macOS)
    import AppKit
#elseif os(watchOS)
    import WatchKit
#else
    import UIKit
#endif

extension STXImageCache where Base: ImageView {
    /**
     Get an image at URL.
     `STXCacheManager` will seek the image in memory and disk first.
     If not found, it will download the image at from given URL and cache it.
     
     - parameter url:               URL for the image
     - parameter placeholder:       An image that is used during downloading image
     - parameter forceRefresh:      A Boolean value indicating whether the operation should force refresh
     - parameter progress:          Periodically informs about the download’s progress.
     - parameter completion:        Called when the whole retrieving process finished.
     
     - returns: A `STXImageOperation` task object. You can use this object to cancel the task.
    */
    @discardableResult
    public func image(atURL url: URL, placeholder: Image? = nil, forceRefresh: Bool = false, progress: STXImageCacheProgress? = nil, completion: STXImageCacheCompletion? = nil) -> STXImageOperation {
        if let placeholderImage = placeholder {
            self.setImage(image: placeholderImage)
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
            } else {/// jeffrey 添加动画功能
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

            if let completion = completion {
                image = completion(image, error)
            }
            DispatchQueue.main.async {
                self.setImage(image: image)
            }
        }
    }
    
    private func setImage(image: Image?) {
#if os(watchOS)
        self.base.setImage(image)
#else
        self.base.image = image
#endif
    }
    /// jeffrey
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
/// jeffrey
extension UIImageView {
    func funj_setInternetImage(_ url : String ,placeholder : String?) {
        funj_setInternetImage(url, placeholder: placeholder, callback: nil)
    }
    func funj_setInternetImage(_ url : String ,placeholder : String? ,callback : STXImageCacheCompletion?) {
        guard let url1 = URL(string: funj_checkHttpUrl(url)) else { return  }//be safe
        
        self.stx.image(atURL: url1, placeholder: placeholder != nil ? UIImage(named: placeholder!) : nil , forceRefresh: false, progress: nil, completion: callback)
    }
}


func funj_checkHttpUrl(_ url : String?) -> String {
    if url == nil || url!.count <= 5 { return ""}
    if (url!.lowercased().hasPrefix("http://") || url!.lowercased().hasPrefix("https://")) == false { return ""}
    
    var url1 = url!
    if let s = url1.range(of: "|") , s.isEmpty == false {
         url1 = url1.replacingOccurrences(of: "|", with: "%7C")
    }
    if let s = url!.range(of: " ") , s.isEmpty == false {
         url1 = url1.replacingOccurrences(of: " ", with: "%20")
    }
    return url1
}
