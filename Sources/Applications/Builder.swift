//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class Builder {
    
    func launch() -> LaunchViewController {
        let view = instantiate(LaunchViewController.self, storyboardName: "Launch")
        
        let presenter: LaunchPresenterProtocol = LaunchPresenter()
        presenter.view = view
        
        let interactor: LaunchInteractorInput = LaunchRepository()
        interactor.output = presenter as? LaunchInteractorOutput
        presenter.interactor = interactor
        
        view.presenter = presenter
        
        return view
    }
    
    func test() -> TestViewController {
        let view = instantiate(TestViewController.self, storyboardName: "Test")
        return view
    }
}

extension Builder {
    
    private func instantiate<T>(_ type: T.Type, storyboardName: String, identifier: String? = nil) -> T where T : UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let id = identifier {
            guard let viewController = storyboard.instantiateViewController(withIdentifier: id) as? T else {
                fatalError("failed instantiate viewController")
            }
            return viewController
        } else {
            guard let viewController = storyboard.instantiateInitialViewController() as? T else {
                fatalError("failed instantiate viewController")
            }
            return viewController
        }
    }
}
