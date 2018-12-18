//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class ChapterTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = DBChapter
    typealias Output = Chapter
    
    func translate(_ input: DBChapter) -> Chapter {
        let ret = Chapter()
        
        ret.id = input.id
        ret.name = input.name
        ret.sort = input.sort
        ret.sentences = SentenceTranslator().translate(input.sentences.array)
        ret.book = BookTranslator().translate(input.linkingBook.first!)
        
        return ret
    }
    
    func detranslate(_ output: Chapter) -> DBChapter {
        let ret = DBChapter()
        
        ret.id = output.id
        ret.name = output.name
        ret.sort = output.sort
        ret.sentences.set(SentenceTranslator().detranslate(output.sentences))
        
        return ret
    }
}
