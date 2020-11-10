//
//  JBaseNavigationVC.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/10/30.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import UIKit
enum kcurrentNavColor {
    case kCURRENTISNONE_TAG
    case kCURRENTISBLUENAV_TAG
    case kCURRENTISGRAYNAV_TAG
    case kCURRENTISWHITENAV_TAG
}

class JBaseNavigationVC : UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var m_currentNavColor : kcurrentNavColor = .kCURRENTISNONE_TAG {
        willSet {
            let bar = self.navigationBar
            switch newValue {
            case .kCURRENTISBLUENAV_TAG:
                bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : COLOR_WHITE , NSAttributedString.Key.font : FONT_BOLDSIZE20]
                self.navigationBar.barTintColor = COLOR_BLUE
                m_barBottomLine?.backgroundColor = COLOR_BLUE
            case .kCURRENTISGRAYNAV_TAG:
                bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : COLOR_TEXT_BLACK_DARK , NSAttributedString.Key.font : FONT_BOLDSIZE20]
                self.navigationBar.barTintColor = COLOR_WHITE_DARK
                m_barBottomLine?.backgroundColor = COLOR_LINE_GRAY_DARK
            case .kCURRENTISWHITENAV_TAG:
                let image = JAppUtility.funj_imageWithColor(COLOR_BG_LIGHTGRAY_DARK, size: CGSize(width: 1, height: 1))
                bar.setBackgroundImage(image, for: .default)
                bar.shadowImage = image
                bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : COLOR_TEXT_BLACK , NSAttributedString.Key.font : FONT_BOLDSIZE20]
                m_barBottomLine?.backgroundColor = COLOR_BG_LIGHTGRAY_DARK
            default:break
            }
        }
    }
    
    var m_barBottomLine : UIImageView?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        m_currentNavColor =  .kCURRENTISWHITENAV_TAG
        if (rootViewController is JBaseViewController) && (((rootViewController as? JBaseViewController)?.m_pushOrPresentAnimateClass) != nil) {
            self.transitioningDelegate = rootViewController as? UIViewControllerTransitioningDelegate
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation  增加右滑动返回手势
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        
        let bar = UINavigationBar.appearance()
        m_barBottomLine = UIImageView(CGRect(x: 0, y: bar.height, width: bar.width, height: 1), bgColor: COLOR_BLUE)
        bar.addSubview(m_barBottomLine!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.m_currentNavColor =
    }
}
extension JBaseNavigationVC {
    public override var prefersStatusBarHidden: Bool { //设置是否隐藏
        return self.viewControllers.last?.prefersStatusBarHidden ?? false
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.viewControllers.last?.preferredStatusBarStyle ?? .default
    }
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.viewControllers.last?.preferredStatusBarUpdateAnimation ?? .none
    }
    public override var shouldAutorotate: Bool {
        return self.viewControllers.last?.shouldAutorotate ?? true
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .all
    }
}
// 手势左滑 返回
extension JBaseNavigationVC {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: animated)
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (((viewController as? JBaseViewController)?.m_currentPushIsNeedinteractivePopGestureRecognizer) != nil) {
            if viewController == navigationController.viewControllers.first {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            } else {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let toVC = toVC as? JBaseViewController {
            if toVC.m_pushOrPresentAnimateClass != nil {
                let obj = toVC.m_pushOrPresentAnimateClass?.init()
                return obj
            }
        }
        return nil
    }
}
//extension JBaseNavigationVC {
//    //#pragma mark 主要作用是由于WKWebView 调用相册中浏览cloud 时，然后直接取消后对应的view出现basevc 也会跟着消失 可选，只wekbview 需要导入图片时需要启用此两方法
//    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//         self.viewControllers.last?.present(viewControllerToPresent, animated: flag, completion: completion)
//    }
//    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//        self.viewControllers.last?.dismiss(animated: flag, completion: completion)
//    }
//}

