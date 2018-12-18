//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import CoreGraphics

extension Int {
    
    /// 指定した範囲の中から乱数を取得する
    /// - Parameters:
    ///   - min: 最小値
    ///   - max: 最大値
    /// - Returns: 乱数
    static func random(min: Int, max: Int) -> Int {
        let n = min < 0 ? 0 : min
        let x = max + 1
        let v = UInt32(max < n ? 0 : x - n)
        let r = Int(arc4random_uniform(v))
        return n + r
    }
    
    /// 指定した範囲の中から乱数を取得する
    /// - Parameter range: 範囲
    /// - Returns: 乱数
    static func random(_ range: Range<Int>) -> Int {
        return random(min: range.lowerBound, max: range.upperBound)
    }
    
    /// 3桁区切りにフォーマットされた文字列
    var formatted: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.groupingSeparator = ","
        fmt.groupingSize = 3
        return fmt.string(from: NSNumber(integerLiteral: self)) ?? ""
    }
    
    /// 0埋めした文字列を取得する
    /// - Parameters:
    ///   - length: 必要な文字数
    ///   - prefix: 前方を0で埋める場合はtrue 後方を0で埋める場合はfalse
    /// - Returns: 0埋めした文字列
    func paddingZero(length: Int, prefix: Bool = true) -> String {
        return string.paddingZero(length: length, prefix: prefix)
    }
}

extension Bool {
    
    /// 自身の真偽を反転させる
    mutating func reverse() -> Bool {
        self = !self
        return self
    }
    
    /// 自身の真偽を反転させた値を返す
    var reversed: Bool {
        return !self
    }
}

extension CGFloat {
    
    /// Intにキャストした値
    var int: Int {
        return Int(self)
    }
    
    /// Floatにキャストした値
    var float: Float {
        return Float(self)
    }
    
    /// Doubleにキャストした値
    var double: Double {
        return Double(self)
    }
    
    /// 文字列にキャストした値
    var string: String {
        return "\(self)"
    }
    
    /// パーセンテージ (0未満は0, 1以上は1を返す)
    var percentage: CGFloat {
        if self <= 0 {
            return 0
        } else if 1 <= self {
            return 1
        } else {
            return self
        }
    }
    
    /// パーセンテージ用文字列を取得する
    /// - Parameters:
    ///   - place: 小数点位置
    ///   - rule: 丸めのルール
    ///   - unit: 単位
    /// - Returns: パーセンテージ用文字列
    func percentageString(place: UInt = 2, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero, unit: String = "%") -> String {
        let hundredfold = self.percentage * 100
        let multiple = pow(10, CGFloat(place))
        let rounded = (hundredfold * multiple).rounded(rule)
        let percentage = rounded / multiple
        if place == 0 {
            return "\(Int(percentage))\(unit)"
        } else {
            let format =  NSString(format: "%.\(place)f", arguments: getVaList([percentage]))
            return "\(format)\(unit)"
        }
    }
}

public extension Int {
    
    /// CGFloatにキャストした値
    var f: CGFloat { return CGFloat(self) }
    
    /// Floatにキャストした値
    var float: Float { return Float(self) }
    
    /// Doubleにキャストした値
    var double: Double { return Double(self) }
    
    /// 文字列にキャストした値
    var string: String { return "\(self)" }
}

public extension Float {
    
    /// CGFloatにキャストした値
    var f: CGFloat { return CGFloat(self) }
    
    /// Intにキャストした値
    var int: Int { return Int(self) }
    
    /// Doubleにキャストした値
    var double: Double { return Double(self) }
    
    /// 文字列にキャストした値
    var string: String { return "\(self)" }
}

public extension Double {
    
    /// CGFloatにキャストした値
    var f: CGFloat { return CGFloat(self) }
    
    /// Intにキャストした値
    var int: Int { return Int(self) }
    
    /// Floatにキャストした値
    var float: Float { return Float(self) }
    
    /// 文字列にキャストした値
    var string: String { return "\(self)" }
}
