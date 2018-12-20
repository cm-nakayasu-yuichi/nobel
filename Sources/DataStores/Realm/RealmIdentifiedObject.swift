//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import RealmSwift
import CommonCrypto

protocol RealmIdentifiedObject {
    
    var id: String { get set }
}

extension RealmIdentifiedObject where Self: RealmSwift.Object {
    
    static func generateId(_ number: Int = 1) -> String {
        let seed = hashSeed(number: number)
        return hash(string: seed).uppercased()
    }
    
    private static func hashSeed(number: Int = 1) -> String {
        return Int.random(min: 1000, max: 9999).string + number.string + Int(Date().timeIntervalSince1970).string
    }
    
    private static func hash(string: String) -> String {
        let capacity = Int(CC_SHA256_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: capacity)
        
        guard let data = string.data(using: .utf8) else { return "" }
        
        var ret = ""
        data.withUnsafeBytes() { (bytes: UnsafePointer<CChar>) -> () in
            CC_SHA256(bytes, CC_LONG(data.count), buffer)
            ret = (0..<capacity).reduce("") { str, i in
                str + String(format: "%02x", buffer[i])
            }
        }
        return ret
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
