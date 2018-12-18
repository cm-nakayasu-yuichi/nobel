//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import CoreGraphics

extension CGRect {
    
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
    
    init(_ x: CGFloat, _ y: CGFloat, _ size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }
    
    init(_ origin: CGPoint, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: origin.x, y: origin.y, width: width, height: height)
    }
    
    init(_ origin: CGPoint) {
        self.init(origin: origin, size: .zero)
    }
    
    init(_ size: CGSize) {
        self.init(origin: .zero, size: size)
    }
}

extension CGPoint {
    
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(lhs.x * rhs, lhs.y * rhs)
    }
    
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(lhs.x / rhs, lhs.y / rhs)
    }
}

extension CGSize {
    
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
    
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(lhs.width + rhs.width, lhs.height + rhs.height)
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(lhs.width - rhs.width, lhs.height - rhs.height)
    }
    
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(lhs.width * rhs, lhs.height * rhs)
    }
    
    static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(lhs.width / rhs, lhs.height / rhs)
    }
    
    func center(of size: CGSize) -> CGRect {
        return CGRect(
            (size.width - width) / 2,
            (size.height - height) / 2,
            self
        )
    }
}
