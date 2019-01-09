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
    
    static func nextSortNumber(predicate: NSPredicate = .empty) -> Int {
        guard
            let realm = try? RealmSwift.Realm(),
            let max = realm.objects(Self.self).filter(predicate).numberSorted().first
            else {
                return 1
        }
        return max.sort + 1
    }
}

extension RealmSwift.Results where Element: RealmSortableObject {
    
    func numberSorted(_ ascending: Bool = true) -> RealmSwift.Results<Element> {
        return sorted(byKeyPath: "sort", ascending: ascending)
    }
}

extension RealmSwift.List where Element: RealmSortableObject {
    
    func numberSorted(_ ascending: Bool = true) -> RealmSwift.Results<Element> {
        return sorted(byKeyPath: "sort", ascending: ascending)
    }
}
