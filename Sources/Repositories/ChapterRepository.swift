//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ChapterInteractorInput: class {
    
    var output: ChapterInteractorOutput! { get set }
    
    func requestIsFirstLaunch()
    func requestIsAgreeTerms()
}

protocol ChapterInteractorOutput: class {
    
    func responseIsFirstLaunch(_ isFirstLaunch: Bool)
    func responseIsAgreeTerms(_ isAgreeTerms: Bool)
}

class ChapterRepository: ChapterInteractorInput {
    
    weak var output: ChapterInteractorOutput!
    
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
