//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol Anchorable {
    
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var leftAnchor: NSLayoutXAxisAnchor { get }
    
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    
    var heightAnchor: NSLayoutDimension { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: Anchorable {
}

extension UILayoutGuide: Anchorable {
}

enum LayoutConstraintOperator {
    case equal
    case greater
    case less
}

extension Anchorable {
    
    func addConstraint(topSpaceTo target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: topAnchor, to: targetOrSuperview(target).topAnchor, operator: ope, priority: priority)
    }
    
    func addConstraint(bottomSpaceTo target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: bottomAnchor, to: targetOrSuperview(target).bottomAnchor, operator: ope, priority: priority)
    }
    
    func addConstraint(leadingSpaceTo target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: leadingAnchor, to: targetOrSuperview(target).leadingAnchor, operator: ope, priority: priority)
    }
    
    func addConstraint(trailingSpaceTo target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: trailingAnchor, to: targetOrSuperview(target).trailingAnchor, operator: ope, priority: priority)
    }
}

extension Anchorable {
    
    func addConstraint(height constant: CGFloat, operator ope: LayoutConstraintOperator = .equal, multiplier: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, dimension: heightAnchor, operator: ope, multiplier: multiplier, priority: priority)
    }
    
    func addConstraint(width constant: CGFloat, operator ope: LayoutConstraintOperator = .equal, multiplier: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, dimension: widthAnchor, operator: ope, multiplier: multiplier, priority: priority)
    }
}

extension Anchorable {
    
    typealias DirectionLayoutConstraints = (
        horizontal: NSLayoutConstraint?,
        vertical: NSLayoutConstraint?
    )
    
    func addConstraint(centerXOf target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: centerXAnchor, to: targetOrSuperview(target).centerXAnchor, operator: ope, priority: priority)
    }
    
    func addConstraint(centerYOf target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: centerYAnchor, to: targetOrSuperview(target).centerYAnchor, operator: ope, priority: priority)
    }
    
    func addConstraint(centerOf target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> DirectionLayoutConstraints {
        return DirectionLayoutConstraints(
            horizontal: addConstraint(centerXOf: target, constant: constant, operator: ope, priority: priority),
            vertical: addConstraint(centerYOf: target, constant: constant, operator: ope, priority: priority)
        )
    }
}

extension Anchorable {
    
    typealias SideLayoutConstraints = (
        top: NSLayoutConstraint?,
        trailing: NSLayoutConstraint?,
        bottom: NSLayoutConstraint?,
        leading: NSLayoutConstraint?
    )
    
    func addConstraint(top: CGFloat?, trailing: CGFloat?, bottom: CGFloat?, leading: CGFloat?, to target: Anchorable?, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> SideLayoutConstraints {
        var ret = SideLayoutConstraints(top: nil, trailing: nil, bottom: nil, leading: nil)
        if top != nil {
            ret.top = addConstraint(topSpaceTo: target, constant: top!, operator: ope, priority: priority)
        }
        if trailing != nil {
            ret.trailing = addConstraint(trailingSpaceTo: target, constant: trailing!, operator: ope, priority: priority)
        }
        if bottom != nil {
            ret.bottom = addConstraint(bottomSpaceTo: target, constant: bottom!, operator: ope, priority: priority)
        }
        if leading != nil {
            ret.leading = addConstraint(leadingSpaceTo: target, constant: leading!, operator: ope, priority: priority)
        }
        return ret
    }
    
    func addConstraint(allSideSpaceTo target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> SideLayoutConstraints {
        return addConstraint(
            top:      constant,
            trailing: constant,
            bottom:   constant,
            leading:  constant,
            to:       target,
            operator: ope,
            priority: priority
        )
    }
}

extension Anchorable {
    
    func addConstraint(topToBottomOf target: Anchorable?, constant: CGFloat = 0, operator ope: LayoutConstraintOperator = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return addConstraint(constant: constant, from: topAnchor, to: targetOrSuperview(target).bottomAnchor, operator: ope, priority: priority)
    }
    
    /*
    layout_constraintEnd_toStartOf    指定したViewの左側に配置    layout_toStartOf
    layout_constraintStart_toEndOf    指定したViewの右側に配置    layout_toEndOf
    layout_constraintRight_toLeftOf    指定したViewの左側に配置    layout_toLeftOf
    layout_constraintLeft_toRightOf    指定したViewの右側に配置    layout_toRightOf
    layout_constraintBottom_toTopOf    指定したViewの上側に配置    layout_above
    layout_constraintTop_toBottomOf
    */
}

private extension Anchorable {
    
    func addConstraint<T>(constant: CGFloat, from source: NSLayoutAnchor<T>, to target: NSLayoutAnchor<T>, operator constraintOperator: LayoutConstraintOperator, priority: UILayoutPriority) -> NSLayoutConstraint {
        prepareConstraint()
        let constraint: NSLayoutConstraint
        switch constraintOperator {
        case .equal:
            constraint = source.constraint(equalTo: target, constant: constant)
        case .greater:
            constraint = source.constraint(greaterThanOrEqualTo: target, constant: constant)
        case .less:
            constraint = source.constraint(lessThanOrEqualTo: target, constant: constant)
        }
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func addConstraint(constant: CGFloat, dimension: NSLayoutDimension, operator constraintOperator: LayoutConstraintOperator, multiplier: CGFloat = 0, priority: UILayoutPriority) -> NSLayoutConstraint {
        prepareConstraint()
        let constraint: NSLayoutConstraint
        switch constraintOperator {
        case .equal:
            constraint = dimension.constraint(equalTo: dimension, multiplier: multiplier, constant: constant)
        case .greater:
            constraint = dimension.constraint(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: constant)
        case .less:
            constraint = dimension.constraint(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: constant)
        }
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func prepareConstraint() {
        if let view = self as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func targetOrSuperview(_ target: Anchorable?) -> Anchorable {
        if let ret = target {
            return ret
        }
        if let view = self as? UIView, let ret = view.superview {
            return ret
        }
        fatalError("Anchorable: Not exists target or superview.")
    }
}
