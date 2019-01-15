/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - Int拡張 -
extension Int {
    
    /// 漢数字に変換する
    var kansuji: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: NSNumber(integerLiteral: self)) ?? ""
    }
}

