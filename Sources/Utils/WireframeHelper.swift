//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class WireframeHelper {
    
    func push(_ controller: UIViewController, from fromViewController: UIViewController) {
        fromViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop(from fromViewController: UIViewController) {
        fromViewController.navigationController?.popViewController(animated: true)
    }
    
    func present(_ controller: UIViewController, from fromViewController: UIViewController, completion: (() -> ())? = nil) {
        fromViewController.present(controller, animated: true, completion: completion)
    }
    
    func dismiss(from fromViewController: UIViewController, completion: (() -> ())? = nil) {
        fromViewController.dismiss(animated: true, completion: completion)
    }
    
    func present(crossDisolve controller: UIViewController, from fromViewController: UIViewController, completion: (() -> ())? = nil) {
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, from: fromViewController, completion: completion)
    }
    
    func withinNavigation(_ viewController: UIViewController) -> UINavigationController {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .baseNavigationBackground
        UINavigationBar.appearance().tintColor = .baseNavigationForeground
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.baseNavigationForeground,
            .font: UIFont.navigationTitle
        ]
        
        let navi = UINavigationController(rootViewController: viewController)
        viewController.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewController.navigationController?.navigationBar.layer.shadowOpacity = 0.07
        viewController.navigationController?.navigationBar.layer.shadowRadius = 2
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backButton
        
        return navi
    }
}
