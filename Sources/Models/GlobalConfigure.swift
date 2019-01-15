/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// 全体設定(グローバル設定)
class GlobalConfigure {
    
    var book: Book!
    
    /// 全体設定(グローバル設定)を読み込む
    class func load() -> GlobalConfigure {
        let globalConfigure = GlobalConfigure()
        if let book = App.Data.load(propertiesOf: .globalConfigure, type: Book.self) {
            globalConfigure.book = book
        } else {
            globalConfigure.book = GlobalConfigure.createBookForGlobalConfiguring()
            App.Data.save(propertiesOf: .globalConfigure, data: globalConfigure.book)
        }
        return globalConfigure
    }
    
    /// 全体設定(グローバル設定)を保存する
    func save(book: Book) {
        self.book = book
        App.Data.save(propertiesOf: .globalConfigure, data: book)
    }
    
    /// 全体設定用の書籍を作成する
    /// - returns: 全体設定用の書籍
    class func createBookForGlobalConfiguring() -> Book {
        let book = Book()
        book.id = "grobal-configure"
        return book
    }

    /// 全体設定が適用された新しい書籍を作成する
    /// - returns: 新しい書籍
    func createBookAppliedGlobalConfigure() -> Book {
        let ret = Book.create()
        ret.author     = book.author
        ret.colorTheme = book.colorTheme
        ret.fontType   = book.fontType
        ret.textSize   = book.textSize
        return ret
    }
}

// MARK: - App拡張 -
extension App {
    
    /// 全体設定(グローバル設定)
    static let globalConfigure = GlobalConfigure.load()
}
