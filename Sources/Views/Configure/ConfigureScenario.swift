//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

enum ConfigureScenario {
    
    case global
    case initialize
    case update(book: Book)
    
    /// 設定値
    var configuredBook: Book {
        switch self {
        case .update(let book):
            return Book.decode(book.encode()) as! Book
        case .global:
            return App.globalConfigure.book
        case .initialize:
            return App.globalConfigure.createBookAppliedGlobalConfigure()
        }
    }
    
    /// メニュー画面のタイトル
    var menuTitle: String {
        switch self {
        case .update:     return "設定"
        case .global:     return "全体設定"
        case .initialize: return "書籍の追加"
        }
    }
    
    /// 左ボタンのタイトル
    var leftButtonTitle: String {
        switch self {
        case .update:     return "更新"
        case .global:     return "保存"
        case .initialize: return "追加"
        }
    }
}
