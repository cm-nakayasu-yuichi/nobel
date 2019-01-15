//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 書棚モデル
class Shelf {
    /// 書籍リスト
    var books = [Book]()
}

// MARK: - 書棚の操作 -

extension Shelf {

    /// 書棚を読み込む
    class func load() -> Shelf {
        if let shelf = App.Data.load(propertiesOf: .shelf, type: Shelf.self) {
            return shelf
        } else {
            let shelf = Shelf()
            App.Data.save(propertiesOf: .shelf, data: shelf)
            return shelf
        }
    }
    
    /// 書棚を保存する
    func save() {
        App.Data.save(propertiesOf: .shelf, data: self)
    }
    
    /// 書棚リストをリロードする
    func reload() {
        let loadedShelf = App.Data.load(propertiesOf: .shelf, type: Shelf.self)
        books = loadedShelf?.books ?? []
    }
}

// MARK: - 書籍の操作 -

extension Shelf {
    
    /// 書棚に書籍を追加する
    /// - parameter book: 追加する書籍
    func addBook(_ book: Book) {
        books.append(optimizedOf(book))
        save()
    }
    
    /// 書棚内の指定した書籍の情報を更新する
    /// - parameter book: 更新する書籍
    func updateBook(_ book: Book) {
        guard let i = books.index(of: book) else { return }
        books[i] = optimizedOf(book)
        save()
    }
    
    /// 書棚内の指定した書籍を削除する
    /// - parameter book: 削除する書籍
    func deleteBook(_ book: Book) {
        guard let i = books.index(of: book) else { return }
        books.remove(at: i)
        save()
    }
    
    /// 書棚内の書籍を取得する
    /// - parameter index: インデックス
    func book(at index: Int) -> Book? {
        if books.inRange(at: index) {
            let bookInShelf = books[index]
            return App.Data.load(propertiesOf: .book(bookID: bookInShelf.id), type: Book.self)
        }
        return nil
    }
    
    /// 書棚内の書籍を取得する
    /// - parameter id: 書籍ID
    func book(id: String) -> Book? {
        if let bookInShelf = books.entityBy(id: id) { // 存在確認
            return App.Data.load(propertiesOf: .book(bookID: bookInShelf.id), type: Book.self)
        }
        return nil
    }
    
    /// 指定した書籍から書棚用情報に最適化した新しい書籍オブジェクトを返却する
    /// - parameter book: 最適化する書籍
    /// - returns: 最適化した新しい書籍
    private func optimizedOf(_ book: Book) -> Book {
        let ret = Book()
        ret.id       = book.id
        ret.name     = book.name
        ret.author   = book.author
        ret.isLocked = book.isLocked
        return ret
    }
}

// MARK: - DataModelManagable -

extension Shelf: DataManagableEntity {
    
    /// エンティティ -> 辞書
    func encode() -> Dictionary<String, Any> {
        return ["books" : books.map { book -> Dictionary<String, Any> in
            return [
                "id"     : book.id,
                "name"   : book.name,
                "author" : book.author,
                "locked" : book.isLocked,
                ]
            }
        ]
    }
    
    /// 辞書 -> エンティティ
    class func decode(_ data: Dictionary<String, Any>) -> DataManagableEntity? {
        let ret = Shelf()
        ret.books = get(data, arrayOf: "books").compactMap { dict -> Book? in
            let book = Book()
            book.id = get(dict, stringOf: "id")
            if book.id.isEmpty { return nil }
            
            book.name     = get(dict, stringOf: "name")
            book.author   = get(dict, stringOf: "author")
            book.isLocked = get(dict, boolOf: "locked")
            
            return book
        }
        return ret
    }
}

// MARK: - CustomStringConvertible -

extension Shelf: CustomStringConvertible {
    
    var description: String {
        return books.reduce("") { ret, book in
            return ret + "\(book.id) 「\(book.name)」,\n"
        }
    }
}

// MARK: - App拡張 -
extension App {
    
    /// 書棚
    static let shelf = Shelf.load()
}
