//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class Json {}

extension Json {
    
    func encode<T>(_ object: T) -> String where T : Encodable {
        let data = encodeData(object)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func encodeData<T>(_ object: T) -> Data where T : Encodable {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        return (try? encoder.encode(object)) ?? Data()
    }
}

extension Json {
    
    func decode<T>(data: Data, to type: T.Type) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let ret = try? decoder.decode(type, from: data) else {
            return nil
        }
        return ret
    }
    
    func decode<T>(string: String, to type: T.Type) -> T? where T : Decodable {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return decode(data: data, to: type)
    }
    
    func decode<T>(path: String, to type: T.Type) -> T? where T : Decodable {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return decode(data: data, to: type)
    }
    
    func decode<T>(data: Data, to type: T.Type, substitute: T) -> T where T : Decodable {
        return decode(data: data, to: type) ?? substitute
    }
    
    func decode<T>(string: String, to type: T.Type, substitute: T) -> T where T : Decodable {
        return decode(string: string, to: type) ?? substitute
    }
    
    func decode<T>(path: String, to type: T.Type, substitute: T) -> T where T : Decodable {
        return decode(path: path, to: type) ?? substitute
    }
}

extension Json {
    
    func serialize<T>(_ object: T) -> String where T : Encodable {
        let data = serializeData(object)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func serializeData<T>(_ object: T) -> Data where T : Encodable {
        let options: JSONSerialization.WritingOptions = .prettyPrinted
        return (try? JSONSerialization.data(withJSONObject: object, options: options)) ?? Data()
    }
}

extension Json {
    
    func deserialize<T>(data: Data, to type: T.Type) -> T? where T : Decodable {
        let options: JSONSerialization.ReadingOptions = .allowFragments
        guard
            let object = try? JSONSerialization.jsonObject(with: data, options: options),
            let ret = object as? T
            else {
                return nil
        }
        return ret
    }
    
    func deserialize<T>(string: String, to type: T.Type) -> T? where T : Decodable {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return deserialize(data: data, to: type)
    }
    
    func deserialize<T>(path: String, to type: T.Type) -> T? where T : Decodable {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return deserialize(data: data, to: type)
    }
    
    func deserialize<T>(data: Data, to type: T.Type, substitute: T) -> T where T : Decodable {
        return deserialize(data: data, to: type) ?? substitute
    }
    
    func deserialize<T>(string: String, to type: T.Type, substitute: T) -> T where T : Decodable {
        return deserialize(string: string, to: type) ?? substitute
    }
    
    func deserialize<T>(path: String, to type: T.Type, substitute: T) -> T where T : Decodable {
        return deserialize(path: path, to: type) ?? substitute
    }
}
