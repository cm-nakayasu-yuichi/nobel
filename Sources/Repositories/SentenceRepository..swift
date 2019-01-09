//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol SentenceInteractorInput: class {
    
    var output: SentenceInteractorOutput! { get set }
    
    func requestIsFirstLaunch()
    func requestIsAgreeTerms()
}

protocol SentenceInteractorOutput: class {
    
    func responseIsFirstLaunch(_ isFirstLaunch: Bool)
    func responseIsAgreeTerms(_ isAgreeTerms: Bool)
}

class SentenceRepository: SentenceInteractorInput {
    
    weak var output: SentenceInteractorOutput!
    
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
