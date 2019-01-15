//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 章モデル
class Chapter {
    
    /// 章の名前
    var name = "第一章 新しい章"
    
    /// 節(文章)の配列
    var sentences = [Sentence]()
    
    /// 親となる書籍
    weak var parentBook: Book!
}

// MARK: - 章の操作 -
extension Chapter {
    
    /// 新しい章を生成する
    /// - parameter book: 親となる書籍
    /// - parameter name: 章の名前
    /// - returns: 新しい章
    class func create(parent book: Book, name: String? = nil) -> Chapter {
        let ret = Chapter()
        if let name = name {
            ret.name = name
        }
        ret.parentBook = book
        ret.sentences.append(Sentence.create(parent: ret))
        return ret
    }
    
    /// 章を削除する
    func delete() {
        for sentence in sentences {
            sentence.delete()
        }
    }
    
    /// 章の文章を読み込む
    /// - returns: 章の文章
    func loadText() -> String {
        return sentences.reduce("") { return $0 + $1.load() }
    }
}

// MARK: - 節(文章)の操作 -
extension Chapter {
    
    /// 節(文章)を追加する
    /// - parameter name: 節(文章)の名前
    func addSentence(name: String) {
        self.sentences.append(Sentence.create(parent: self, name: name))
    }
    
    /// 節(文章)を削除する
    /// - parameter index: インデックス
    func deleteSentence(at index: Int) {
        if !isDeletableSentence { return }
        
        if sentences.inRange(at: index) {
            sentences[index].delete()
            sentences.remove(at: index)
        }
    }
    
    /// 節(文章)が削除可能かどうか
    var isDeletableSentence: Bool {
        return sentences.count > 1
    }
}

// MARK: - DataManagableEntity実装 -
extension Chapter: DataManagableEntity {
    
    /// エンティティ -> 辞書
    func encode() -> Dictionary<String, Any> {
        var ret: Dictionary<String, Any> = [
            "name" : name,
            ]
        ret["sentences"] = sentences.map { sentence -> Dictionary<String, Any> in
            return sentence.encode()
        }
        return ret
    }
    
    /// 辞書 -> エンティティ
    class func decode(_ data: Dictionary<String, Any>) -> DataManagableEntity? {
        let ret = Chapter()
        
        ret.name = get(data, stringOf: "name")
        
        ret.sentences = get(data, arrayOf: "sentences").compactMap { dict -> Sentence? in
            let sentence = Sentence.decode(dict) as? Sentence
            sentence?.parentChapter = ret
            return sentence
        }
        
        return ret
    }
}

// MARK: - Equatable実装 -
extension Chapter: Equatable {
    
    public static func ==(lhs: Chapter, rhs: Chapter) -> Bool {
        return lhs === rhs
    }
}

// MARK: - CustomStringConvertible実装 -
extension Chapter: CustomStringConvertible {
    
    var description: String {
        return "「\(name)」"
    }
}
