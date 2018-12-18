//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UIView {
    
    @IBInspectable var corner: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var border: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    
    class func instantiate<T>(_ type: T.Type) -> T where T: UIView {
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        let nib = UINib(nibName: className, bundle: nil)
        if let view = nib.instantiate(withOwner: nil, options: nil).first as? T {
            return view
        } else {
            fatalError("can not instantiate. \(className)")
        }
    }
    
    var parent: UIView? {
        get {
            return superview
        }
        set {
            if let view = newValue {
                view.addSubview(self)
            } else {
                removeFromSuperview()
            }
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIView {
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            var r = frame
            r.size = newValue
            frame = r
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var r = frame
            r.origin = newValue
            frame = r
        }
    }
    
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            var r = frame
            r.size.width = newValue
            frame = r
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            var r = frame
            r.size.height = newValue
            frame = r
        }
    }
    
    var x: CGFloat {
        get {
            return frame.minX
        }
        set {
            var r = frame
            r.origin.x = newValue
            frame = r
        }
    }
    
    var y: CGFloat {
        get {
            return frame.minY
        }
        set {
            var r = frame
            r.origin.y = newValue
            frame = r
        }
    }
}

extension UIView {
    
    func dropShadowBottom(color: UIColor = .black, offset: CGFloat = 5, opacity: Float = 0.07, radius: CGFloat = 2) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: offset)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func dropShadowTop(color: UIColor = .black, offset: CGFloat = 2, opacity: Float = 0.14, radius: CGFloat = 2) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -offset)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

extension CALayer {
    
    var borderUIColor: UIColor? {
        get {
            return UIColor(cgColor: borderColor!)
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}

