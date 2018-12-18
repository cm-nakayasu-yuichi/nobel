//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

@IBDesignable class Button: UIButton {
    
    enum Style: String {
        case primary
        case secondary
    }
    
    enum TextFontSize: String {
        case normal
        case thin
    }
    
    @IBInspectable var style: String = Style.primary.rawValue {
        didSet {
            titleLabel?.font = buttonTextFontSize.font
            
            backgroundColor = buttonStyle.backgroundColor
            tintColor = .clear
            titleColor = buttonStyle.textColor
            highlightedTitleColor = buttonStyle.textColor
            
            layer.borderColor = buttonStyle.borderColor.cgColor
            layer.borderWidth = (layer.borderColor != nil) ? 1.0 : 0.0
            layer.cornerRadius = 5.0
        }
    }
    
    @IBInspectable var textFontSize: String = TextFontSize.normal.rawValue {
        didSet {
            titleLabel?.font = (TextFontSize(rawValue: textFontSize) ?? .normal).font
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            backgroundColor = newValue ? buttonStyle.highlightedBackgroundColor : buttonStyle.backgroundColor
            layer.borderColor = newValue ? buttonStyle.borderColor.cgColor : buttonStyle.highlightedBorderColor.cgColor
        }
    }
    
    private var buttonStyle: Style {
        return Style(rawValue: style) ?? .primary
    }
    
    private var buttonTextFontSize: TextFontSize {
        return TextFontSize(rawValue: textFontSize) ?? .normal
    }
}

extension Button.Style {
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:   return .primaryButton
        case .secondary: return .clear
        }
    }
    
    var highlightedBackgroundColor: UIColor {
        switch self {
        case .primary:   return .primaryButtonHighlighted
        case .secondary: return .clearHighlighted
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .primary:   return .primaryButtonHighlighted
        case .secondary: return .primaryButton
        }
    }
    
    var highlightedBorderColor: UIColor {
        switch self {
        case .primary:   return .primaryButtonHighlighted
        case .secondary: return .primaryButton
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .primary:   return .white
        case .secondary: return .primaryButton
        }
    }
}

extension Button.TextFontSize {
    
    var font: UIFont {
        switch self {
        case .normal: return .subheadBold
        case .thin:   return .subhead
        }
    }
}
