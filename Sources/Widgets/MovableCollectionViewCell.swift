//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol MovableCollectionViewCellDelegate: class {
    
}

class MovableCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MovableCollectionViewCellDelegate?
    weak var collectionView: UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(
            UILongPressGestureRecognizer(target: self, action: #selector(didRecognizeLongPress(gesture:)))
        )
    }
    
    @objc func didRecognizeLongPress(gesture: UILongPressGestureRecognizer) {
        guard let collectionView = self.collectionView else { return }
        
        let pos = self.convert(gesture.location(in: self), to: collectionView)
        switch gesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: pos) {
                let _ = collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(pos)
        case .ended, .cancelled, .failed:
            collectionView.endInteractiveMovement()
        default: break
        }
    }
}
