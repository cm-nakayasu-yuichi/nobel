//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ShelfViewController: UIViewController {

    var presenter: ShelfPresenterProtocol!
    
    private var adapter: ShelfAdapter!
    
    let editButtonDefaultWidth = 68.f
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var readButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var bookNameLabel: UILabel!
    @IBOutlet private weak var bookAuthorLabel: UILabel!
    @IBOutlet private weak var editButtonWidth: NSLayoutConstraint!
    
    /// 選択された書籍
    var selectedBook: Book? {
        didSet { let book = self.selectedBook
            self.bookNameLabel.text   = book?.name   ?? ""
            self.bookAuthorLabel.text = book?.author ?? ""
            
            self.removeButton.isHidden = (book == nil)
            self.readButton.isEnabled = (book != nil)
            self.editButton.isEnabled = (book != nil)
            
            self.editButtonVisible = (book != nil && !book!.isLocked)
        }
    }
    
    var editButtonVisible: Bool = false {
        didSet { let v = self.editButtonVisible
            self.editButton.isHidden = !v
            self.editButtonWidth.constant = v ? self.editButtonDefaultWidth : 0.f
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter = ShelfAdapter(collectionView, delegate: self)
        self.selectedBook = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
    }
    
    /// 更新
    func reload() {
        App.shelf.reload()
        self.collectionView.reloadData()
        if let selectedBook = self.selectedBook, let loadedBook = App.shelf.books.entityBy(id: selectedBook.id) {
            self.selectedBook = loadedBook
        }
    }
    
    /// 書籍を読むボタン押下時
    @IBAction func didTapReadButton() {
        guard let bookInShelf = self.selectedBook else { return }
        let book = App.shelf.book(id: bookInShelf.id)!
        self.present(BookViewController.create(book: book, editable: false))
    }
    
    /// 書籍を編集するボタン押下時
    @IBAction func didTapEditButton() {
        guard let bookInShelf = self.selectedBook else { return }
        let book = App.shelf.book(id: bookInShelf.id)!
        self.present(BookViewController.create(book: book, editable: true))
    }
    
    /// 書籍追加ボタン押下時
    @IBAction func didTapAddButton() {
        self.present(ConfigureViewController.create(scenario: .initialize) { [unowned self] (vc, configuredBook) in
            configuredBook.save()
            App.shelf.addBook(configuredBook)
            vc.dismiss() {
                self.collectionView.reloadData()
            }
        })
    }
    
    /// 書籍削除ボタン押下時
    @IBAction func didTapRemoveButton() {
        guard let book = self.selectedBook else { return }
        
        NBAlert.show(OKCancel: self, message: "この書籍を本当に削除してもいいですか？") {
            book.delete()
            App.shelf.deleteBook(book)
            self.selectedBook = nil
            self.collectionView.reloadData()
        }
    }
    
    /// 全体設定ボタン押下時
    @IBAction func didTapConfigureButton() {
//        self.present(ConfigureViewController.create(scenario: .global) { vc, configuredBook in
//            App.globalConfigure.save(book: configuredBook)
//            vc.dismiss()
//        })
    }
}

extension ShelfViewController: ShelfViewProtocol {

}

extension ShelfViewController: ShelfAdapterDelegate {
    
    func numberOfBooks(in adapter: ShelfAdapter) -> Int {
        return App.shelf.books.count
    }
    
    func shelfAdapter(_ adapter: ShelfAdapter, bookAt index: Int) -> Book {
        return App.shelf.books[index]
    }
    
    func shelfAdapter(_ adapter: ShelfAdapter, isSelectedAt index: Int) -> Bool {
        guard let selectedBook = self.selectedBook else { return false }
        return App.shelf.books[index].id == selectedBook.id
    }
    
    func shelfAdapter(_ adapter: ShelfAdapter, didSelectBook book: Book) {
        self.selectedBook = book
        collectionView.reloadData()
    }
}
