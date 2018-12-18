//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UIButton {
    
    var title: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    var titleColor: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    var titleShadowColor: UIColor? {
        get {
            return titleShadowColor(for: .normal)
        }
        set {
            setTitleShadowColor(newValue, for: .normal)
        }
    }
    
    var image: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    var attributedTitle: NSAttributedString? {
        get {
            return attributedTitle(for: .normal)
        }
        set {
            setAttributedTitle(newValue, for: .normal)
        }
    }
    
    var backgroundImage: UIImage? {
        get {
            return backgroundImage(for: .normal)
        }
        set {
            setBackgroundImage(newValue, for: .normal)
        }
    }
    
    var highlightedTitle: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }
    
    var disabledTitle: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }
    
    var highlightedTitleColor: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }
    
    var disabledTitleColor: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
}
