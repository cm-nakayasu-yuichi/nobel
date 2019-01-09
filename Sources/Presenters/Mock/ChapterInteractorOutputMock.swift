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
    
    func loaded(chapters: [Chapter]) {
        print(chapters)
    }
    
    // for test
    func createTest() {
        let book = BookRepository().create()
        self.interactor.addNewChapter(to: book)
    }
}
