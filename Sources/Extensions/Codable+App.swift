//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension Decodable {
    
    static func create() -> Self {
        let emptyJsonData = "{}".data(using: .utf8)!
        return try! JSONDecoder().decode(self, from: emptyJsonData)
    }
}

extension KeyedDecodingContainerProtocol {
    
    func to<T>(_ type: T.Type, _ key: Key, _ substitute: T) -> T where T: Decodable {
        guard let tmp = try? decodeIfPresent(type, forKey: key), let ret = tmp else {
            return substitute
        }
        return ret
    }
    
    func toOrNil<T>(_ type: T.Type, _ key: Key) -> T? where T: Decodable {
        guard let ret = try? decodeIfPresent(type, forKey: key) else {
            return nil
        }
        return ret
    }
    
    func string(_ key: Key, _ substitute: String = "") -> String {
        return to(String.self, key, substitute)
    }
    
    func stringOrNil(_ key: Key) -> String? {
        return toOrNil(String.self, key)
    }
    
    func int(_ key: Key, _ substitute: Int = 0) -> Int {
        return to(Int.self, key, substitute)
    }
    
    func intOrNil(_ key: Key) -> Int? {
        return toOrNil(Int.self, key)
    }
    
    func bool(_ key: Key, _ substitute: Bool = false) -> Bool {
        return to(Bool.self, key, substitute)
    }
    
    func boolOrNil(_ key: Key) -> Bool? {
        return toOrNil(Bool.self, key)
    }
    
    func float(_ key: Key, _ substitute: Float = 0.0) -> Float {
        return to(Float.self, key, substitute)
    }
    
    func floatOrNil(_ key: Key) -> Float? {
        return toOrNil(Float.self, key)
    }
    
    func double(_ key: Key, _ substitute: Double = 0.0) -> Double {
        return to(Double.self, key, substitute)
    }
    
    func doubleOrNil(_ key: Key) -> Double? {
        return toOrNil(Double.self, key)
    }
    
    func cgfloat(_ key: Key, _ substitute: CGFloat = 0) -> CGFloat {
        return to(CGFloat.self, key, substitute)
    }
    
    func cgfloatOrNil(_ key: Key) -> CGFloat? {
        return toOrNil(CGFloat.self, key)
    }
    
    func cgRect(_ key: Key, _ substitute: CGRect = .zero) -> CGRect {
        return to(CGRect.self, key, substitute)
    }
    
    func cgRectOrNil(_ key: Key) -> CGRect? {
        return toOrNil(CGRect.self, key)
    }
    
    func cgPoint(_ key: Key, _ substitute: CGPoint = .zero) -> CGPoint {
        return to(CGPoint.self, key, substitute)
    }
    
    func cgPointOrNil(_ key: Key) -> CGPoint? {
        return toOrNil(CGPoint.self, key)
    }
    
    func cgSize(_ key: Key, _ substitute: CGSize = .zero) -> CGSize {
        return to(CGSize.self, key, substitute)
    }
    
    func cgSizeOrNil(_ key: Key) -> CGSize? {
        return toOrNil(CGSize.self, key)
    }
}
