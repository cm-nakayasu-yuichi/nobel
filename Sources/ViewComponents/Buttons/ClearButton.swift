//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ClearButton: UIButton {
    
    @IBInspectable var highlightedColor: UIColor? = .clearButtonDefaultHighlighted
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedColor
            } else {
                UIView.transition(
                    with: self,
                    duration: 0.25,
                    options: .curveEaseOut,
                    animations: { [weak self] in
                        self?.backgroundColor = .clear
                    },
                    completion: nil
                )
            }
        }
    }
}
