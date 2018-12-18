//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UIApplication {
    
    /// 現在最も上層にいる(表示中の)ビューコントローラ
    var topViewController: UIViewController? {
        var vc: UIViewController? = keyWindow?.rootViewController
        while vc?.presentedViewController != nil {
            vc = vc!.presentedViewController!
        }
        while vc as? UINavigationController != nil {
            let nvc = vc as! UINavigationController
            vc = nvc.topViewController
        }
        while vc as? UITabBarController != nil {
            let tvc = vc as! UITabBarController
            vc = tvc.selectedViewController
        }
        return vc
    }
}
