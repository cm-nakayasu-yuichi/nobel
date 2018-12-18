//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class UnhighlightCell: UITableViewCell {
    
    private struct ShadowInfo {
        let color: CGColor
        let offset: CGSize
        let opacity: Float
        let radius: CGFloat
    }
    
    private var backgroundColoredViews = [UIView : UIColor]()
    private var shadowedViews = [UIView : ShadowInfo]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBackgroundColoredSubviews(of: contentView)
        addShadowedSubviews(of: contentView)
    }
    
    deinit {
        removeBackgroundColoredSubviews()
        removeShadowedSubviews()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            apply()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            apply()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard
            let view = object as? UIView,
            let key = keyPath, key == "backgroundColor",
            let color = change?[.newKey] as? UIColor
            else {
                return
        }
        
        var alpha: CGFloat = 1.0
        color.getWhite(nil, alpha: &alpha)
        if alpha > 0.0 {
            backgroundColoredViews[view] = color
        }
    }
    
    private func apply() {
        backgroundColoredViews.forEach { view, color in
            view.backgroundColor = color
        }
        shadowedViews.forEach { view, info in
            view.layer.shadowColor = info.color
            view.layer.shadowOffset = info.offset
            view.layer.shadowOpacity = info.opacity
            view.layer.shadowRadius = info.radius
        }
    }
    
    private func addBackgroundColoredSubviews(of view: UIView) {
        view.subviews.forEach { subview in
            if let color = subview.backgroundColor {
                backgroundColoredViews[subview] = color
                addBackgroundColoredSubviews(of: subview)
                subview.addObserver(
                    self,
                    forKeyPath: #keyPath(UIView.backgroundColor),
                    options: [.new],
                    context: nil
                )
            }
        }
    }
    
    private func addShadowedSubviews(of view: UIView) {
        view.subviews.forEach { subview in
            if let color = subview.layer.shadowColor {
                shadowedViews[subview] = ShadowInfo(
                    color: color,
                    offset: subview.layer.shadowOffset,
                    opacity: subview.layer.shadowOpacity,
                    radius: subview.layer.shadowRadius
                )
                addShadowedSubviews(of: subview)
                subview.layer.addObserver(
                    self,
                    forKeyPath: #keyPath(CALayer.shadowColor),
                    options: [.new],
                    context: nil
                )
            }
        }
    }
    
    private func removeBackgroundColoredSubviews() {
        backgroundColoredViews.forEach { view, _ in
            view.removeObserver(self, forKeyPath: #keyPath(UIView.backgroundColor))
        }
        backgroundColoredViews.removeAll()
    }
    
    private func removeShadowedSubviews() {
        shadowedViews.forEach { view, _ in
            view.layer.removeObserver(self, forKeyPath: #keyPath(CALayer.shadowColor))
        }
        shadowedViews.removeAll()
    }
}
