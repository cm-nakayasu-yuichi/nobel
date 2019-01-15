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
            (title: "テスト", handler: { bootstrap in
                Wireframe.showTest(from: bootstrap)
            }),
            ]),
        (section: "アプリ",
         rows: [
            (title: "ファイルパス", handler: { bootstrap in
                print(File.documentDirectory.path)
            }),
            (title: "書棚閲覧", handler: { bootstrap in
                let mock = ShelfViewMock()
                mock.load()
            }),
            (title: "書棚追加", handler: { bootstrap in
                let mock = ShelfViewMock()
                mock.add()
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
