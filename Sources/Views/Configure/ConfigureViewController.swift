//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ConfigureViewController: UIViewController {
    
    /// 設定完了時のコールバック
    typealias Configured = (ConfigureViewController, Book) -> ()
    
    var configured: Configured?
    
    var scenario = ConfigureScenario.global {
        didSet {
            self.configuredBook = scenario.configuredBook
        }
    }
    
    private var adapter: ConfigureAdapter!
    private(set) var configuredBook: Book!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        adapter = ConfigureAdapter(tableView, scenario: scenario, delegate: self)
        title = self.scenario.menuTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupLeftButton() {
        let closeButton = UIBarButtonItem(
            title: self.scenario.leftButtonTitle,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    /// 閉じるボタン押下時
    @objc func didTapCloseButton() {
        Wireframe.dismiss(from: self)
    }
}

extension ConfigureViewController: ConfigureAdapterDelegate {
    
    func configureAdapter(_ adapter: ConfigureAdapter, titleForRow row: ConfigureRow) -> String {
        switch row {
        case .bookName: return "作品名"
        case .bookAuthor: return "作者名"
        case .colorTheme: return "カラーテーマ"
        case .fontType: return "フォント"
        case .textSize: return "文字サイズ"
        case .cover: return "表紙"
        case .chapter: return "章"
        case .discard: return "書籍の追加をキャンセルする"
        }
    }
    
    func configureAdapter(_ adapter: ConfigureAdapter, valueForRow row: ConfigureRow) -> String {
        switch row {
        case .bookName:   return configuredBook.name
        case .bookAuthor: return configuredBook.author
        case .colorTheme: return configuredBook.colorTheme.name
        case .fontType:   return configuredBook.fontType.name
        case .textSize:   return configuredBook.textSize.name
        case .chapter:    return "\(configuredBook.chapters.count)個"
        default: return ""
        }
    }
    
    func didSelectBookName(in configureAdapter: ConfigureAdapter) {
        Wireframe.showConfigureText(from: self, kind: .bookName, initial: configuredBook.name) { [unowned self] text in
            self.configuredBook.name = text
        }
    }
    
    func didSelectBookAuthor(in configureAdapter: ConfigureAdapter) {
        Wireframe.showConfigureText(from: self, kind: .author, initial: configuredBook.author) { [unowned self] text in
            self.configuredBook.author = text
        }
    }
    
    func didSelectColorTheme(in configureAdapter: ConfigureAdapter) {
        
    }
    
    func didSelectFontType(in configureAdapter: ConfigureAdapter) {
        
    }
    
    func didSelectTextSize(in configureAdapter: ConfigureAdapter) {
        
    }
    
    func didSelectCover(in configureAdapter: ConfigureAdapter) {
        
    }
    
    func didSelectChapter(in configureAdapter: ConfigureAdapter) {
        
    }
    
    func didSelectDiscard(in configureAdapter: ConfigureAdapter) {
        configuredBook.delete()
        Wireframe.dismiss(from: self)
    }
}
