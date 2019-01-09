//
//  NewProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class BookTranslator: MultiTranslator, MultiDetranslator {
    typealias Input = BookEntity
    typealias Output = Book
    
    func translate(_ input: BookEntity) -> Book {
        let ret = Book()
        
        ret.id = input.id
        ret.title = input.title
        ret.author = input.author
        ret.outlineTitle = input.outlineTitle
        ret.outline = input.outline
        ret.bookmarkedChapterIndex = input.bookmarkedChapterIndex
        ret.bookmarkedPageIndex = input.bookmarkedPageIndex
        ret.isLocked = input.isLocked
        ret.colorTheme = ColorTheme(rawValue: input.colorTheme)!
        ret.textSize = TextSize(rawValue: input.textSize)!
        ret.fontType = FontType(rawValue: input.fontType)!
        
        ret.chapters = ChapterTranslator().translate(input.chapters).map { (chapter: Chapter) -> Chapter in
            chapter.book = ret
            return chapter
        }
        
        return ret
    }
    
    func detranslate(_ output: Book) -> BookEntity {
        return BookEntity(
            id: output.id,
            title: output.title,
            chapters: ChapterTranslator().detranslate(output.chapters),
            author: output.author,
            outlineTitle: output.outlineTitle,
            outline: output.outline,
            bookmarkedChapterIndex: output.bookmarkedChapterIndex,
            bookmarkedPageIndex: output.bookmarkedPageIndex,
            isLocked: output.isLocked,
            colorTheme: output.colorTheme.rawValue,
            textSize: output.textSize.rawValue,
            fontType: output.fontType.rawValue
        )
    }
}
