/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// 書棚画面コレクションビューコントローラ
class ShelfCollectionViewController: NBCollectionViewController {
    
    let NumberOfColumns = 3.f
    let CellSizeRatio = 178.f / 132.f
    
    weak var owner: ShelfViewController!
    
    /// 指定したインデックスパスの書籍を取得する
    /// - parameter indexPath: インデックスパス
    /// - returns: 書籍
    private func book(at indexPath: IndexPath) -> Book {
        return App.shelf.books[indexPath.row]
    }
    
    // MARK: - UICollectionViewDataSource実装 -
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return App.shelf.books.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShelfCollectionViewCell
        let book = self.book(at: indexPath)
        
        cell.owner = self
        cell.book = book
        cell.collectionView = collectionView
        
        var selected = false
        if let selectedBook = self.owner.selectedBook {
            selected = book.id == selectedBook.id
        }
        cell.isSelected = selected
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        self.owner.selectedBook = nil
        collectionView.reloadData()
    }
    
    @objc(collectionView:canMoveItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if App.shelf.books.exchange(from: sourceIndexPath.row, to: destinationIndexPath.row) {
            App.shelf.save()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout実装 -

/// 書棚画面コレクションビューセル
class ShelfCollectionViewCell : MovableCollectionViewCell {
    
    weak var owner: ShelfCollectionViewController!
    
    var book: Book!
    
    @IBOutlet private var borderConstraints: [NSLayoutConstraint]!
    @IBOutlet private weak var borderView: UIView!
    
    /// 選択状態かどうか
    override var isSelected: Bool {
        didSet { let v = self.isSelected
            self.borderConstraints.forEach {
                $0.constant = v ? 2.5.f : 0.6.f
            }
            self.borderView.backgroundColor = v ?
                UIColor(rgb: 0x9AD2FB) :
                UIColor.darkGray
        }
    }
    
    /// ボタン押下時
    @IBAction func didTapButton() {
        self.owner.owner.didTapBookCell(of: self.book)
        self.owner.collectionView?.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout実装 -
extension ShelfCollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.width / self.NumberOfColumns
        return CGSize(w, w * self.CellSizeRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
