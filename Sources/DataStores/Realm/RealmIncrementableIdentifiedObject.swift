//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import RealmSwift

protocol RealmIncrementableIdentifiedObject {
    
    var id: Int { get set }
}

extension NSPredicate {
    
    convenience init(id: Int) {
        self.init(format: "id = %@", argumentArray: [NSNumber(value: id)])
    }
    
    convenience init(ids: [Int]) {
        let arr = ids.map { NSNumber(value: $0) }
        self.init(format: "id IN %@", argumentArray: [arr])
    }
}

extension RealmIncrementableIdentifiedObject where Self: RealmSwift.Object {
    
    static func incrementedId() -> Int {
        guard
            let realm = try? RealmSwift.Realm(),
            let max = realm.objects(Self.self).sorted(byKeyPath: "id", ascending: false).first
            else {
                return 1
        }
        return max.id + 1
    }
}
