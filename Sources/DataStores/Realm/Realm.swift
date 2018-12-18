//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import RealmSwift

class Realm {
    
    /// Realmファイルのパス
    static var path: String {
        return RealmSwift.Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
    }
    
    private static var _realm: RealmSwift.Realm!
    
    private static var realm: RealmSwift.Realm! {
        if _realm == nil {
            _realm = try! RealmSwift.Realm()
        }
        return _realm
    }
}

extension Realm {
    
    /// オブジェクトの作成
    /// - Parameter type: 作成するオブジェクトの型
    /// - Returns: オブジェクト
    class func create<T>(_ type: T.Type) -> T where T: RealmSwift.Object {
        return realm.create(type)
    }
}

extension Realm {
    
    /// データの取得
    /// - Parameters:
    ///   - type: 取得するオブジェクトの型
    ///   - predicate: 条件
    /// - Returns: 取得したデータ
    class func select<T>(from type: T.Type, predicate: NSPredicate? = nil) -> RealmSwift.Results<T> where T: RealmSwift.Object {
        var results = realm.objects(type)
        if let predicate = predicate {
            results = results.filter(predicate)
        }
        return results
    }
    
    /// データの件数取得
    /// - Parameters:
    ///   - type: 取得するオブジェクトの型
    ///   - predicate: 条件
    /// - Returns: データの件数
    class func count<T>(of type: T.Type, predicate: NSPredicate? = nil) -> Int where T: RealmSwift.Object {
        return select(from: type, predicate: predicate).count
    }
}

extension Realm {
    
    /// オブジェクトの保存
    /// - Parameter object: オブジェクト
    class func save<T>(_ object: T) where T: RealmSwift.Object {
        save([object])
    }
    
    /// オブジェクトの保存
    /// - Parameter objects: オブジェクトの配列
    class func save<T>(_ objects: [T]) where T: RealmSwift.Object {
        let r = realm!
        try! r.write {
            r.add(objects, update: true)
        }
    }
}

extension Realm {

    /// オブジェクトの追加
    /// - Parameter object: オブジェクト
    class func insert<T>(_ object: T) where T: RealmSwift.Object {
        insert([object])
    }
    
    /// オブジェクトの追加
    /// - Parameter objects: オブジェクトの配列
    class func insert<T>(_ objects: [T]) where T: RealmSwift.Object {
        let r = realm!
        var i = 0, id = 0
        try! r.write {
            for object in objects {
                if var identifiedObject = object as? RealmIncrementableIdentifiedObject {
                    if i == 0 {
                        id = identifiedObject.id
                    } else {
                        id += 1
                        identifiedObject.id = id
                    }
                }
                r.add(object, update: true)
                i += 1
            }
        }
    }
}

extension Realm {
    
    /// オブジェクトの削除
    /// - Parameters:
    ///   - type: 削除するオブジェクトの型
    ///   - predicate: 条件
    class func delete<T>(for type: T.Type, predicate: NSPredicate? = nil) where T: RealmSwift.Object {
        let r = realm!
        try! r.write {
            if let predicate = predicate {
                r.delete(r.objects(T.self).filter(predicate))
            } else {
                r.delete(r.objects(T.self))
            }
        }
    }
}

extension Realm {
    
    /// オブジェクトの更新
    /// - Parameters:
    ///   - type: 更新するオブジェクトの型
    ///   - predicate: 条件
    ///   - updating: 更新処理
    class func update<T>(for type: T.Type, predicate: NSPredicate?, updating: @escaping (T, Int) -> Void) where T: RealmSwift.Object {
        let r = realm!
        try! r.write {
            let results: RealmSwift.Results<T>
            if let predicate = predicate {
                results = r.objects(T.self).filter(predicate)
            } else {
                results = r.objects(T.self)
            }
            
            var i = 0
            for object in results {
                updating(object, i)
                i += 1
            }
        }
    }
}

extension Realm {
    
    /// トランザクションの開始
    class func begin() {
        realm.beginWrite()
    }
    
    /// トランザクションの確定
    class func commit(withoutNotifying tokens: [NotificationToken] = []) {
        try? realm.commitWrite(withoutNotifying: tokens)
    }
    
    /// トランザクションの中止
    class func rollback() {
        realm.cancelWrite()
    }
    
    /// トランザクション中かどうか
    static var inTransaction: Bool {
        return realm.isInWriteTransaction
    }
}
