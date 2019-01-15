/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// 設定画面の子要素となるビューコントローラの基底クラス
class ConfigureChildViewController: UIViewController {
    
    /// 親となる設定画面ビューコントローラ
    weak var owner: ConfigureViewController!
    
    // MARK: - 画面操作
    
    /// 次の設定画面をプッシュする
    /// - parameter viewController: 次の設定画面子要素ビューコントローラ
    func pushConfigure(_ viewController: ConfigureChildViewController) {
        viewController.owner = self.owner
        self.push(viewController)
    }
    
    /// 現在の設定画面をポップする
    func popConfigure() {
        let _ = self.pop()
    }
    
    /// 画面全体を閉じる
    // TODO: エラーになるのでコメントアウト
//    override func dismiss(_ completion: CompletionHandler? = nil) {
//        self.owner.dismiss()
//    }
    
    // MARK: - 値取得
    
    /// 設定値
    var configuredBook: Book {
        return self.owner.configuredBook
    }
    
    /// 設定値の縦書き表示オプション
    var configuredOptions: VerticalViewOptions {
        return self.configuredBook.verticalViewOptions
    }
}
