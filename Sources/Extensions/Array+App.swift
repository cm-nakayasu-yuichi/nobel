//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

extension Array {
    
    /// 取得不可なインデックス
    var invalidIndex: Int { return Int.min }
    
    /// 最初の要素のインデックス
    var firstIndex: Int {
        return indices.first ?? invalidIndex
    }
    
    /// 最後の要素のインデックス
    var lastIndex: Int {
        return indices.last ?? invalidIndex
    }
    
    /// 指定したインデックスが最初のインデックスかどうか
    /// - Parameter index: インデックス
    /// - Returns: 最初のインデックスかどうか
    func isFirstIndex(_ index: Int) -> Bool {
        return firstIndex != invalidIndex && firstIndex == index
    }
    
    /// 指定したインデックスが最後のインデックスかどうか
    /// - Parameter index: インデックス
    /// - Returns: 最後のインデックスかどうか
    func isLastIndex(_ index: Int) -> Bool {
        return lastIndex != invalidIndex && lastIndex == index
    }
    
    /// 指定したインデックスが配列の範囲内かどうかを返す
    /// - Parameter index: インデックス
    /// - Returns: 配列の範囲内かどうか
    func inRange(at index: Int) -> Bool {
        if isEmpty { return false }
        return firstIndex <= index && index <= lastIndex
    }
    
    /// 配列範囲内に収まるインデックスを返す
    /// - Parameter index: インデックス
    /// - Returns: 引数が配列範囲以下であれば 0 を返す。
    /// 配列範囲以上であれば 最後のインデックス を返す。
    /// 配列に要素がない場合は invalidIndex を返す。
    func indexInRange(for index: Int) -> Int {
        if isEmpty {
            return invalidIndex
        } else if index < firstIndex {
            return firstIndex
        } else if lastIndex < index {
            return lastIndex
        } else {
            return index
        }
    }
    
    /// 配列範囲内に収まる要素を返す
    /// - Parameter index: インデックス
    /// - Returns: 引数が配列範囲以下であれば 先頭の要素 を返す。
    /// 配列範囲以上であれば 最後の要素 を返す。
    /// 配列に要素がない場合は nil を返す。
    func elementInRange(for index: Int) -> Element? {
        let i = self.indexInRange(for: index)
        if i == invalidIndex {
            return nil
        }
        return self[i]
    }
    
    /// 新しい要素を末尾に足した配列を返す
    /// - Parameter element: 要素
    /// - Returns: 新しい要素を末尾に足した配列
    func pushed(_ element: Element) -> Array<Element> {
        return self + [element]
    }
    
    /// 新しい要素を先頭に足した配列を返す
    /// - Parameter element: 要素
    /// - Returns: 新しい要素を先頭に足した配列
    func unshifted(_ element: Element) -> Array<Element> {
        return [element] + self
    }
    
    /// 末尾の要素を取り除いた配列を返す
    /// - Returns: 末尾の要素を取り除いた配列
    func popped() -> Array<Element> {
        var arr = self
        _ = arr.removeLast()
        return arr
    }
    
    /// 先頭の要素を取り除いた配列を返す
    /// - Returns: 末尾の要素を取り除いた配列
    func shifted() -> Array<Element> {
        var arr = self
        _ = arr.removeFirst()
        return arr
    }
    
    /// 新しい要素を末尾に足した配列を返す(pushed(_:)のエイリアス)
    /// - Parameter element: 要素
    /// - Returns: 新しい要素を末尾に足した配列
    func added(_ element: Element) -> Array<Element> {
        return pushed(element)
    }
    
    /// 配列内の要素をランダムに取得する
    var random: Element? {
        if isEmpty { return nil }
        let i = Int(arc4random_uniform(UInt32(count)))
        return self[i]
    }
    
    /// ループさせる場合の次の配列のインデックスを取得する
    /// - Parameter index: インデックス
    /// - Returns: 次のインデックス。配列に要素がない場合は invalidIndex を返す
    func nextLoopIndex(of index: Int) -> Int {
        if isEmpty { return invalidIndex }
        if index + 1 > lastIndex {
            return firstIndex
        } else {
            return index + 1
        }
    }
    
    /// ループさせる場合の前の配列のインデックスを取得する
    /// - Parameter index: インデックス
    /// - Returns: 前のインデックス。配列に要素がない場合は invalidIndex を返す
    func previousLoopIndex(of index: Int) -> Int {
        if isEmpty { return invalidIndex }
        if index - 1 < firstIndex {
            return lastIndex
        } else {
            return index - 1
        }
    }
    
    /// 指定したインデックスの要素同士の入れ替え(移動)が可能かどうかを返す
    /// - Parameters:
    ///   - sourceIndex: 移動する元のインデックス
    ///   - destinationIndex: 移動する先のインデックス
    /// - Returns: 要素が入れ替え(移動)可能かどうか
    func canExchange(from sourceIndex: Int, to destinationIndex: Int) -> Bool {
        return self.indices.contains(sourceIndex) && self.indices.contains(destinationIndex)
    }
    
    /// 指定したインデックスの要素同士を入れ替える
    /// - Parameters:
    ///   - sourceIndex: 移動する元のインデックス
    ///   - destinationIndex: 移動する先のインデックス
    /// - Returns: 要素が入れ替え(移動)ができたかどうか
    mutating func exchange(from sourceIndex: Int, to destinationIndex: Int) -> Bool {
        if sourceIndex == destinationIndex {
            return false
        } else if !canExchange(from: sourceIndex, to: destinationIndex) {
            return false
        }
        swapAt(sourceIndex, destinationIndex)
        return true
    }
    
    /// 指定したインデックスの要素同士を入れ替えた配列を返す
    /// - Parameters:
    ///   - sourceIndex: 移動する元のインデックス
    ///   - destinationIndex: 移動する先のインデックス
    /// - Returns: 指定したインデックスの要素同士を入れ替えた配列
    func exchanged(from sourceIndex: Int, to destinationIndex: Int) -> Array<Element> {
        var arr = self
        _ = arr.exchange(from: sourceIndex, to: destinationIndex)
        return arr
    }
}
