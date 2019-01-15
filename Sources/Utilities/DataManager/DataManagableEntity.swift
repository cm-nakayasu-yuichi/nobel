/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - DataManagableEntity -

/// DataManagerが管理することのできるエンティティプロトコル
protocol DataManagableEntity {

    /// エンティティから辞書に変換する
    /// - returns: 辞書データ
    func encode() -> Dictionary<String, Any>
    
    /// 辞書からエンティティに変換する
    /// - parameter data: 辞書データ
    /// - returns: エンティティ
    static func decode(_ data: Dictionary<String, Any>) -> DataManagableEntity?
}

extension DataManagableEntity {
    
    /// 辞書から指定のキーの値を文字列で取得する
    /// - parameter data: プロパティデータの種類
    /// - parameter key: キー
    /// - parameter substitute: 取得できなかった場合のデフォルト値
    /// - returns: 文字列
    static func get(_ data: Dictionary<String, Any>, stringOf key: String, _ substitute: String = "") -> String {
        return data[key] as? String ?? substitute
    }
    
    /// 辞書から指定のキーの値を整数で取得する
    /// - parameter data: プロパティデータの種類
    /// - parameter key: キー
    /// - parameter substitute: 取得できなかった場合のデフォルト値
    /// - returns: 整数値
    static func get(_ data: Dictionary<String, Any>, intOf key: String, _ substitute: Int = 0) -> Int {
        return data[key] as? Int ?? substitute
    }
    
    /// 辞書から指定のキーの値をブール値で取得する
    /// - parameter data: プロパティデータの種類
    /// - parameter key: キー
    /// - parameter substitute: 取得できなかった場合のデフォルト値
    /// - returns: ブール値
    static func get(_ data: Dictionary<String, Any>, boolOf key: String, _ substitute: Bool = false) -> Bool {
        return data[key] as? Bool ?? substitute
    }
    
    /// 辞書から指定のキーの値を列挙型で取得する
    /// - parameter data: プロパティデータの種類
    /// - parameter key: キー
    /// - parameter type: DataManagableEnumを実装した列挙型の型
    /// - parameter substitute: 取得できなかった場合のデフォルト値
    /// - returns: 列挙型
    static func get<T: DataManagableEnum>(_ data: Dictionary<String, Any>, enumOf key: String, type: T.Type, _ substitute: T) -> T {
        guard let hash = data[key] as? Int else {
            return substitute
        }
        return type.init(rawValue: hash)!
    }
    
    /// 辞書から指定のキーの値を配列で取得する
    /// - parameter data: プロパティデータの種類
    /// - parameter key: キー
    /// - returns: 辞書の配列
    static func get(_ data: Dictionary<String, Any>, arrayOf key: String) -> [Dictionary<String, Any>] {
        return data[key] as? [Dictionary<String, Any>] ?? []
    }
}

// MARK: - DataManagerIdentifiableEntity -

/// 識別子を持つDataManagableEntityとして振る舞うプロトコル
protocol DataManagerIdentifiableEntity: DataManagableEntity, Equatable {
    
    /// 識別子
    var id: String { get set }
}

extension DataManagerIdentifiableEntity {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
