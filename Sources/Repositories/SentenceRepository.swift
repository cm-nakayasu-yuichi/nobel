//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol SentenceInteractorInput: class {
    
    var output: SentenceInteractorOutput! { get set }
    
    func create() -> Sentence
    func load(sentencesOf chapter: Chapter)
    func addNewSentence(to chapter: Chapter)
    func add(sentence: Sentence, to chapter: Chapter)
    func update(sentence: Sentence)
    func delete(sentence: Sentence)
}

protocol SentenceInteractorOutput: class {
    
    func loaded(sentences: [Sentence])
}

class SentenceRepository: SentenceInteractorInput {
    
    weak var output: SentenceInteractorOutput!
    
    private func selectSentences(of chapter: Chapter) -> [Sentence] {
        let predicate = NSPredicate("parentChapter", equal: chapter)
        let realmObjects = Realm
            .select(from: DBSentence.self, predicate: predicate)
            .numberSorted()
            .array
        return SentenceTranslator().translate(realmObjects)
    }
    
    func create() -> Sentence {
        let sentence = SentenceTranslator().translate(DBSentence())
        sentence.id = DBSentence.generateId()
        sentence.name = "第一幕 新しい文章"
        sentence.sort = DBSentence.nextSortNumber()
        return sentence
    }
    
    func load(sentencesOf chapter: Chapter) {
        let sentences = selectSentences(of: chapter)
        output.loaded(sentences: sentences)
    }
    
    func addNewSentence(to chapter: Chapter) {
        add(sentence: create(), to: chapter)
    }
    
    func add(sentence: Sentence, to chapter: Chapter) {
        chapter.sentences.append(sentence)
        let dbChapter = ChapterTranslator().detranslate(chapter)
        Realm.save(dbChapter)
        output.loaded(sentences: selectSentences(of: chapter))
//        let dbSentence = SentenceTranslator().detranslate(sentence)
//        let dbChapter = ChapterTranslator().detranslate(chapter)
//        dbChapter.sentences.append(dbSentence)
//        Realm.save(dbChapter)
    }
    
    func update(sentence: Sentence) {
        
    }
    
    func delete(sentence: Sentence) {
        
    }
}
