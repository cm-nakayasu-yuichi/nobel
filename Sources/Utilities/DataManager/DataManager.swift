/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// 永続データ管理クラス
class DataManager {
    
    // MARK: - プロパティデータファイル
    
    /// プロパティデータファイルを読み込んでエンティティを取得する
    /// - parameter dataType: 永続データの種類
    /// - parameter type: DataManagableEntityプロトコルを実装した型
    /// - returns: エンティティ
    func load<T: DataManagableEntity>(propertiesOf dataType: DataType, type: T.Type) -> T? {
        guard let file = dataType.file, dataType.isProperties, file.exists else {
            return nil
        }
        let data = NSDictionary(contentsOf: file.url) as! Dictionary<String, Any>
        return type.decode(data) as? T
    }
    
    /// プロパティデータファイルにエンティティを保存する
    /// - parameter dataType: 永続データの種類
    /// - parameter data: 保存する対象のDataManagableEntityプロトコルを実装したエンティティ
    func save(propertiesOf dataType: DataType, data: DataManagableEntity) {
        guard let file = dataType.file, dataType.isProperties else {
            return
        }
        (data.encode() as NSDictionary).write(to: file.url, atomically: true)
    }
    
    /// プロパティデータファイルを読み込んで生データの辞書を取得する
    /// - parameter dataType: 永続データの種類
    /// - returns: 生データの辞書
    func load(rawPropertiesOf dataType: DataType) -> Dictionary<String, Any>? {
        guard let file = dataType.file, dataType.isProperties, file.exists else {
            return nil
        }
        return NSDictionary(contentsOf: file.url) as? Dictionary<String, Any>
    }
    
    // MARK: - 文章データファイル
    
    /// 文章データファイルを読み込んで文字列を取得する
    /// - parameter dataType: 永続データの種類
    /// - returns: 文字列
    func load(textOf dataType: DataType) -> String {
        guard let file = dataType.file, file.exists else {
            return ""
        }
        return file.contents ?? ""
    }
    
    /// 文章ファイルに文字列を保存する
    /// - parameter dataType: 永続データの種類
    /// - parameter text: 文字列
    func save(textOf dataType: DataType, text: String) {
        guard let file = dataType.file else {
            print("failed file not found.")
            return
        }
        do {
            try file.write(contents: text)
        } catch (let error) {
            print("failed write text file: " + error.localizedDescription)
        }
    }
    
    // MARK: - 削除
    
    /// ファイルを削除する
    /// - parameter dataType: 永続データの種類
    /// - returns: 成功/失敗
    func deleteFile(dataType: DataType) -> Bool {
        if let file = dataType.file {
            if !file.exists {
                print("file not exists.")
                return false
            }
            do {
                try file.delete()
            } catch let error {
                print("failed delete file: " + error.localizedDescription)
                return false
            }
            return true
        }
        return false
    }
    
    /// ディレクトリを削除する
    /// - parameter dataType: 永続データの種類
    /// - returns: 成功/失敗
    func deleteDirectory(dataType: DataType) -> Bool {
        if let dir = dataType.directory {
            if !dir.exists {
                print("directory not exists.")
                return false
            }
            do {
                try dir.delete()
            } catch let error {
                print("failed delete directory: " + error.localizedDescription)
                return false
            }
            return true
        }
        return false
    }
    
    /// ドキュメントディレクトリ内をすべて削除する(主に開発用)
    func deleteAll() {
        for file in File.documentDirectory.files {
            try? file.delete()
        }
    }
    
    // MARK: - その他
    
    /// 新しいIDを作成する
    /// - parameter number: IDの末尾に使用する数値
    /// - returns: 新しいID
    func createNewID(_ number: Int = 1) -> String {
        return Int.random(min: 1000, max: 9999).string + number.string + Int(Date().timeIntervalSince1970).string
    }
    
    /// ルートパス
    var path : String { return File.documentDirectory.path }
}

// MARK: - App.Model拡張 -
extension App {
    
    /// 永続データ管理クラス
    static let Data = DataManager()
}
