//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import RealmSwift

protocol RealmSortableObject {
    
    var sort: Int { get set }
}

extension RealmSortableObject where Self: RealmSwift.Object {
    
    static func nextSortNumber() -> Int {
        guard
            let realm = try? RealmSwift.Realm(),
            let max = realm.objects(Self.self).sorted(byKeyPath: "sort", ascending: false).first
            else {
                return 1
        }
        return max.sort + 1
    }
}

extension RealmSwift.Results where Element: RealmSortableObject {
    
    func sorted(_ ascending: Bool = true) -> RealmSwift.Results<Element> {
        return sorted(byKeyPath: "sort", ascending: ascending)
    }
}
