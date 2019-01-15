/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - ConfigureChapterViewController -

/// 章の設定画面ビューコントローラ
class ConfigureChapterViewController: ConfigureChildViewController, ManageTableViewControllerDelegte {
    
    @IBOutlet private weak var tableView: UITableView!
    
    /// テーブルビューアダプタ
    fileprivate var adapter : ManageTableViewController!
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create() -> ConfigureChapterViewController {
        let ret = App.Storyboard("Configure").id("chapter").get(ConfigureChapterViewController.self)
        return ret
    }
    
    // MARK: - ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.title = "章"
    }
    
    // MARK: - セットアップ
    
    /// テーブルビューのセットアップ
    private func setupTableView() {
        self.adapter = ManageTableViewController()
        self.adapter.modes = [.drilldown, .rename, .sort]
        self.adapter.items = self.configuredBook.chapters
        self.adapter.owner = self
        self.adapter.delegate = self
        self.adapter.setup(self.tableView)
    }
    
    /// アダプタのデータを充填する
    private func refill() {
        self.adapter.items = self.configuredBook.chapters
    }
    
    /// テーブルビューを再描画する
    private func reload() {
        self.refill()
        self.adapter.tableView?.reloadData()
    }
    
    /// 行の文字列
    func manageTable(textAt index: Int) -> String {
        return self.configuredBook.chapters[index].name
    }
    
    /// ドリルダウン選択時
    func manageTable(_ manageTable: ManageTableViewController, didDrilldownRowAt index: Int) {
        let chapter = self.configuredBook.chapters[index]
        self.pushConfigure(ConfigureSentenceViewController.create(chapter: chapter))
    }
    
    /// 行入れ替え時
    func manageTable(_ manageTable: ManageTableViewController, didExchangeFrom from: Int, to: Int) {
        if self.configuredBook.chapters.exchange(from: from, to: to) {
            self.configuredBook.save()
        }
    }
    
    /// 削除が押下された時
    func manageTable(_ manageTable: ManageTableViewController, didTapDeleteRowAt index: Int, deleted: @escaping () -> ()) {
        if !self.configuredBook.isDeletableChapter {
            NBAlert.show(OK: self, message: "章をこれ以上は\n削除できません")
            return
        }
        
        NBAlert.show(YesNo: self, message: "この章を削除しますか?") {
            self.configuredBook.deleteChapter(at: index)
            self.configuredBook.save()
            self.refill()
            deleted()
        }
    }
    
    /// リネーム選択時
    func manageTable(_ manageTable: ManageTableViewController, didTapRenameRowAt index: Int) {
        let name = self.configuredBook.chapters[index].name
        
        self.pushConfigure(ConfigureTextFieldViewController.create(type: .chapter, initialText: name) { [unowned self] (vc, text) in
            self.configuredBook.chapters[index].name = text
            self.configuredBook.save()
            self.reload()
        })
    }
    
    /// 追加が押下された時
    func manageTableDidTapAddRow(_ manageTable: ManageTableViewController) {
        let n = (self.configuredBook.chapters.count + 1).kansuji
        let name = "第\(n)章 "
        
        self.pushConfigure(ConfigureTextFieldViewController.create(type: .chapter, initialText: name) { [unowned self] (vc, text) in
            self.configuredBook.addChapter(name: text)
            self.configuredBook.save()
            self.reload()
        })
    }
}
