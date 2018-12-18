//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class LaunchViewController: UIViewController {
    
    var presenter: LaunchPresenterProtocol!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.launch()
    }
}

extension LaunchViewController: LaunchViewProtocol {

    func showMain() {
        print(2)
    }
    
    func showTerms() {
        //Wireframe.showTerms(from: self)
    }
    
    func showTutorial() {
        //Wireframe.showTutorial(from: self)
    }
}
