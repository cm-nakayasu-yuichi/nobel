//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol ConfigureAdapterDelegate: class {
    
    //func configureAdapter(_ adapter: ConfigureAdapter, value)
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
        cell.textLabel?.text = configureRow.title
        cell.textLabel?.textColor = configureRow.textColor
        cell.detailTextLabel?.text = ""//configureRow.value(book: self.owner.configuredBook)
        cell.accessoryType = configureRow.accessoryType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
