//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ChapterInteractorInput: class {
    
    var output: ChapterInteractorOutput! { get set }
    
    func create() -> Chapter
    func load(chaptersOf book: Book)
    func addNewChapter(to book: Book)
    func add(chapter: Chapter, to book: Book)
    func update(chapter: Chapter)
    func delete(chapter: Chapter)
}

protocol ChapterInteractorOutput: class {
    
    func loaded(chapters: [Chapter])
}

class ChapterRepository: ChapterInteractorInput {
    
    weak var output: ChapterInteractorOutput!
    
    private func chaptersOf(_ book: Book) -> [Chapter] {
        guard let dbBook = storedBook(book) else {
            return []
        }
        let dbChapters = dbBook.chapters.numberSorted().array
        return ChapterTranslator().translate(dbChapters).apply {
            $0.book = book
        }
    }
    
    private func storedBook(_ book: Book) -> DBBook? {
        let predicate = NSPredicate(id: book.id)
        return Realm.select(from: DBBook.self, predicate: predicate).first
    }
    
    func create() -> Chapter {
        let chapter = Chapter()
        chapter.id = DBChapter.generateId()
        chapter.name = "第一章 新しい章"
        return chapter
    }
    
    func load(chaptersOf book: Book) {
        let chapters = chaptersOf(book)
        output.loaded(chapters: chapters)
    }
    
    func addNewChapter(to book: Book) {
        let chapter = create()
        if let max = storedBook(book)?.chapters.numberSorted().first {
            chapter.sort = max.sort + 1
        } else {
            chapter.sort = 1
        }
        add(chapter: chapter, to: book)
    }
    
    func add(chapter: Chapter, to book: Book) {
        book.chapters.append(chapter)
        let dbBook = BookTranslator().detranslate(book)
        Realm.save(dbBook)
        output.loaded(chapters: chaptersOf(book))
    }
    
    func update(chapter: Chapter) {
        
    }
    
    func delete(chapter: Chapter) {
        
    }
}
