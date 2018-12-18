//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

extension NSPredicate {
    
    static var empty: NSPredicate {
        return NSPredicate(value: true)
    }
    
    static var dead: NSPredicate {
        return NSPredicate(value: false)
    }
}

extension NSPredicate {
    
    static func compounded(_ type: NSCompoundPredicate.LogicalType = .and, _ predicates: [NSPredicate]) -> NSPredicate {
        switch type {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or:  return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        case .not: return NSCompoundPredicate(notPredicateWithSubpredicate: compounded(.and, predicates))
        }
    }
    
    func and(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound([predicate], type: .and)
    }
    
    func or(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound([predicate], type: .or)
    }
    
    func not(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound([predicate], type: .not)
    }
    
    func compound(_ predicates: [NSPredicate], type: NSCompoundPredicate.LogicalType = .and) -> NSPredicate {
        var p = predicates; p.insert(self, at: 0)
        return NSPredicate.compounded(type, p)
    }
}

extension NSPredicate {
    
    convenience init(_ property: String, equal value: Any) {
        self.init(expression: property, "=", value)
    }
    
    convenience init(_ property: String, notEqual value: Any) {
        self.init(expression: property, "!=", value)
    }
    
    convenience init(_ property: String, lessThan value: Any) {
        self.init(expression: property, "<", value)
    }
    
    convenience init(_ property: String, equalOrLessThan value: Any) {
        self.init(expression: property, "<=", value)
    }
    
    convenience init(_ property: String, greaterThan value: Any) {
        self.init(expression: property, ">", value)
    }
    
    convenience init(_ property: String, equalOrGreaterThan value: Any) {
        self.init(expression: property, ">=", value)
    }
    
    convenience init(_ property: String, contains q: String) {
        self.init(format: "\(property) CONTAINS '\(q)'")
    }
    
    convenience init(_ property: String, beginsWith q: String) {
        self.init(format: "\(property) BEGINSWITH '\(q)'")
    }
    
    convenience init(_ property: String, endsWith q: String) {
        self.init(format: "\(property) ENDSWITH '\(q)'")
    }
    
    convenience init(_ property: String, valuesIn values: [Any]) {
        self.init(format: "\(property) IN %@", argumentArray: [values])
    }
    
    convenience init(_ property: String, between min: Any, to max: Any) {
        self.init(format: "\(property) BETWEEN {%@, %p}", argumentArray: [min, max])
    }
    
    convenience init(isNil property: String) {
        self.init(format: "\(property) == nil", argumentArray: nil)
    }
    
    convenience init(isNotNil property: String) {
        self.init(format: "\(property) != nil", argumentArray: nil)
    }
}

private extension NSPredicate {
    
    convenience init(expression property: String, _ operation: String, _ value: Any) {
        self.init(format: "\(property) \(operation) %@", argumentArray: [value])
    }
}
