//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol LaunchPresenterProtocol: class {
    
    var view: LaunchViewProtocol! { get set }
    var interactor: LaunchInteractorInput! { get set }
    
    func launch()
}

protocol LaunchViewProtocol: class {
    
    func showMain()
    func showTerms()
    func showTutorial()
}

class LaunchPresenter: LaunchPresenterProtocol {

    weak var view: LaunchViewProtocol!
    
    var interactor: LaunchInteractorInput!
    
    func launch() {
        interactor.requestIsFirstLaunch()
    }
}

extension LaunchPresenter: LaunchInteractorOutput {

    func responseIsFirstLaunch(_ isFirstLaunch: Bool) {
        if isFirstLaunch {
            view.showTutorial()
            return
        }
        interactor.requestIsAgreeTerms()
    }
    
    func responseIsAgreeTerms(_ isAgreeTerms: Bool) {
        if !isAgreeTerms {
            view.showTerms()
            return
        }
        view.showMain()
    }
}
