//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol BookInteractorInput: class {
    
    var output: BookInteractorOutput! { get set }
    
    func loadChapters(of book: Book)
    func loadSentences(of chapter: Chapter)
    
    func addNewChapter(to book: Book)
    func addNewSentence(to chapter: Chapter)
}

protocol BookInteractorOutput: class {
    
    func added(newChapter: Chapter)
    func added(newSentence: Sentence)
    
    func loaded(chapters: [Chapter])
    func loaded(sentences: [Sentence])
}

class BookRepository: BookInteractorInput {
    
    weak var output: BookInteractorOutput!
    
    func loadChapters(of book: Book) {
        
    }
    
    func loadSentences(of chapter: Chapter) {
        
    }
    
    func addNewChapter(to book: Book) {
        let chapter = createNewChapter(of: book)
        let sentence = createNewSentence(of: chapter)
        chapter.sentences.append(sentence)
        
        let entity = ChapterTranslator().detranslate(chapter)
        
        var entities = loadChapterEntities(of: book)
        entities.append(entity)
        saveChapterEntities(entities, to: book)
    }
    
    func addNewSentence(to chapter: Chapter) {
        
        
        
        
        
        
        
    }
}

extension BookRepository {
    
    private func jsonFile(of book: Book) -> File {
        let dir = directory(of: book)
        let file = dir.append(pathComponent: "book.json")
        if !file.exists {
            try? file.write(contents: "[]")
        }
        return file
    }
    
    private func contentsFile(of sentence: Sentence, in book: Book) -> File {
        let dir = directory(of: book)
        let file = dir.append(pathComponent: "\(sentence.id!).txt")
//        if !file.exists {
//            try? file.write(contents: "")
//        }
        return file
    }
    
    private func directory(of book: Book) -> File {
        let dir = File.documentDirectory.append(pathComponent: book.id)
        if !dir.exists {
            try? dir.makeDirectory()
        }
        return dir
    }
    
    private func loadChapterEntities(of book: Book) -> [ChapterEntity] {
        return Json().decode(path: jsonFile(of: book).path, to: [ChapterEntity].self) ?? []
    }
    
    private func loadSentenceEntities(of chapter: Chapter) -> [SentenceEntity] {
        guard let book = chapter.book else {
            return []
        }
        guard let chapterEntity = loadChapterEntities(of: book).filter({ $0.id == chapter.id }).first else {
            return []
        }
        
        
        
        
//        return Json().decode(path: jsonFile(of: book).path, to: [ChapterEntity].self) ?? []
    }
    
    private func saveChapterEntities(_ entities: [ChapterEntity], to book: Book) {
        let encoded = Json().encode(entities)
        try? jsonFile(of: book).write(contents: encoded)
    }
}

extension BookRepository: IdentifierGeneratable {
    
    private func createNewChapter(of book: Book?) -> Chapter {
        let chapter = Chapter()
        chapter.id = generateId()
        chapter.title = "新しい章"
        chapter.book = book
        return chapter
    }
    
    private func createNewSentence(of chapter: Chapter?) -> Sentence {
        let sentence = Sentence()
        sentence.id = generateId()
        sentence.title = "新しい文章"
        sentence.chapter = chapter
        return sentence
    }
}
