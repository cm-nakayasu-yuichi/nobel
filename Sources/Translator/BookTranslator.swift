//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class BookTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = DBBook
    typealias Output = Book
    
    func translate(_ input: DBBook) -> Book {
        let ret = Book()
        
        ret.id = input.id
        ret.name = input.name
        ret.author = input.author
        ret.outlineTitle = input.outlineTitle
        ret.outline = input.outline
        ret.bookmarkedChapterIndex = input.bookmarkedChapterIndex
        ret.bookmarkedPageIndex = input.bookmarkedPageIndex
        ret.isLocked = input.isLocked
        ret.colorTheme = ColorTheme(rawValue: input.colorTheme)!
        ret.textSize = TextSize(rawValue: input.textSize)!
        ret.fontType = FontType(rawValue: input.fontType)!
        ret.sort = input.sort
        ret.chapters = ChapterTranslator().translate(input.chapters.array)
        
        return ret
    }
    
    func detranslate(_ output: Book) -> DBBook {
        let ret = DBBook()
        
        ret.id = output.id
        ret.name = output.name
        ret.author = output.author
        ret.outlineTitle = output.outlineTitle
        ret.outline = output.outline
        ret.bookmarkedChapterIndex = output.bookmarkedChapterIndex
        ret.bookmarkedPageIndex = output.bookmarkedPageIndex
        ret.isLocked = output.isLocked
        ret.colorTheme = output.colorTheme.rawValue
        ret.textSize = output.textSize.rawValue
        ret.fontType = output.fontType.rawValue
        ret.sort = output.sort
        ret.chapters.set(ChapterTranslator().detranslate(output.chapters))
        
        return ret
    }
}
