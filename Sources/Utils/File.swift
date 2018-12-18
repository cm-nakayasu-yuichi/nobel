//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

struct File {
    /// ファイルパス
    let path: String
}

extension File {
    
    /// ファイル名
    var name: String {
        return (path as NSString).lastPathComponent
    }
    
    /// 拡張子
    var `extension`: String {
        let ext = (name as NSString).pathExtension
        return ext.isEmpty ? "" : ".\(ext)"
    }
    
    /// ドットなしの拡張子
    var extensionWithoutDot: String {
        let ext = (name as NSString).pathExtension
        return ext.isEmpty ? "" : "\(ext)"
    }
    
    /// 拡張子を取り除いたファイル名
    var nameWithoutExtension: String {
        return (name as NSString).deletingPathExtension
    }
    
    /// ディレクトリパス
    var directoryPath: String {
        if path == "/" { return "" }
        return (path as NSString).deletingLastPathComponent
    }
}

extension File {
    
    static func +(lhs: File, rhs: String) -> File {
        return lhs.append(pathComponent: rhs)
    }
    
    /// 自身のパスにパスコンポーネントを追加する
    /// - Parameter pathComponent: 追加するコンポーネント
    /// - Returns: 自身の参照
    func append(pathComponent: String) -> File {
        return File(path: path.appendingPathComponent(pathComponent))
    }
}

extension File {
    
    /// ファイルURL
    var url: URL {
        return URL(fileURLWithPath: path)
    }
    
    /// ファイルデータ
    var data: Data? {
        return try? Data(contentsOf: url)
    }
    
    /// ファイルから取得した画像
    var image: UIImage? {
        guard let data = self.data else { return nil }
        return UIImage(data: data)
    }
    
    /// ファイルから取得した文字列
    var contents: String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// ファイルに文字列を書き込む
    /// - Parameters:
    ///   - contents: 書き込む内容
    ///   - encoding: 文字エンコーディング
    /// - Throws: 書き込み失敗時に例外を投げる
    func write(contents: String, encoding: String.Encoding = .utf8) throws {
        try makeDirectory()
        try contents.write(to: url, atomically: true, encoding: encoding)
    }
}

extension File {
    
    /// ファイルが存在するかどうか
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// ファイルかどうか
    var isFile: Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return !isDirectory.boolValue
        }
        return false
    }
    
    /// ディレクトリかどうか
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }
        return false
    }
}

extension File {
    
    /// ファイル属性
    var attributes: [FileAttributeKey : Any] {
        var ret = [FileAttributeKey : Any]()
        if exists {
            if let attr = try? FileManager.default.attributesOfItem(atPath: path) {
                ret.merge(attr) { return $1 }
            }
            if let attr = try? FileManager.default.attributesOfFileSystem(forPath: path) {
                ret.merge(attr) { return $1 }
            }
        }
        return ret
    }
    
    /// 指定したキーのファイル属性値を取得する
    /// - Parameter key: キー
    /// - Returns: ファイル属性値
    func attribute(key: FileAttributeKey) -> Any? {
        return attributes[key]
    }
    
    /// ファイルサイズ
    var size: UInt64 {
        guard let value = attribute(key: .size) as? UInt64 else { return 0 }
        return value
    }
    
    /// ファイルの作成日付
    var createdDate: Date? {
        return attribute(key: .creationDate) as? Date
    }
    
    /// ファイルの更新日付
    var modifiedDate: Date? {
        return attribute(key: .modificationDate) as? Date
    }
}

extension File {
    
    /// 親ディレクトリ
    var directory: File {
        return File(path: directoryPath)
    }
    
    var files: [File] {
        if isDirectory, let fileNames = try? FileManager.default.contentsOfDirectory(atPath: path) {
            return fileNames.sorted().map { filename -> File in
                return append(pathComponent: filename)
            }
        }
        return []
    }
    
    var filePaths: [String] {
        return files.map { $0.path }
    }
    
    var fileNames: [String] {
        return files.map { $0.name }
    }
}

extension File {
    
    func makeDirectory() throws {
        let dir = isDirectory ? self : directory
        if !dir.exists {
            try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func makeEmptyTextFile() throws {
        if !exists {
            try write(contents: "")
        }
    }
    
    func delete() throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    func copy(to destination: File, force: Bool = true) throws {
        if force && destination.exists {
            try destination.delete()
        }
        try FileManager.default.copyItem(atPath: path, toPath: destination.path)
    }
    
    func move(to destination: File, force: Bool = true) throws {
        if force && destination.exists {
            try destination.delete()
        }
        try FileManager.default.moveItem(atPath: path, toPath: destination.path)
    }
    
    func rename(to name: String, force: Bool = true) throws -> File {
        let destination = File(path: directoryPath) + name
        try move(to: destination, force: force)
        return destination
    }
}

extension File {
    
    /// ドキュメントディレクトリパス
    static var documentDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    /// メインバンドルパス
    static var mainBundlePath: String {
        return Bundle.main.bundlePath
    }
    
    /// ドキュメントディレクトリ
    static var documentDirectory: File {
        return File(path: documentDirectoryPath)
    }
    
    /// メインバンドル
    static var mainBundle: File {
        return File(path: mainBundlePath)
    }
}

extension File {
    
}

extension String {
    
    /// パスコンポーネント追加
    /// - Parameter component: 追加するコンポーネント
    /// - Returns: パスコンポーネントが追加されたパス文字列
    func appendingPathComponent(_ component: String) -> String {
        return (self as NSString).appendingPathComponent(component)
    }
}
