/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - ConfigureScenario -

/// 設定画面のシナリオ
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

/// 設定画面ビューコントローラ
class ConfigureViewController: UINavigationController, UINavigationControllerDelegate {
    
    /// 設定完了時のコールバッククロージャ
    typealias ConfiguredClosure = (ConfigureViewController, Book) -> ()
    
    /// 設定完了時のコールバック
    private var configured: ConfiguredClosure?
    
    /// シナリオ
    private(set) var scenario = ConfigureScenario.global
    
    /// 設定値
    private(set) var configuredBook: Book!
    
    /// インスタンスを生成する
    /// - parameter scenario: シナリオ
    /// - parameter configured: 設定完了時のコールバック
    /// - returns: 新しいインスタンス
    class func create(scenario: ConfigureScenario, configured: ConfiguredClosure? = nil) -> ConfigureViewController {
        let root = ConfigureMenuViewController.create()
        let ret = ConfigureViewController(rootViewController: root)
        ret.delegate = ret
        ret.scenario = scenario
        ret.configured = configured
        ret.configuredBook = scenario.configuredBook
        root.owner = ret
        return ret
    }
    
    /// 設定を完了させる
    func finish() {
        self.configured?(self, self.configuredBook)
    }
}
