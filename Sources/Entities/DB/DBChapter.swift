//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import RealmSwift

class DBChapter: RealmSwift.Object, RealmIdentifiedObject, RealmSortableObject {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var sort = 0
    
    var sentences = RealmSwift.List<DBSentence>()
    
    let parentBook = LinkingObjects(fromType: DBBook.self, property: "chapters")
    
    override static func primaryKey() -> String? { return "id" }
}
