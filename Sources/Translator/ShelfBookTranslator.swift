//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class ShelfBookTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = ShelfBookEntity
    typealias Output = ShelfBook
    
    func translate(_ input: ShelfBookEntity) -> ShelfBook {
        let ret = ShelfBook()
        
        ret.id = input.id
        ret.title = input.title
        ret.author = input.author
        
        return ret
    }
    
    func detranslate(_ output: ShelfBook) -> ShelfBookEntity {
        return ShelfBookEntity(
            id: output.id,
            title: output.title,
            author: output.author
        )
    }
}
