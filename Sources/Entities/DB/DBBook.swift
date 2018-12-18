//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import RealmSwift

class DBBook: RealmSwift.Object, RealmIdentifiedObject {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var author = ""
    @objc dynamic var outlineTitle = ""
    @objc dynamic var outline = ""
    @objc dynamic var bookmarkedChapterIndex = 0
    @objc dynamic var bookmarkedPageIndex = 0
    @objc dynamic var isLocked = false
    @objc dynamic var colorTheme = ColorTheme.standard.rawValue
    @objc dynamic var textSize = TextSize.standard.rawValue
    @objc dynamic var fontType = FontType.standard.rawValue
    @objc dynamic var sort = 0
    
    var chapters = RealmSwift.List<DBChapter>()
    
    override static func primaryKey() -> String? { return "id" }
}
