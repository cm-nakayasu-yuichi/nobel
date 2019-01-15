//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ShelfInteractorInput: class {
    
    var output: ShelfInteractorOutput! { get set }
    
    func load()
    func addNewBook()
    func update(book: Book)
    func delete(book: Book)
}

protocol ShelfInteractorOutput: class {
    
    func added(newBook: Book)
    func loaded(shelf: [Book])
}

class ShelfRepository: ShelfInteractorInput {
    
    weak var output: ShelfInteractorOutput!
    
    func load() {
        let entities = loadBookEntities()
        output.loaded(shelf: BookTranslator().translate(entities))
    }
    
    func addNewBook() {
        let book = createNewBook()
        let entity = BookTranslator().detranslate(book)
        
        var entities = loadBookEntities()
        entities.append(entity)
        saveBookEntities(entities)
        
        output.added(newBook: book)
    }
    
    func update(book: Book) {
        
    }
    
    func delete(book: Book) {
        
    }
}

extension ShelfRepository {
    
    private var shelfJsonFile: File {
        let file = File.documentDirectory.append(pathComponent: "shelf.json")
        if !file.exists {
            try? file.write(contents: "[]")
        }
        return file
    }
    
    private func saveBookEntities(_ entities: [BookEntity]) {
        let encoded = Json().encode(entities)
        try? shelfJsonFile.write(contents: encoded)
    }
    
    private func loadBookEntities() -> [BookEntity] {
        return Json().decode(path: shelfJsonFile.path, to: [BookEntity].self) ?? []
    }
}

extension ShelfRepository: IdentifierGeneratable {
    
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
