//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// フォント種別
enum FontType: Int, DataManagableEnum {
    case standard
    case bold
    case gothic
    case gothicbold
    
    static var items: [FontType] = [
        .standard, .bold, .gothic,. gothicbold,
    ]
    
    /// フォント名
    var fontName: String {
        switch self {
        case .standard:   return "HiraMinProN-W3"
        case .bold:       return "HiraMinProN-W6"
        case .gothic:     return "HiraginoSans-W3"
        case .gothicbold: return "HiraginoSans-W6"
        }
    }
    
    /// 名称
    var name: String {
        switch self {
        case .standard:   return "明朝・標準"
        case .bold:       return "明朝・太字"
        case .gothic:     return "ゴシック・標準"
        case .gothicbold: return "ゴシック・太字"
        }
    }
    
    /// フォントを取得する
    /// - parameter textSize: 文字の大きさ
    /// - return: フォント
    func font(textSize: TextSize) -> UIFont {
        return UIFont(name: self.fontName, size: textSize.size)!
    }
    
    /// フォントを取得する
    /// - parameter point: 文字のポイント
    /// - return: フォント
    func font(point: CGFloat) -> UIFont {
        return UIFont(name: self.fontName, size: point)!
    }
}
