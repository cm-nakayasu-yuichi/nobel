/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// DataManagerが管理することのできる列挙型プロトコル
/// - note: Int型のenumであることを保証する
protocol DataManagableEnum {
    
    /// イニシャライザ
    init?(rawValue: Int)
    
    /// 列挙値
    var rawValue: Int { get }
}
