//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class SentenceTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = SentenceEntity
    typealias Output = Sentence
    
    func translate(_ input: SentenceEntity) -> Sentence {
        let ret = Sentence()
        
        ret.id = input.id
        ret.title = input.title
        
        return ret
    }
    
    func detranslate(_ output: Sentence) -> SentenceEntity {
        return SentenceEntity(
            id: output.id,
            title: output.title
        )
    }
}
