//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ConfigureViewController: UINavigationController {
    
    /// 設定完了時のコールバック
    typealias Configured = (ConfigureViewController, Book) -> ()
    
    private var configured: Configured?
    private(set) var scenario = ConfigureScenario.global
    private(set) var configuredBook: Book!
    
    convenience init(rootViewController: UIViewController, scenario: ConfigureScenario, configured: Configured?) {
        self.init(rootViewController: rootViewController)
        self.scenario = scenario
        self.configured = configured
        self.configuredBook = scenario.configuredBook
    }
    
    func finish() {
        self.configured?(self, self.configuredBook)
    }
}
