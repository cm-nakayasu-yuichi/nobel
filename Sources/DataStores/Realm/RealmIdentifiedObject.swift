//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import RealmSwift

protocol RealmIdentifiedObject {
    
    var id: String { get set }
}

protocol RealmIncrementableIdentifiedObject {
    
    var id: Int { get set }
}

extension RealmIdentifiedObject where Self: RealmSwift.Object {
    
    static func generateId() -> String {
        return "" // TODO:
    }
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
    
    func incrementedId() -> Int {
        guard
            let realm = try? RealmSwift.Realm(),
            let max = realm.objects(Self.self).sorted(byKeyPath: "id", ascending: false).first
            else {
                return 1
        }
        return max.id + 1
    }
}

extension NSPredicate {
    
    convenience init(id: String) {
        self.init(format: "id = %@", argumentArray: [id])
    }
    
    convenience init(ids: [String]) {
        self.init(format: "id IN %@", argumentArray: [ids])
    }
}
