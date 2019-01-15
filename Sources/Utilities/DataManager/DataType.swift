/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// 永続データの種類
enum DataType {
    
    case shelf
    case book(bookID: String)
    case sentence(bookID: String, id: String)
    case skeleton(bookID: String, id: String)
    case globalConfigure
    
    /// ディレクトリの場所
    var directoryLocation: String {
        switch self {
        case .shelf, .globalConfigure:
            return "/"
        case .book(let bookID),
             .sentence(let bookID, _),
             .skeleton(let bookID, _):
            return "book-\(bookID)/"
        }
    }
    
    /// ファイル名
    var fileName: String {
        switch self {
        case .shelf:               return "shelf.plist"
        case .book:                return "book.plist"
        case .sentence(_, let id): return "sentence-\(id).txt"
        case .skeleton(_, let id): return "skeleton-\(id).txt"
        case .globalConfigure:     return "configure.plist"
        }
    }
    
    /// ファイルオブジェクト
    var file: File? {
        // TODO:
        return File.documentDirectory.append(pathComponent: self.fileName)
//        return File.documentDirectory.locate(self.directoryLocation)?.name(self.fileName)
    }
    
    /// プロパティファイルかどうか
    var isProperties: Bool {
        switch self { case .shelf, .book, .globalConfigure: return true default: return false }
    }
    
    /// ディレクトリオブジェクト(削除用)
    var directory: File? {
        switch self {
        case .shelf: return nil
        // TODO:
        default: return File.documentDirectory
//        default: return File.documentDirectory.locate(self.directoryLocation)
        }
    }
}
