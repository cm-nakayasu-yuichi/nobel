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

class BookRepositoryRepository: BookRepositoryInteractorInput, IdentifierGeneratable {
    
    weak var output: BookRepositoryInteractorOutput!
    
    func load() {
        
    }
    
    func create() {
        let book = Book()
        book.id = generateId()
        book.title = "新しい書籍"
        book.author = "" // TODO: アプリ設定から取得
        book.outlineTitle = ""
        book.outline = ""
        book.bookmarkedChapterIndex = 0
        book.bookmarkedPageIndex = 0
        book.isLocked = false
        book.colorTheme = ColorTheme.standard
        book.textSize = TextSize.standard
        book.fontType = FontType.standard
        book.chapters = []
        
        output.created(newBook: book)
    }
    
    func add(book: Book) {
        
    }
    
    func update(book: Book) {
        
    }
    
    func delete(book: Book) {
        
    }
}
