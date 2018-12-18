//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol SentenceInteractorInput: class {
    
    var output: SentenceInteractorOutput! { get set }
    
    func load(of chapter: Chapter)
    func create()
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
    
    func create() {
        
    }
    
    func add(sentence: Sentence) {
        
    }
    
    func update(sentence: Sentence) {
        
    }
    
    func delete(sentence: Sentence) {
        
    }
}
