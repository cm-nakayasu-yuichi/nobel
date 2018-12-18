//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class BootstrapViewController: UITableViewController {
    
    // ここに定義します
    // =========================================================================
    private let items: [(section: String, rows: [(title: String, handler: (UIViewController) -> Void)])] = [
        (section: "アプリ",
         rows: [
            (title: "スタート", handler: { bootstrap in
                //Wireframe.showTodoList(from: bootstrap)
            }),
            (title: "書棚", handler: { bootstrap in
                //Wireframe.showTodoList(from: bootstrap)
            }),
            (title: "テスト", handler: { bootstrap in
                Wireframe.showTest(from: bootstrap)
            }),
            ]),
        (section: "書籍リポジトリテスト",
         rows: [
            (title: "読み込み", handler: { _ in
                let mock = BookInteractorOutputMock()
                mock.interactor.load()
            }),
            (title: "作成", handler: { _ in
                let mock = BookInteractorOutputMock()
                mock.interactor.create()
            }),
            ]),
        ]
    // =========================================================================
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section].rows[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.section].rows[indexPath.row].handler(self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].section
    }
}
