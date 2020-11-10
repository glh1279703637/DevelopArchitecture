//
//  JMainViewController.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/25.
//

import UIKit

var mprogressHUD1 : JMainViewController? = nil

@objcMembers
class JMainViewController: UIViewController {

    let indexArr : String? = "323"
    let indexArr2 : String? = "323"
    open class var shared1: JMainViewController {
        get {
            if mprogressHUD1 == nil {
                mprogressHUD1 = JMainViewController()
            }
            return mprogressHUD1!
        }
    }
    static let shared2 = JCoreDataManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic = ["nameStr" : "name","sexStr" : "M" , "ageInt" : "18"] as [String : Any]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            JMainPhotoPickerVC .funj_getPopoverPhotoPickerVC(self) { (vc , present) in
                
            }
        }
        let str = "1234567890asdfggjl"
//
//        let s = str.substring(to: 3)
//        let newStr1 = String(str[...3])
//
//        print(String(string[...3]))
//        print(String(string[3...5]))
        let a  = String(str[str.endIndex...])
        
        let b = String(str[Range(NSRange(location: 3, length: 3), in: str)!])
        let c = Range(NSRange(location: 3, length: 3), in: str)
        print(b)
//        let prefix = "://"
//        if path.hasPrefix(prefix) {
//            path = String(path[prefix.endIndex...])
//        }
        
        /*
         let newStr = String(str[..<index]) // = str.substring(to: index) In Swift 3

         let newStr = String(str[index...]) // = str.substring(from: index) In Swif 3

         let newStr = String(str[range]) // = str.substring(with: range) In Swift 3
         */
        var array = ["1","2","3","4","5","6","3",["5":3]] as [Any]

//        array.removeFirst(3)
//        array.removeLast(2)
//        array.removeAll(keepingCapacity: true)
//        array.remove
//        array.removeAll { (<#String#>) -> Bool in
//            <#code#>
//        }
        array.removeAll { (obj) -> Bool in
            if obj is [String : Any] {
                return true
            }
            return false
        }
        
        print(array)

    }
}
