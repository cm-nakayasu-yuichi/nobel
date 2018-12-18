//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol AppearanceAppliable {
    
    func applyAppearance()
}

extension UISwitch: AppearanceAppliable {
    
    func applyAppearance() {
        tintColor = UIColor.bg2
        onTintColor = UIColor.enhance1.withAlphaComponent(0.33)
        thumbTintColor = UIColor.enhance1
    }
}

extension UISegmentedControl: AppearanceAppliable {
    
    func applyAppearance() {
        tintColor = UIColor.enhance1
    }
}

extension UIBarButtonItem: AppearanceAppliable {
    
    func applyAppearance() {
        tintColor = UIColor.enhance1
    }
}
