//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol ShelfAdapterDelegate: class {
    
    func numberOfBooks(in adapter: ShelfAdapter) -> Int
    
    func shelfAdapter(_ adapter: ShelfAdapter, bookAt index: Int) -> Book
    
    func shelfAdapter(_ adapter: ShelfAdapter, isSelectedAt index: Int) -> Bool
    
    func shelfAdapter(_ adapter: ShelfAdapter, didSelectBook book: Book)
}

class ShelfAdapter: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let numberOfColumns = 3.f
    
    let cellSizeRatio = 178.f / 132.f
    
    weak var collectionView: UICollectionView!
    weak var delegate: ShelfAdapterDelegate!
    
    convenience init(_ collectionView: UICollectionView, delegate: ShelfAdapterDelegate) {
        self.init()
        self.collectionView = collectionView
        self.delegate = delegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.numberOfBooks(in: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShelfCell
        let book = delegate.shelfAdapter(self, bookAt: indexPath.row)
        
        cell.delegate = self
        cell.book = book
        cell.isSelected = delegate.shelfAdapter(self, isSelectedAt: indexPath.row)
        
        return cell
    }
    
    @objc(collectionView:canMoveItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if App.shelf.books.exchange(from: sourceIndexPath.row, to: destinationIndexPath.row) {
            App.shelf.save()
        }
    }
    
    private func book(at indexPath: IndexPath) -> Book {
        return App.shelf.books[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.width / self.numberOfColumns
        return CGSize(width, width * self.cellSizeRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ShelfAdapter: ShelfCellDelegate {
    
    func shelfCell(_ cell: ShelfCell, didTapBook book: Book) {
        delegate.shelfAdapter(self, didSelectBook: book)
    }
}
