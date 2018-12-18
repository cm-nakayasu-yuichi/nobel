//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class BookInteractorOutputMock: BookInteractorOutput {
    
    let interactor: BookInteractorInput
    
    init() {
        self.interactor = BookRepository()
        self.interactor.output = self
    }
    
    func created(newBook: Book) {
        print(newBook)
    }
    
    func loaded(books: [Book]) {
        print(books)
    }
}
