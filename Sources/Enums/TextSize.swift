//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 文字の大きさ
enum TextSize: Int, DataManagableEnum {
    case standard
    case large
    case larger
    case largest
    
    static var items: [TextSize] = [
        .standard, .large, .larger,. largest,
    ]
    
    /// 背景色
    var size: CGFloat {
        switch self {
        case .standard:  return 14.5
        case .large:     return 17
        case .larger:    return 20
        case .largest:   return 24
        }
    }
    
    /// 名称
    var name: String {
        switch self {
        case .standard: return "標準"
        case .large:    return "大きさ+1"
        case .larger:   return "大きさ+2"
        case .largest:  return "大きさ+3"
        }
    }
}
