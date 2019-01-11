//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol SentenceInteractorInput: class {
    
    var output: SentenceInteractorOutput! { get set }
    
    func load(of chapter: Chapter)
    func create(of chapter: Chapter?)
    func add(sentence: Sentence)
    func update(sentence: Sentence)
    func delete(sentence: Sentence)
}

protocol SentenceInteractorOutput: class {
    
    func created(newSentence: Sentence)
    func loaded(sentences: [Sentence])
}

class SentenceRepository: SentenceInteractorInput {
    
    weak var output: SentenceInteractorOutput!
    
    func load(of chapter: Chapter) {
        
    }
    
    func create(of chapter: Chapter?) {
        let sentence = createNewSentence(of: chapter)
        output.created(newSentence: sentence)
    }
    
    func add(sentence: Sentence) {
        
    }
    
    func update(sentence: Sentence) {
        
    }
    
    func delete(sentence: Sentence) {
        
    }
}

extension SentenceRepository: IdentifierGeneratable {
    
    private func createNewSentence(of chapter: Chapter?) -> Sentence {
        let sentence = Sentence()
        sentence.id = generateId()
        sentence.title = "新しい文章"
        sentence.chapter = chapter
        return sentence
    }
}
