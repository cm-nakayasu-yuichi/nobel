/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

/// 書棚画面ビューコントローラ
class ShelfViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var readButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var bookNameLabel: UILabel!
    @IBOutlet private weak var bookAuthorLabel: UILabel!
    
    let editButtonDefaultWidth = 68.f
    @IBOutlet private weak var editButtonWidth: NSLayoutConstraint!
    
    private var adapter: ShelfCollectionViewController!
    
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
    
    /// 自身のインスタンスを生成する
    /// - returns: 新しい自身のインスタンス
    class func create() -> ShelfViewController {
        let ret = App.Storyboard("Shelf").get(ShelfViewController.self)
        return ret
    }
    
    // MARK: - ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupCollectionView()
        self.selectedBook = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
    }
	
	// MARK: - セットアップ
	
	/// コレクションビューのセットアップ
	func setupCollectionView() {
		self.adapter = ShelfCollectionViewController()
		self.adapter.owner = self
		self.adapter.setup(self.collectionView)
	}
    
    /// 更新
    func reload() {
        App.shelf.reload()
        self.collectionView.reloadData()
        if let selectedBook = self.selectedBook, let loadedBook = App.shelf.books.entityBy(id: selectedBook.id) {
            self.selectedBook = loadedBook
        }
    }
    
    // MARK: - イベント
	
    /// 書籍セル押下時
    func didTapBookCell(of book: Book) {
        self.selectedBook = book
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
        self.present(ConfigureViewController.create(scenario: .global) { vc, configuredBook in
            App.globalConfigure.save(book: configuredBook)
            vc.dismiss()
        })
    }
}
