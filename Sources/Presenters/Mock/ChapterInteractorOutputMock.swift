//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class ChapterInteractorOutputMock: ChapterInteractorOutput {

    let interactor: ChapterInteractorInput
    
    init() {
        self.interactor = ChapterRepository()
        self.interactor.output = self
    }
    
    func created(newChapter: Chapter) {
        
    }
    
    func loaded(chapters: [Chapter]) {
        
    }
}
