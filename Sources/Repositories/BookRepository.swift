//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol BookRepositoryInteractorInput: class {
    
    var output: BookRepositoryInteractorOutput! { get set }
    
    func requestIsFirstLaunch()
    func requestIsAgreeTerms()
}

protocol BookRepositoryInteractorOutput: class {
    
    func responseIsFirstLaunch(_ isFirstLaunch: Bool)
    func responseIsAgreeTerms(_ isAgreeTerms: Bool)
}

class BookRepositoryRepository: BookRepositoryInteractorInput {
    
    weak var output: BookRepositoryInteractorOutput!
    
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
