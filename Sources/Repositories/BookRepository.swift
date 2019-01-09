//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol BookInteractorInput: class {
    
    var output: BookInteractorOutput! { get set }
    
    func create() -> Book
    func load()
    func addNewBook()
    func add(book: Book)
    func update(book: Book)
    func delete(book: Book)
}

protocol BookInteractorOutput: class {
    
    func loaded(books: [Book])
}

class BookRepository: BookInteractorInput {
    
    weak var output: BookInteractorOutput!
    
    private func books() -> [Book] {
        let realmObjects = Realm
            .select(from: DBBook.self, predicate: nil)
            .numberSorted()
            .array
        return BookTranslator().translate(realmObjects)
    }
    
    func create() -> Book {
        let book = BookTranslator().translate(DBBook())
        book.id = DBBook.generateId()
        book.name = "新しい作品"
        book.sort = DBBook.nextSortNumber()
        return book
    }
    
    func load() {
        output.loaded(books: books())
    }
    
    func addNewBook() {
        add(book: create())
    }
    
    func add(book: Book) {
        let object = BookTranslator().detranslate(book)
        Realm.insert(object)
        output.loaded(books: books())
    }
    
    func update(book: Book) {
        
    }
    
    func delete(book: Book) {
        
    }
}
