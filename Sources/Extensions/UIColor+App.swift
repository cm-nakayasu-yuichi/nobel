//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UIColor {
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) {
        let rgba = [red, green, blue, alpha].map { i -> CGFloat in
            switch i {
            case let i where i < 0:
                return 0
            case let i where i > 255:
                return 1
            default:
                return CGFloat(i) / 255
            }
        }
        self.init(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
    }
    
    convenience init(rgb: Int) {
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >>  8) / 255.0
        let b = CGFloat( rgb & 0x0000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
//    convenience init(rgba: Int) {
//        let r: CGFloat = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
//        let g: CGFloat = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
//        let b: CGFloat = CGFloat((rgba & 0x0000FF00) >>  8) / 255.0
//        let a: CGFloat = CGFloat( rgba & 0x000000FF       ) / 255.0
//        self.init(red: r, green: g, blue: b, alpha: a)
//    }
    
    convenience init(rgbString: String) {
        var color: UInt32 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: rgbString.replacingOccurrences(of: "#", with: "")).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >>  8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension UIColor {
    
    var rgbString: String {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return [r, g, b].reduce("") { res, value in
            let intval = Int(round(value * 255))
            return res + (NSString(format: "%02X", intval) as String)
        }
    }
    
    var rgbaString: String {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b, a].reduce("") { res, value in
            let intval = Int(round(value * 255))
            return res + (NSString(format: "%02X", intval) as String)
        }
    }
    
    var redComponent: CGFloat {
        return components.red
    }
    
    var greenComponent: CGFloat {
        return components.green
    }
    
    var blueComponent: CGFloat {
        return components.blue
    }
    
    var alphaComponent: CGFloat {
        return components.alpha
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    
    func withRedComponent(_ red: CGFloat) -> UIColor {
        return withRGBAComponent(at: 0, value: red)
    }
    
    func withGreenComponent(_ green: CGFloat) -> UIColor {
        return withRGBAComponent(at: 1, value: green)
    }
    
    func withBlueComponent(_ blue: CGFloat) -> UIColor {
        return withRGBAComponent(at: 2, value: blue)
    }
    
    func withAlphaComponent(_ alpha: CGFloat) -> UIColor {
        return withRGBAComponent(at: 3, value: alpha)
    }
    
    private func withRGBAComponent(at index: Int, value: CGFloat) -> UIColor {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        var rgba = [r, g, b, a]
        rgba[index] = (value > 1) ? 1 : ((value < 0) ? 0 : value)
        return UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
    }
}

extension UIColor {
    
    var whiteness: CGFloat {
        var r: CGFloat = -1, g: CGFloat = -1, b: CGFloat = -1, a: CGFloat = -1
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (77 * r + 151 * g + 28 * b) / 255
    }
    
    var isWhiter: Bool {
        return whiteness >= 0.5
    }
}

extension UIColor {
    
    class var random: UIColor {
        let rgb = (0..<3).map { _ -> CGFloat in
            return CGFloat(arc4random_uniform(255)) / 255
        }
        return UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1.0)
    }
}
