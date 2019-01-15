//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 節(文章)モデル
class Sentence {
    
    /// ID
    var id = ""
    
    /// 節(文章)名
    var name = "第一幕 新しい文章"
    
    /// 親となる章
    weak var parentChapter: Chapter!
}

// MARK: - 節(文章)の操作 -
extension Sentence {
    
    /// 新しい節(文章)を生成する
    /// - parameter chapter: 親となる章
    /// - parameter name: 節(文章)の名前
    /// - returns: 新しい節(文章)
    class func create(parent chapter: Chapter, name: String? = nil) -> Sentence {
        let ret = Sentence()
        ret.id = App.Data.createNewID(2)
        if let name = name {
            ret.name = name
        }
        ret.parentChapter = chapter
        ret.save(text: "")
        return ret
    }
    
    /// 節(文章)のファイルを読み込む
    /// - returns: 内容
    func load() -> String {
        return App.Data.load(textOf: type)
    }
    
    /// 節(文章)のファイルを保存する
    /// - parameter text: 内容
    func save(text: String) {
        App.Data.save(textOf: type, text: text)
    }
    
    /// 節(文章)のファイルを削除する
    func delete() {
        if let book = parentChapter.parentBook, id == book.currentSentenceID {
            book.selectCurrentSentenceToFirst()
        }
        let _ = App.Data.deleteFile(dataType: type)
    }
}

// MARK: - その他 -
extension Sentence {
    
    /// 永続データ種別
    var type: DataType {
        return DataType.sentence(bookID: parentChapter.parentBook!.id, id: id)
    }
}

// MARK: - DataModelManagable -

extension Sentence: DataManagerIdentifiableEntity {
    
    /// エンティティ -> 辞書
    func encode() -> Dictionary<String, Any> {
        return [
            "id"   : id,
            "name" : name,
        ]
    }
    
    /// 辞書 -> エンティティ
    class func decode(_ data: Dictionary<String, Any>) -> DataManagableEntity? {
        let ret = Sentence()
        
        ret.id = get(data, stringOf: "id")
        if ret.id.isEmpty { return nil }
        
        ret.name = get(data, stringOf: "name")
        
        return ret
    }
}

// MARK: - CustomStringConvertible -

extension Sentence: CustomStringConvertible {
    
    var description: String {
        return "\(id) 「\(name)」"
    }
}
