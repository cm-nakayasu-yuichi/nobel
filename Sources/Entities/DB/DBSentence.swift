//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import RealmSwift

class DBSentence: RealmSwift.Object, RealmIdentifiedObject, RealmSortableObject {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var sort = 0
    
    let linkingChapter = LinkingObjects(fromType: DBChapter.self, property: "sentences")
    
    override static func primaryKey() -> String? { return "id" }
}
