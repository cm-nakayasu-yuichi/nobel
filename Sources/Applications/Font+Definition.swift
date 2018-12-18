//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UIFont {
    
    static let navigationTitle = applicationBoldFont(size: 20)
    
    static let subhead = applicationFont(size: 16)
    static let subheadBold = applicationBoldFont(size: 16)
    
    static func applicationFont(size: CGFloat) -> UIFont {
        return UIFont(name: "ArialMT", size: size)!
    }
    
    static func applicationBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Arial-BoldMT", size: size)!
    }
}
