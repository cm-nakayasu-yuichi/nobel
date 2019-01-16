//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol ShelfCellDelegate: class {
    
    func shelfCell(_ cell: ShelfCell, didTapBook book: Book)
}

class ShelfCell: UICollectionViewCell {
    
    weak var delegate: ShelfCellDelegate?
    
    @IBOutlet private var borderConstraints: [NSLayoutConstraint]!
    @IBOutlet private weak var borderView: UIView!
    
    var book: Book! {
        didSet {
            // TODO: 書籍の画像を貼り付ける
        }
    }
    
    override var isSelected: Bool {
        didSet {
            borderConstraints.forEach {
                $0.constant = isSelected ? 2.5 : 0.6
            }
            borderView.backgroundColor = isSelected ? #colorLiteral(red: 0.6039215686, green: 0.8235294118, blue: 0.9843137255, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    @IBAction func didTapButton() {
        delegate?.shelfCell(self, didTapBook: book)
    }
}
