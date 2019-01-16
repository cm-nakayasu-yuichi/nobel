//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 書籍モデル
class Book {
    
    /// ID
    var id = ""
    
    /// 作品名
    var name = "新しい作品"
    
    /// 作者名
    var author = ""
    
    /// あらすじタイトル
    var outlineTitle = ""
    
    /// あらすじ
    var outline = ""
    
    /// しおりをしたチャプタのインデックス
    var bookmarkedChapterIndex = 0
    
    /// しおりをしたページのインデックス
    var bookmarkedPageIndex = 0
    
    /// 編集不可かどうか
    var isLocked = false
    
    /// カラーテーマ
    var colorTheme = ColorTheme.standard
    
    /// 文字サイズ
    var textSize = TextSize.standard
    
    /// フォント
    var fontType = FontType.standard
    
    /// 章リスト
    var chapters = [Chapter]()
    
    /// 編集中の文章
    fileprivate(set) var currentSentence: Sentence?
    
    /// 未選択時の文章のiD
    static let NotSetSentenceID = "0"
}

// MARK: - 書籍の操作 -
extension Book {
    
    /// 書籍を作成する
    class func create() -> Book {
        let book = Book()
        book.id = App.Data.createNewID(1)
        book.addChapter(name: nil)
        book.selectCurrentSentenceToFirst()
        return book
    }
    
    /// 書籍を保存する
    func save() {
        App.Data.save(propertiesOf: .book(bookID: id), data: self)
        App.shelf.updateBook(self)
    }
    
    /// 書籍を削除する
    func delete() {
        let _ = App.Data.deleteDirectory(dataType: .book(bookID: id))
    }
}

// MARK: - 章の操作 -
extension Book {
    
    /// 章を追加する
    /// - parameter name: 章の名前
    func addChapter(name: String?) {
        chapters.append(Chapter.create(parent: self, name: name))
    }
    
    /// 章を削除する
    /// - parameter index: インデックス
    func deleteChapter(at index: Int) {
        if !isDeletableChapter { return }
        
        if chapters.inRange(at: index) {
            chapters[index].delete()
            chapters.remove(at: index)
        }
    }
    
    /// 章が削除可能かどうか
    var isDeletableChapter: Bool {
        return chapters.count > 1
    }
    
    /// 選択中の節(文章)の章の名前
    var currentChapterName: String {
        return currentSentence?.parentChapter?.name ?? ""
    }
    
    /// 選択中の節(文章)の名前
    var currentChapter: Chapter! {
        if let ret = currentSentence?.parentChapter {
            return ret
        }
        return chapters[0]
    }
}

// MARK: - 節(文章)の選択 -
extension Book {
    
    /// 最初の章の最初の節を選択中の節とする
    func selectCurrentSentenceToFirst() {
        // 章と節は必ず1個以上ある
        self.currentSentence = chapters[0].sentences[0]
    }
    
    /// 指定したIDの節を選択中の節とする
    /// - parameter id: 節(文章)のID
    func selectCurrentSentence(id: String) {
        for chapter in chapters {
            for sentence in chapter.sentences {
                if id == sentence.id {
                    currentSentence = sentence
                    return
                }
            }
        }
        selectCurrentSentenceToFirst()
    }
    
    /// 選択中の節(文章)を読み込んで取得する
    /// - returns: 文章
    func loadCurrentSentenceText() -> String {
        return currentSentence?.load() ?? ""
    }
    
    /// 選択中の節(文章)のID
    var currentSentenceID: String {
        return currentSentence?.id ?? Book.NotSetSentenceID
    }
    
    /// 選択中の節(文章)の名前
    var currentSentenceName: String {
        return currentSentence?.name ?? ""
    }
}

// MARK: - その他 -
extension Book {
    
    /// 永続データの種類
    var type: DataType {
        return DataType.book(bookID: id)
    }
    
    /// 縦書き表示オプション
    var verticalViewOptions: VerticalViewOptions {
        let ret = VerticalViewOptions()
        ret.font            = fontType.font(textSize: textSize)
        ret.textColor       = colorTheme.textColor
        ret.backgroundColor = colorTheme.backgroundColor
        return ret
    }
    
    var bookmarkedChapter: Chapter {
        if !chapters.inRange(at: bookmarkedChapterIndex) {
            return chapters[0]
        }
        return chapters[bookmarkedChapterIndex]
    }
}

// MARK: - DataManagableEntity -

extension Book: DataManagerIdentifiableEntity {
    
    /// エンティティ -> 辞書
    func encode() -> Dictionary<String, Any> {
        var ret : Dictionary<String, Any> = [
            "id"                     : id,
            "name"                   : name,
            "author"                 : author,
            "outlineTitle"           : outlineTitle,
            "outline"                : outline,
            "locked"                 : isLocked,
            "colorTheme"             : colorTheme.rawValue,
            "textSize"               : textSize.rawValue,
            "fontType"               : fontType.rawValue,
            "bookmarkedChapterIndex" : bookmarkedChapterIndex,
            "bookmarkedPageIndex"    : bookmarkedPageIndex,
            ]
        ret["chapters"]  = chapters.map { chapter -> Dictionary<String, Any> in
            return chapter.encode()
        }
        ret["currentSentenceID"] = currentSentence?.id ?? Book.NotSetSentenceID
        
        return ret
    }
    
    /// 辞書 -> エンティティ
    class func decode(_ data: Dictionary<String, Any>) -> DataManagableEntity? {
        let ret = Book()
        
        ret.id = get(data, stringOf: "id")
        if ret.id.isEmpty { return nil }
        
        ret.name         = get(data, stringOf: "name")
        ret.author       = get(data, stringOf: "author")
        ret.outlineTitle = get(data, stringOf: "outlineTitle")
        ret.outline      = get(data, stringOf: "outline")
        ret.isLocked     = get(data, boolOf: "locked")
        
        ret.colorTheme = get(data, enumOf: "colorTheme", type: ColorTheme.self, .standard)
        ret.textSize   = get(data, enumOf: "textSize",   type: TextSize.self,   .standard)
        ret.fontType   = get(data, enumOf: "fontType",   type: FontType.self,   .standard)
        
        ret.bookmarkedChapterIndex = get(data, intOf: "bookmarkedChapterIndex")
        ret.bookmarkedPageIndex    = get(data, intOf: "bookmarkedPageIndex")
        
        ret.chapters = get(data, arrayOf: "chapters").compactMap { dict -> Chapter? in
            let chapter = Chapter.decode(dict) as? Chapter
            chapter?.parentBook = ret
            return chapter
        }
        
        let currentSentenceID = get(data, stringOf: "currentSentenceID")
        if currentSentenceID != Book.NotSetSentenceID {
            ret.selectCurrentSentence(id: currentSentenceID)
        }
        
        return ret
    }
}

// MARK: - CustomStringConvertible -

extension Book: CustomStringConvertible {
    
    var description: String {
        return "\(id) 「\(name)」"
    }
}
