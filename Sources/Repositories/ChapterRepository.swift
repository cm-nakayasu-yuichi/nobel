//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol LaunchInteractorInput: class {
    
    var output: LaunchInteractorOutput! { get set }
    
    func requestIsFirstLaunch()
    func requestIsAgreeTerms()
}

protocol LaunchInteractorOutput: class {
    
    func responseIsFirstLaunch(_ isFirstLaunch: Bool)
    func responseIsAgreeTerms(_ isAgreeTerms: Bool)
}

class LaunchRepository: LaunchInteractorInput {
    
    weak var output: LaunchInteractorOutput!
    
    func requestIsFirstLaunch() {
        let config = AppConfig()
        let isFirstLaunch = config.isFirstLaunch
        if !isFirstLaunch {
            config.isFirstLaunch = true
        }
        output.responseIsFirstLaunch(isFirstLaunch)
    }
    
    func requestIsAgreeTerms() {
        output.responseIsFirstLaunch(AppConfig().isAgreeTerms)
    }
}
