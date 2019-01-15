//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// カラーテーマ
enum ColorTheme: Int, DataManagableEnum {
    case standard
    case secondhand
    case newspaper
    case limegreen
    case loveromance
    case night
    case sciencefiction
    case fluorescent
    case concrete
    
    static var items: [ColorTheme] = [
        .standard, .secondhand, .newspaper, .limegreen,. loveromance,
        .night, .sciencefiction, .fluorescent, .concrete
    ]
    
    /// 名称
    var name: String {
        switch self {
        case .standard:       return "標準"
        case .secondhand:     return "古書"
        case .newspaper:      return "ニュースペーパー"
        case .limegreen:      return "ライムグリーン"
        case .loveromance:    return "ラブロマンス"
        case .night:          return "夜"
        case .sciencefiction: return "SF"
        case .fluorescent:    return "蛍光"
        case .concrete:       return "コンクリート"
        }
    }
    
    /// 背景色
    var backgroundColor: UIColor {
        switch self {
        case .standard:       return UIColor(rgb: 0xFFFFFF)
        case .secondhand:     return UIColor(rgb: 0xEDE7D9)
        case .newspaper:      return UIColor(rgb: 0xEFF0EA)
        case .limegreen:      return UIColor(rgb: 0xEDFC6D)
        case .loveromance:    return UIColor(rgb: 0xFFF3FD)
        case .night:          return UIColor(rgb: 0x333333)
        case .sciencefiction: return UIColor(rgb: 0x000000)
        case .fluorescent:    return UIColor(rgb: 0x0A0813)
        case .concrete:       return UIColor(rgb: 0x333333)
        }
    }
    
    /// 文字色
    var textColor: UIColor {
        switch self {
        case .standard:       return UIColor(rgb: 0x333333)
        case .secondhand:     return UIColor(rgb: 0x392B1A)
        case .newspaper:      return UIColor(rgb: 0x272825)
        case .limegreen:      return UIColor(rgb: 0x738D39)
        case .loveromance:    return UIColor(rgb: 0xE71660)
        case .night:          return UIColor(rgb: 0x333333)
        case .sciencefiction: return UIColor(rgb: 0x48CFE7)
        case .fluorescent:    return UIColor(rgb: 0xAEEE4C)
        case .concrete:       return UIColor(rgb: 0x333333)
        }
    }
    
    /// スライダーのトラック色
    var sliderTrackColor: UIColor {
        switch self {
        case .standard:       return UIColor(rgb: 0xC4C4C4)
        case .secondhand:     return UIColor(rgb: 0xC4C4C4)
        case .newspaper:      return UIColor(rgb: 0x8E958D)
        case .limegreen:      return UIColor(rgb: 0x738D39)
        case .loveromance:    return UIColor(rgb: 0xF8BDD1)
        case .night:          return UIColor(rgb: 0x333333)
        case .sciencefiction: return UIColor(rgb: 0x708D92)
        case .fluorescent:    return UIColor(rgb: 0xAEEE4C)
        case .concrete:       return UIColor(rgb: 0x333333)
        }
    }
    
    /// スライダーのサム色
    var sliderThumbColor: UIColor {
        switch self {
        case .standard:       return UIColor(rgb: 0x767676)
        case .secondhand:     return UIColor(rgb: 0x9D8C78)
        case .newspaper:      return UIColor(rgb: 0x303E41)
        case .limegreen:      return UIColor(rgb: 0x738D39)
        case .loveromance:    return UIColor(rgb: 0xE880A5)
        case .night:          return UIColor(rgb: 0x333333)
        case .sciencefiction: return UIColor(rgb: 0x2A8092)
        case .fluorescent:    return UIColor(rgb: 0xAEEE4C)
        case .concrete:       return UIColor(rgb: 0x333333)
        }
    }
    
    /// UI設定
    enum UI {
        case light
        case dark
        case red
        
        /// ステータスバーのスタイル
        var statusBarStyle: UIStatusBarStyle {
            switch self {
            case .light:
                return .lightContent
            case .dark, .red:
                return .default
            }
        }
    }
    
    /// スライダーの色
    var ui: ColorTheme.UI {
        switch self {
        case .standard, .secondhand,.newspaper, .limegreen, .concrete:
            return .dark
        case .loveromance:
            return .red
        case .night, .sciencefiction, .fluorescent:
            return .light
        }
    }
}
