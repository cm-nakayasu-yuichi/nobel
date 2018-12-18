//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension UIViewController {
    
    func setRightBarButtonSystemItem(_ systemItem:  UIBarButtonItem.SystemItem, selector: Selector) {
        let button = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: selector)
        navigationItem.rightBarButtonItem = button
    }
    
    func setLeftBarButtonSystemItem(_ systemItem:  UIBarButtonItem.SystemItem, selector: Selector) {
        let button = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: selector)
        navigationItem.leftBarButtonItem = button
    }
    
    func setNavigationTitle(updateLabelBlock: (UILabel) -> ()) {
        let titleView = UIView()
        let label = UILabel()
        label.parent = titleView
        label.text = title
        label.font = .navigationTitle
        label.textColor = .baseNavigationForeground
        label.textAlignment = .center
        updateLabelBlock(label)
        _ = label.addConstraint(allSideSpaceTo: titleView)
        navigationItem.titleView = titleView
    }
}

extension UIViewController {
    
    func setupCloseButtonOnNavigationBar() {
        setLeftBarButtonSystemItem(.stop, selector: #selector(didTapCloseButtonOnNavigationBar))
    }
    
    @objc func didTapCloseButtonOnNavigationBar() {
        Wireframe.dismiss(from: self)
    }
}
