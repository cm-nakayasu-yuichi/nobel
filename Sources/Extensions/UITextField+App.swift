//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            var range = NSMakeRange(0, 1)
            guard
                let placeholder = attributedPlaceholder,
                let ret = placeholder.attribute(.foregroundColor, at: 0, effectiveRange: &range) as? UIColor
                else {
                    return nil
            }
            return ret
        }
        set {
            guard
                let color = newValue,
                let font = font,
                let text = placeholder
                else {
                    return
            }
            attributedPlaceholder = NSAttributedString(string: text, attributes: [
                .foregroundColor : color,
                .font : font,
                ]
            )
        }
    }
    
    var textValue: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}
