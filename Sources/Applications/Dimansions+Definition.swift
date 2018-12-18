//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

extension CGSize {
    
    static var largeDialogSize: CGSize {
        let width = CGFloat.screenWidth * 0.9
        return CGSize(width, width * (4 / 3))
    }
}
