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
    
}
