//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import RealmSwift

extension RealmSwift.Results {
    
    var one: Element? {
        return first
    }
    
    var array: [Element] {
        return map { $0 }
    }
}

extension RealmSwift.List {
    
    var firstIndex: Int {
        return count > 0 ? 0 : -1
    }
    
    var lastIndex: Int {
        return count > 0 ? count - 1 : -1
    }
    
    var array: [Element] {
        return map { $0 }
    }
    
    func set(_ arrayOrNil: [Element]?) {
        removeAll()
        if let array = arrayOrNil {
            append(objectsIn: array)
        }
    }
}
