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
        case .standard:       return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .secondhand:     return #colorLiteral(red: 0.9294117647, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
        case .newspaper:      return #colorLiteral(red: 0.937254902, green: 0.9411764706, blue: 0.9176470588, alpha: 1)
        case .limegreen:      return #colorLiteral(red: 0.9294117647, green: 0.9882352941, blue: 0.4274509804, alpha: 1)
        case .loveromance:    return #colorLiteral(red: 1, green: 0.9529411765, blue: 0.9921568627, alpha: 1)
        case .night:          return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .sciencefiction: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .fluorescent:    return #colorLiteral(red: 0.03921568627, green: 0.03137254902, blue: 0.07450980392, alpha: 1)
        case .concrete:       return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
    }
    
    /// 文字色
    var textColor: UIColor {
        switch self {
        case .standard:       return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .secondhand:     return #colorLiteral(red: 0.2235294118, green: 0.168627451, blue: 0.1019607843, alpha: 1)
        case .newspaper:      return #colorLiteral(red: 0.1529411765, green: 0.1568627451, blue: 0.1450980392, alpha: 1)
        case .limegreen:      return #colorLiteral(red: 0.4509803922, green: 0.5529411765, blue: 0.2235294118, alpha: 1)
        case .loveromance:    return #colorLiteral(red: 0.9058823529, green: 0.0862745098, blue: 0.3764705882, alpha: 1)
        case .night:          return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .sciencefiction: return #colorLiteral(red: 0.2823529412, green: 0.8117647059, blue: 0.9058823529, alpha: 1)
        case .fluorescent:    return #colorLiteral(red: 0.6823529412, green: 0.9333333333, blue: 0.2980392157, alpha: 1)
        case .concrete:       return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
    }
    
    /// スライダーのトラック色
    var sliderTrackColor: UIColor {
        switch self {
        case .standard:       return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        case .secondhand:     return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        case .newspaper:      return #colorLiteral(red: 0.5568627451, green: 0.5843137255, blue: 0.5529411765, alpha: 1)
        case .limegreen:      return #colorLiteral(red: 0.4509803922, green: 0.5529411765, blue: 0.2235294118, alpha: 1)
        case .loveromance:    return #colorLiteral(red: 0.9725490196, green: 0.7411764706, blue: 0.8196078431, alpha: 1)
        case .night:          return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .sciencefiction: return #colorLiteral(red: 0.4392156863, green: 0.5529411765, blue: 0.5725490196, alpha: 1)
        case .fluorescent:    return #colorLiteral(red: 0.6823529412, green: 0.9333333333, blue: 0.2980392157, alpha: 1)
        case .concrete:       return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
    }
    
    /// スライダーのサム色
    var sliderThumbColor: UIColor {
        switch self {
        case .standard:       return #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1)
        case .secondhand:     return #colorLiteral(red: 0.6156862745, green: 0.5490196078, blue: 0.4705882353, alpha: 1)
        case .newspaper:      return #colorLiteral(red: 0.1882352941, green: 0.2431372549, blue: 0.2549019608, alpha: 1)
        case .limegreen:      return #colorLiteral(red: 0.4509803922, green: 0.5529411765, blue: 0.2235294118, alpha: 1)
        case .loveromance:    return #colorLiteral(red: 0.9098039216, green: 0.5019607843, blue: 0.6470588235, alpha: 1)
        case .night:          return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .sciencefiction: return #colorLiteral(red: 0.1647058824, green: 0.5019607843, blue: 0.5725490196, alpha: 1)
        case .fluorescent:    return #colorLiteral(red: 0.6823529412, green: 0.9333333333, blue: 0.2980392157, alpha: 1)
        case .concrete:       return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
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
