/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - Array拡張 -
extension Array {
    
//    /// 配列の範囲内かどうかを返す
//    /// - parameter index: インデックス
//    /// - returns: 配列の範囲内かどうか
//    func inRange(at index: Int) -> Bool {
//        guard let firstIndex = self.firstIndex, let lastIndex = self.lastIndex else { return false }
//        return firstIndex <= index && index <= lastIndex
//    }
    
//    /// ループさせる場合の次の配列のインデックスを取得する
//    /// - parameter index: インデックス
//    /// - returns: 次のインデックス
//    func nextLoopIndex(of index: Int) -> Int {
//        guard let last = self.lastIndex else { return -1 }
//        if index + 1 > last {
//            return 0
//        } else {
//            return index + 1
//        }
//    }
    
//    /// ループさせる場合の前の配列のインデックスを取得する
//    /// - parameter index: インデックス
//    /// - returns: 前のインデックス
//    func previousLoopIndex(of index: Int) -> Int {
//        guard let last = self.lastIndex else { return -1 }
//        if index - 1 < 0 {
//            return last
//        } else {
//            return index - 1
//        }
//    }
    
    /// 入れ替え(移動)可能かどうかを返す
    /// - parameter from: 移動する元のインデックス
    /// - parameter to: 移動する先のインデックス
    /// - returns: 入れ替え(移動)可能かどうか
    @available(swift, deprecated: 4.1, renamed: "canExchange(from:to:)", message: "Please use canExchange(from:to:)")
    func isExchangable(from: Int, to: Int) -> Bool {
        return self.indices.contains(from) && self.indices.contains(to)
    }
    
//    /// 指定したインデックス同士を入れ替える
//    /// - parameter from: 移動する元のインデックス
//    /// - parameter to: 移動する先のインデックス
//    /// - returns: 入れ替え(移動)可能かどうか
//    mutating func exchange(from: Int, to: Int) -> Bool {
//        if !self.isExchangable(from: from, to: to) {
//            return false
//        }
//        let fromElement = self[from]
//        self.remove(at: from)
//        self.insert(fromElement, at: to)
//        return true
//    }
}

// MARK: - DataManagerIdentifiableEntity のための Array拡張 -
extension Array where Element : DataManagerIdentifiableEntity {
    
    /// IDから配列内の要素を取得する
    /// - parameter id: ID
    /// - returns: 要素
    func entityBy(id: String) -> Element? {
        for element in self {
            if id == element.id {
                return element
            }
        }
        return nil
    }
    
    /// インデックスから配列内の要素のIDを取得する
    /// - parameter index: インデックス
    /// - returns: 要素のID
    func entityID(at index: Int) -> String? {
        if self.inRange(at: index) {
            let element = self[index]
            return element.id
        }
        return nil
    }
}
