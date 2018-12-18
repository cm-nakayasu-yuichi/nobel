//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

@objcMembers class Configurable: NSObject {
    
    override init() {
        super.init()
        registerDefaultValues()
        setUserDefaultsValueToProperties()
        addObserversForProperties()
    }
    
    private var propertyNames: [String] {
        return Mirror(reflecting: self).children.compactMap {
            return $0.label
        }
    }
    
    private func addObserversForProperties() {
        propertyNames.forEach { propertyName in
            addObserver(self, forKeyPath: propertyName, options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let propertyName = keyPath else { return }
        
        let key = userDefaultsKey(for: propertyName)
        let newValue = change?[.newKey]
        UserDefaults.standard.set(newValue, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private var domain: String {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let className = String(describing: type(of: self))
        return "\(bundleIdentifier).\(className)"
    }
    
    private func userDefaultsKey(for propertyName: String) -> String {
        return "\(domain).\(propertyName)"
    }
    
    private func setUserDefaultsValueToProperties() {
        propertyNames.forEach { propertyName in
            let key = userDefaultsKey(for: propertyName)
            let value = UserDefaults.standard.object(forKey: key)
            setValue(value, forKey: propertyName)
        }
    }
    
    private func registerDefaultValues() {
        UserDefaults.standard.register(defaults: propertyNames.reduce(into: [String : Any]()) { result, propertyName in
            if let value = value(forKey: propertyName) {
                result[userDefaultsKey(for: propertyName)] = value
            }
        })
    }
}

