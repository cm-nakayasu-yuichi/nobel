//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class BookInteractorOutputMock {
    
    private var repository: BookInteractorInput
    
    init() {
        self.repository = BookRepository()
        self.repository.output = self
    }
    
    func addBook() {
        repository.addNewBook()
    }
}

extension BookInteractorOutputMock: BookInteractorOutput {
    
    func created(newBook: Book) {
        
    }
    
    func loaded(shelf: [ShelfBook]) {
        
    }
    
    func loaded(book: Book) {
        
    }
}
