//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import RealmSwift

class DBBook: RealmSwift.Object, RealmIdentifiedObject {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var sort = 0
    
    var chapters = RealmSwift.List<DBChapter>()
    
    override static func primaryKey() -> String? { return "id" }
}
