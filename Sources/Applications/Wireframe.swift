//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class Wireframe {
    
    static func showLaunch(from fromViewController: UIViewController) {
        let viewController = builder.launch()
        helper.present(crossDisolve: viewController, from: fromViewController)
    }
    
    static func showShelf(from fromViewController: UIViewController) {
        let viewController = builder.shelf()
        helper.present(crossDisolve: viewController, from: fromViewController)
    }
    
    static func showConfigure(from fromViewController: UIViewController, scenario: ConfigureScenario, configured: ConfigureViewController.Configured? = nil) {
        let viewController = builder.configure(scenario: scenario, configured: configured)
        helper.present(helper.withinNavigation(viewController), from: fromViewController)
    }
    
    static func showTest(from fromViewController: UIViewController) {
        let viewController = builder.test()
        helper.present(helper.withinNavigation(viewController), from: fromViewController)
    }
    
    static func pop(from fromViewController: UIViewController) {
        helper.pop(from: fromViewController)
    }
    
    static func dismiss(from fromViewController: UIViewController, completion: (() -> ())? = nil) {
        helper.dismiss(from: fromViewController, completion: completion)
    }
    
    static func showConfirmDeleteEvent(from fromViewController: UIViewController, didDecide: @escaping () -> ()) {
        alertHelper.alertDeleteCancel(
            from: fromViewController,
            title: "確認",
            message: "このイベントを削除しますか",
            didDecide: didDecide
        )
    }
    
    private static var builder: Builder { return Builder() }
    private static var helper: WireframeHelper { return WireframeHelper() }
    private static var alertHelper: AlertHelper { return AlertHelper() }
}
