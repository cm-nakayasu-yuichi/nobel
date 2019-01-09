//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol BookRepositoryInteractorInput: class {
    
    var output: BookRepositoryInteractorOutput! { get set }
    
    func load()
    func create()
    func add(book: Book)
    func update(book: Book)
    func delete(book: Book)
}

protocol BookRepositoryInteractorOutput: class {
    
    func created(newBook: Book)
    func loaded(books: [Book])
}

class BookRepositoryRepository: BookRepositoryInteractorInput {
    
    weak var output: BookRepositoryInteractorOutput!
    
    func load() {
        
    }
    
    func create() {
        
    }
    
    func add(book: Book) {
        
    }
    
    func update(book: Book) {
        
    }
    
    func delete(book: Book) {
        
    }
}
