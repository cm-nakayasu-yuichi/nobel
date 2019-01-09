//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class ChapterTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = ChapterEntity
    typealias Output = Chapter
    
    func translate(_ input: ChapterEntity) -> Chapter {
        let ret = Chapter()
        
        ret.id = input.id
        ret.title = input.title
        ret.sentences = SentenceTranslator().translate(input.sentences)
        
        ret.sentences = SentenceTranslator().translate(input.sentences).map { (sentence: Sentence) -> Sentence in
            sentence.chapter = ret
            return sentence
        }
        
        return ret
    }
    
    func detranslate(_ output: Chapter) -> ChapterEntity {
        return ChapterEntity(
            id: output.id,
            title: output.title,
            sentences: SentenceTranslator().detranslate(output.sentences)
        )
    }
}
