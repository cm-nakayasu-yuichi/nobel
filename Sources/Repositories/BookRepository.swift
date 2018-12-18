//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol BookInteractorInput: class {
    
    var output: BookInteractorOutput! { get set }
    
    func load()
    func create()
    func add(book: Book)
    func update(book: Book)
    func delete(book: Book)
}

protocol BookInteractorOutput: class {
    
    func created(newBook: Book)
    func loaded(books: [Book])
}

class BookRepository: BookInteractorInput {
    
    weak var output: BookInteractorOutput!
    
    func load() {
        let realmObjects = Realm
            .select(from: DBBook.self, predicate: nil)
            .sorted(byKeyPath: "sort", ascending: true)
            .array
        let books = BookTranslator().translate(realmObjects)
        output.loaded(books: books)
    }
    
    func create() {
        let book = BookTranslator().translate(DBBook())
        book.id = ""
        book.name = "新しい作品"
        output.created(newBook: book)
    }
    
    func add(book: Book) {
        
    }
    
    func update(book: Book) {
        
    }
    
    func delete(book: Book) {
        
    }
}
