//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class SentenceTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = DBSentence
    typealias Output = Sentence
    
    func translate(_ input: DBSentence) -> Sentence {
        let ret = Sentence()
        
        ret.id = input.id
        ret.name = input.name
        ret.sort = input.sort
        ret.chapter = ChapterTranslator().translate(input.linkingChapter.first!)
        
        return ret
    }
    
    func detranslate(_ output: Sentence) -> DBSentence {
        let ret = DBSentence()
        
        ret.id = output.id
        ret.name = output.name
        ret.sort = output.sort
        
        return ret
    }
}
