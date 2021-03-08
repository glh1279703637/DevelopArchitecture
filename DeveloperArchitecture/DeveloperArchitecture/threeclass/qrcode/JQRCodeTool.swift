//
//  JQRCodeTool.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/12.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit

protocol JQRCodeToolExtApi {
    //生成一张普通的二维码
    static func funj_generateDefaultQRCode(_ content : String) -> UIImage?
    
    //生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同）
    static func funj_generateLogoQRCode(_ content : String ,image : String ,  scale logoScaleToSuperView : CGFloat) -> UIImage?
    
    //生成一张彩色的二维码
    static func funj_generateDefaultQRCode(_ content : String , bgColor : CIColor , mainColor : CIColor) -> UIImage?
    
}

class JQRCodeTool : NSObject , JQRCodeToolExtApi{
    
    //生成一张普通的二维码
    class func funj_generateDefaultQRCode(_ content : String) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = content.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("L", forKey: "inputCorrectionLevel") //L 7%,M 15% Q 25% H 35%
        let outImage = filter?.outputImage
        return outImage != nil ? UIImage(ciImage: outImage!) : nil
    }
    //生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同）
    class func funj_generateLogoQRCode(_ content : String ,image : String ,  scale logoScaleToSuperView : CGFloat) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = content.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("L", forKey: "inputCorrectionLevel") //L 7%,M 15% Q 25% H 35%
        var outImage = filter?.outputImage
        
        // 图片小于(27,27),我们需要放大
        outImage = outImage?.transformed(by: CGAffineTransform(scaleX: 20, y: 20))
        //将CIImage类型转成UIImage类型
        let startImage = UIImage(ciImage: outImage!)
        UIGraphicsBeginImageContext(startImage.size)
        startImage.draw(in: CGRect(x: 0, y: 0, width: startImage.size.width, height: startImage.size.height))
        let iconImage = UIImage(named: image)
        let icon_w = startImage.size.width * logoScaleToSuperView ; let icon_h = startImage.size.height * logoScaleToSuperView
        let icon_x = (startImage.size.width - icon_w) * 0.5 ; let icon_y = (startImage.size.height - icon_h) * 0.5
        iconImage?.draw(in: CGRect(x: icon_x, y: icon_y, width: icon_w, height: icon_h))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    //生成一张彩色的二维码
    class func funj_generateDefaultQRCode(_ content : String , bgColor : CIColor , mainColor : CIColor) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = content.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("L", forKey: "inputCorrectionLevel") //L 7%,M 15% Q 25% H 35%
        var outImage = filter?.outputImage
        outImage = outImage?.transformed(by: CGAffineTransform(scaleX: 9, y: 9))
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(outImage, forKey: "inputImage")
        colorFilter?.setValue(bgColor, forKey: "inputColor0")
        colorFilter?.setValue(mainColor, forKey: "inputColor1")
        let colorImage = colorFilter?.outputImage
        return colorImage != nil ? UIImage(ciImage: colorImage!) : nil
    }
}
