//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

// MARK: - ConfigureSentenceViewController -

/// 節(文章)の設定画面ビューコントローラ
class ConfigureSentenceViewController: ConfigureChildViewController, ManageTableViewControllerDelegte {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var chapter: Chapter!
    
    /// テーブルビューアダプタ
    fileprivate var adapter : ManageTableViewController!
    
    /// インスタンスを生成する
    /// - parameter chapter: 章
    /// - returns: 新しいインスタンス
    class func create(chapter: Chapter) -> ConfigureSentenceViewController {
        let ret = App.Storyboard("Configure").id("sentence").get(ConfigureSentenceViewController.self)
        ret.chapter = chapter
        return ret
    }
    
    // MARK: - ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.title = "文章"
    }
    
    // MARK: - セットアップ
    
    /// テーブルビューのセットアップ
    private func setupTableView() {
        self.adapter = ManageTableViewController()
        self.adapter.modes = [.select, .rename, .sort]
        self.adapter.items = self.chapter.sentences
        self.adapter.owner = self
        self.adapter.delegate = self
        self.adapter.setup(self.tableView)
    }
    
    /// アダプタのデータを充填する
    private func refill() {
        self.adapter.items = self.chapter.sentences
    }
    
    /// テーブルビューを再描画する
    private func reload() {
        self.refill()
        self.adapter.tableView?.reloadData()
    }
    
    /// 行の文字列
    func manageTable(textAt index: Int) -> String {
        return self.chapter.sentences[index].name
    }
    
    /// 選択時
    func manageTable(_ manageTable: ManageTableViewController, didSelectRowAt index: Int) {
        let sentence = self.chapter.sentences[index]
        self.configuredBook.selectCurrentSentence(id: sentence.id)
        self.configuredBook.save()
        self.owner.finish()
        self.dismiss()
    }
    
    /// 行入れ替え時
    func manageTable(_ manageTable: ManageTableViewController, didExchangeFrom from: Int, to: Int) {
        if self.chapter.sentences.exchange(from: from, to: to) {
            self.configuredBook.save()
        }
    }
    
    /// 削除が押下された時
    func manageTable(_ manageTable: ManageTableViewController, didTapDeleteRowAt index: Int, deleted: @escaping () -> ()) {
        if !self.chapter.isDeletableSentence {
            NBAlert.show(OK: self, message: "文章をこれ以上は\n削除できません")
            return
        }
        
        NBAlert.show(YesNo: self, message: "この文章を削除しますか?") {
            self.chapter.deleteSentence(at: index)
            self.configuredBook.save()
            self.refill()
            deleted()
        }
    }
    
    /// リネーム選択時
    func manageTable(_ manageTable: ManageTableViewController, didTapRenameRowAt index: Int) {
        let name = self.chapter.sentences[index].name
        
        self.pushConfigure(ConfigureTextFieldViewController.create(type: .sentence, initialText: name) { [unowned self] (vc, text) in
            self.chapter.sentences[index].name = text
            self.configuredBook.save()
            self.reload()
        })
    }
    
    /// 追加が押下された時
    func manageTableDidTapAddRow(_ manageTable: ManageTableViewController) {
        let n = (self.chapter.sentences.count + 1).kansuji
        let name = "第\(n)幕 "
        self.chapter.addSentence(name: name)
        self.configuredBook.save()
        self.reload()
    }
}
