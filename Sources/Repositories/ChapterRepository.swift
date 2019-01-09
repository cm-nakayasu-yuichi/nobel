//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol ChapterInteractorInput: class {
    
    var output: ChapterInteractorOutput! { get set }
    
    func load(of book: Book)
    func create(of book: Book?)
    func add(chapter: Chapter)
    func update(chapter: Chapter)
    func delete(chapter: Chapter)
}

protocol ChapterInteractorOutput: class {
    
    func created(newChapter: Chapter)
    func loaded(chapters: [Chapter])
}

class ChapterRepository: ChapterInteractorInput, IdentifierGeneratable {
    
    weak var output: ChapterInteractorOutput!
    
    func load(of book: Book) {
        
    }
    
    func create(of book: Book?) {
        let chapter = Chapter()
        chapter.id = generateId()
        chapter.title = "新しい章"
        chapter.book = book
        output.created(newChapter: chapter)
    }
    
    func add(chapter: Chapter) {
        
    }
    
    func update(chapter: Chapter) {
        
    }
    
    func delete(chapter: Chapter) {
        
    }

}
