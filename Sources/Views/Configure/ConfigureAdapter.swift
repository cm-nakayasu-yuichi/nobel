//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol ConfigureAdapterDelegate: class {
    
    func configureAdapter(_ adapter: ConfigureAdapter, titleForRow row: ConfigureRow) -> String
    func configureAdapter(_ adapter: ConfigureAdapter, valueForRow row: ConfigureRow) -> String
    
    func didSelectBookName(in configureAdapter: ConfigureAdapter)
    func didSelectBookAuthor(in configureAdapter: ConfigureAdapter)
    func didSelectColorTheme(in configureAdapter: ConfigureAdapter)
    func didSelectFontType(in configureAdapter: ConfigureAdapter)
    func didSelectTextSize(in configureAdapter: ConfigureAdapter)
    func didSelectCover(in configureAdapter: ConfigureAdapter)
    func didSelectChapter(in configureAdapter: ConfigureAdapter)
    func didSelectDiscard(in configureAdapter: ConfigureAdapter)
}

class ConfigureAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var tableView: UITableView!
    weak var delegate: ConfigureAdapterDelegate!
    weak var book: Book!
    
    private var scenario: ConfigureScenario!
    
    convenience init(_ tableView: UITableView, scenario: ConfigureScenario, delegate: ConfigureAdapterDelegate) {
        self.init()
        self.tableView = tableView
        self.scenario = scenario
        self.delegate = delegate
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows(at: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let configureRow = row(at: indexPath)
        cell.textLabel?.text = delegate.configureAdapter(self, titleForRow: configureRow)
        cell.textLabel?.textColor = configureRow.textColor
        cell.detailTextLabel?.text = delegate.configureAdapter(self, valueForRow: configureRow)
        cell.accessoryType = configureRow.accessoryType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch row(at: indexPath) {
        case .bookName:   delegate.didSelectBookName(in: self)
        case .bookAuthor: delegate.didSelectBookAuthor(in: self)
        case .colorTheme: delegate.didSelectColorTheme(in: self)
        case .fontType:   delegate.didSelectFontType(in: self)
        case .textSize:   delegate.didSelectTextSize(in: self)
        case .cover:      delegate.didSelectCover(in: self)
        case .chapter:    delegate.didSelectChapter(in: self)
        case .discard:    delegate.didSelectDiscard(in: self)
        }
    }
    
    private var sections: [[ConfigureRow]] {
        return ConfigureRow.items(scenario: scenario)
    }
    
    private func rows(at index: Int) -> [ConfigureRow] {
        return self.sections[index]
    }
    
    private func row(at indexPath: IndexPath) -> ConfigureRow {
        return self.rows(at: indexPath.section)[indexPath.row]
    }
}
