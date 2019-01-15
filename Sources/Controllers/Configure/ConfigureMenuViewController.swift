/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - ConfigureMenuSection -

/// 設定メニュー画面行
enum ConfigureMenuRow {
    case bookName
    case bookAuthor
    case colorTheme
    case fontType
    case textSize
    case cover
    case chapter
    case plot
    case discard
    
    var title: String {
        switch self {
        case .bookName: return "作品名"
        case .bookAuthor: return "作者名"
        case .colorTheme: return "カラーテーマ"
        case .fontType: return "フォント"
        case .textSize: return "文字サイズ"
        case .cover: return "表紙"
        case .chapter: return "章"
        case .plot: return "プロット"
        case .discard: return "書籍の追加をキャンセルする"
        }
    }
    
    func value(book: Book) -> String {
        switch self {
        case .bookName:   return book.name
        case .bookAuthor: return book.author
        case .colorTheme: return book.colorTheme.name
        case .fontType:   return book.fontType.name
        case .textSize:   return book.textSize.name
        case .chapter:    return "\(book.chapters.count)個"
        default: return ""
        }
    }
    
    func transfer(from vc: ConfigureMenuViewController) {
        switch self {
		case .bookName:
			vc.pushConfigure(ConfigureTextFieldViewController.create(type: .bookName, initialText: vc.owner.configuredBook.name) { _, text in
				vc.owner.configuredBook.name = text
			})
		case .bookAuthor:
			vc.pushConfigure(ConfigureTextFieldViewController.create(type: .bookName, initialText: vc.owner.configuredBook.author) { _, text in
				vc.owner.configuredBook.author = text
			})
        case .colorTheme:
			vc.pushConfigure(ConfigureThemeSelectViewController.create(type: .colorTheme) { _, rawValue in
				vc.owner.configuredBook.colorTheme = ColorTheme(rawValue: rawValue)!
			})
		case .fontType:
			vc.pushConfigure(ConfigureThemeSelectViewController.create(type: .fontType) { _, rawValue in
				vc.owner.configuredBook.fontType = FontType(rawValue: rawValue)!
			})
		case .textSize:
			vc.pushConfigure(ConfigureThemeSelectViewController.create(type: .textSize) { _, rawValue in
				vc.owner.configuredBook.textSize = TextSize(rawValue: rawValue)!
			})
        case .chapter:
            vc.pushConfigure(ConfigureChapterViewController.create())
        case .discard:
            vc.configuredBook.delete()
            vc.dismiss()
        default: break
        }
    }
    
    static func items(scenario: ConfigureScenario) -> [[ConfigureMenuRow]] {
        switch scenario {
        case .global:
            return [
                [.colorTheme, .fontType, .textSize],
                [.bookAuthor],
            ]
        case .initialize:
            return [
                [.bookName, .bookAuthor],
                [.colorTheme, .fontType, .textSize],
                [.cover],
                [.discard],
            ]
        case .update:
            return [
                [.chapter, .plot],
                [.colorTheme, .fontType, .textSize],
                [.bookName, .bookAuthor],
                [.cover],
            ]
        }
    }
    
    var textColor: UIColor {
        if self.isDestructive {
            return UIColor(rgb: 0xFC3D39)
        } else {
            return UIColor.black
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        return self.isDestructive ? .none : .disclosureIndicator
    }
    
    private var isDestructive: Bool {
        switch self { case .discard: return true default: return false }
    }
}

/// 設定メニュー画面ビューコントローラ
class ConfigureMenuViewController: ConfigureChildViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    /// テーブルビューアダプタ
    private var adapter : ConfigureMenuTableViewController!
    
    /// 自身のインスタンスを生成する
    /// - returns: 新しい自身のインスタンス
    class func create() -> ConfigureMenuViewController {
        let ret = App.Storyboard("Configure").id("menu").get(ConfigureMenuViewController.self)
        return ret
    }
    
    // MARK: - ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftButton()
        self.setupTableView()
        self.title = self.owner.scenario.menuTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - セットアップ
    
    /// テーブルビューのセットアップ
    private func setupTableView() {
        self.adapter = ConfigureMenuTableViewController()
        self.adapter.owner = self
        self.adapter.setup(self.tableView)
    }
    
    /// 左ボタンのセットアップ
    func setupLeftButton() {
        let closeButton = UIBarButtonItem(
            title: self.owner.scenario.leftButtonTitle,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    /// 閉じるボタン押下時
    @objc func didTapCloseButton() {
        self.owner.finish()
        self.owner.dismiss()
    }
}

// MARK: - ConfigureMenuTableViewController -

/// 設定メニュー画面のテーブルビューコントローラ
class ConfigureMenuTableViewController: NBTableViewController {
    
    /// 親となる設定メニュー画面ビューコントローラ
    weak var owner: ConfigureMenuViewController!
    
    /// セクションの配列を取得する
    private var sections: [[ConfigureMenuRow]] {
        return ConfigureMenuRow.items(scenario: self.owner.owner.scenario)
    }
    
    /// 指定のセクションインデックスの行の配列を取得
    /// - parameter index: インデックス
    /// - returns: 行の配列
    private func rows(at index: Int) -> [ConfigureMenuRow] {
        return self.sections[index]
    }
    
    /// 指定のインデックスの行を取得
    /// - parameter indexPath: インデックスパス
    /// - returns: 行
    private func row(at indexPath: IndexPath) -> ConfigureMenuRow {
        return self.rows(at: indexPath.section)[indexPath.row]
    }
    
    // MARK: - テーブル設定 -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows(at: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = self.row(at: indexPath)
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.value(book: self.owner.configuredBook)
        
        
        cell.textLabel?.textColor = row.textColor
        cell.accessoryType = row.accessoryType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let row = self.row(at: indexPath)
        row.transfer(from: self.owner)
    }
}
