//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol BookInteractorInput: class {
    
    var output: BookInteractorOutput! { get set }
    
    func loadShelf()
    func loadBook(id: String)
    func create()
    func addNewBook()
    func add(book: Book)
    func update(book: Book)
    func delete(book: Book)
}

protocol BookInteractorOutput: class {
    
    func created(newBook: Book)
    func loaded(shelf: [Book])
    func loaded(book: Book)
}

class BookRepository: BookInteractorInput {
    
    weak var output: BookInteractorOutput!
    
    func loadShelf() {
        let models = loadShelfModels()
        output.loaded(shelf: models)
    }
    
    func loadBook(id: String) {
        
    }
    
    func create() {
        let book = createNewBook()
        output.created(newBook: book)
    }
    
    func addNewBook() {
        let book = createNewBook()
        add(book: book)
    }
    
    func add(book: Book) {
        var entities = loadShelfEntities()
        let entity = BookTranslator().detranslate(book)
        entities.append(entity)
        saveShelfEntities(entities)
        loadShelf()
    }
    
    func update(book: Book) {
        
    }
    
    func delete(book: Book) {
        
    }
}

extension BookRepository {
    
    private var shelfJsonFile: File {
        let file = File.documentDirectory.append(pathComponent: "shelf.json")
        if !file.exists {
            try? file.write(contents: "[]")
        }
        return file
    }
    
    private func saveShelfEntities(_ entities: [BookEntity]) {
        let encoded = Json().encode(entities)
        try? shelfJsonFile.write(contents: encoded)
    }
    
    private func loadShelfEntities() -> [BookEntity] {
        return Json().decode(path: shelfJsonFile.path, to: [BookEntity].self) ?? []
    }
    
    private func loadShelfModels() -> [Book] {
        let entities = loadShelfEntities()
        return BookTranslator().translate(entities)
    }
}

extension BookRepository: IdentifierGeneratable {
    
    private func createNewBook() -> Book {
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
        return book
    }
}
