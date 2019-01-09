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

class SentenceRepository: SentenceInteractorInput, IdentifierGeneratable {
    
    weak var output: SentenceInteractorOutput!
    
    func load(of chapter: Chapter) {
        
    }
    
    func create(of chapter: Chapter?) {
        let sentence = Sentence()
        sentence.id = generateId()
        sentence.title = "新しい文章"
        sentence.chapter = chapter
        output.created(newSentence: sentence)
    }
    
    func add(sentence: Sentence) {
        
    }
    
    func update(sentence: Sentence) {
        
    }
    
    func delete(sentence: Sentence) {
        
    }
}
