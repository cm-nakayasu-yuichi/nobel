//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension CGFloat {
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func safeAreaTop(_ view: UIView) -> CGFloat {
        return view.safeAreaInsets.top
    }
    
    static func safeAreaBottom(_ view: UIView) -> CGFloat {
        return view.safeAreaInsets.bottom
    }
    
    static func safeAreaTop(_ viewController: UIViewController) -> CGFloat {
        return viewController.view.safeAreaInsets.top
    }
    
    static func safeAreaBottom(_ viewController: UIViewController) -> CGFloat {
        return viewController.view.safeAreaInsets.bottom
    }
}
