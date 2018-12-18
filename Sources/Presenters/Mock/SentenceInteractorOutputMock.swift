//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class SentenceInteractorOutputMock: SentenceInteractorOutput {
    
    let interactor: SentenceInteractorInput
    
    init() {
        self.interactor = SentenceRepository()
        self.interactor.output = self
    }
    
    func created(newSentence: Sentence) {
        
    }
    
    func loaded(sentences: [Sentence]) {
        
    }
}
