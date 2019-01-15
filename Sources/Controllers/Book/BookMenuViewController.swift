/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

enum BookMenuItem: String {
    
    case closeBook
    case configure
	case plot
    case copy
    case bookmark
    case toc
    case prevChapter
    case nextChapter
    case prevSentence
    case nextSentence
    case toFirst
    case toLast
	
	/// メニューアイテムの配列
	fileprivate static func items(editable: Bool) -> [BookMenuItem] {
		if editable {
			return [
				.closeBook,
				.configure,
				.plot,
				.copy,
				.toc,
				.prevChapter, .nextChapter,
				.prevSentence, .nextSentence,
				.toFirst, .toLast,
			]
		} else {
			return [
				.closeBook,
				.bookmark, .toc,
				.prevChapter, .nextChapter,
				.toFirst,
			]
		}
	}
	
	/// アイテムのタイトル
    fileprivate var title: String {
        switch self {
        case .closeBook: return "本を閉じる"
        case .configure: return "設定"
		case .plot: return "プロット"
		case .copy: return "文章をコピーする"
        case .bookmark: return "このページにしおり"
        case .toc: return "目次を開く"
        case .prevChapter: return "前の章へ移動"
        case .nextChapter: return "次の章へ移動"
        case .prevSentence: return "前の節へ移動"
        case .nextSentence: return "次の節へ移動"
        case .toFirst: return "最初に移動"
        case .toLast: return "最後まで移動"
        }
    }
	
	/// 背景色
    fileprivate var backgroundColor: UIColor {
        switch self {
        case .closeBook: return UIColor(rgb: 0xE2D9D9)
        case .prevChapter, .nextChapter: return UIColor(rgb: 0xF8FFFA)
        case .prevSentence, .nextSentence: return UIColor(rgb: 0xFFFEF8)
        case .toFirst, .toLast: return UIColor(rgb: 0xFEF9F8)
        default: return UIColor(rgb: 0xFFFFFE)
        }
    }
	
	/// 押下時のハイライト背景色
    fileprivate var highlightColor: UIColor {
        switch self {
		case .closeBook: return UIColor(rgb: 0xD9AAAC)
        default: return UIColor(rgb: 0x9AD2FB)
        }
    }
	
	/// アイテムの文字色
	fileprivate var textColor: UIColor {
		switch self {
		case .closeBook: return UIColor(rgb: 0xE04C39)
        case .prevChapter, .nextChapter: return UIColor(rgb: 0x405344)
        case .prevSentence, .nextSentence: return UIColor(rgb: 0x535040)
        case .toFirst, .toLast: return UIColor(rgb: 0x524340)
		default: return UIColor(rgb: 0x484745)
		}
	}

	/// アイテム押下時の動作
	/// - parameter bookMenu: 書籍閲覧メニューコントローラ
    fileprivate func action(_ bookMenu: BookMenuViewController) {
        guard let delegate = bookMenu.delegate else { return }
        
        switch self {
        case .closeBook:    delegate.bookMenuDidTapCloseBook(bookMenu)
        case .configure:    delegate.bookMenuDidTapConfigure(bookMenu)
		case .plot:         delegate.bookMenuDidTapPlot(bookMenu)
        case .copy:         delegate.bookMenuDidTapCopy(bookMenu)
        case .bookmark:     delegate.bookMenuDidTapBookmark(bookMenu)
        case .toc:          delegate.bookMenuDidTapTOC(bookMenu)
        case .prevChapter:  delegate.bookMenuDidTapPrevChapter(bookMenu)
        case .nextChapter:  delegate.bookMenuDidTapNextChapter(bookMenu)
        case .prevSentence: delegate.bookMenuDidTapPrevSentence(bookMenu)
        case .nextSentence: delegate.bookMenuDidTapNextSentence(bookMenu)
        case .toFirst:      delegate.bookMenuDidTapToFirst(bookMenu)
        case .toLast:       delegate.bookMenuDidTapToLast(bookMenu)
        }
    }
	
	/// 使用可能なアイテムかどうかを取得する
	/// - parameter bookMenu: 書籍閲覧メニューコントローラ
	/// - returns: 可能/不可能
    fileprivate func isEnabled(_ bookMenu: BookMenuViewController) -> Bool {
        guard let dataSource = bookMenu.dataSource else { return false }
        
        switch self {
        case .prevChapter:  return dataSource.bookMenuShouldEnablePrevChapter(bookMenu)
        case .nextChapter:  return dataSource.bookMenuShouldEnableNextChapter(bookMenu)
        case .prevSentence: return dataSource.bookMenuShouldEnablePrevSentence(bookMenu)
        case .nextSentence: return dataSource.bookMenuShouldEnableNextSentence(bookMenu)
        case .toFirst:      return dataSource.bookMenuShouldEnableToFirst(bookMenu)
        case .toLast:       return dataSource.bookMenuShouldEnableToLast(bookMenu)
        default: return true
        }
    }
    
    /// メニューを閉じる時にローディング(HUD)を表示するかどうか
    fileprivate var shouldShowLoadingWhenMenuHiding: Bool {
        switch self {
        case .copy,
             .bookmark,
             .prevChapter,
             .nextChapter,
             .prevSentence,
             .nextSentence:
            return true
        case .closeBook,
             .plot,
             .configure,
             .toc,
             .toLast,
             .toFirst:
            return false
        }
    }
}

// MARK: - BookMenuViewControllerDelegte -

/// 書籍閲覧メニューコントローラのデリゲートプロトコル
protocol BookMenuViewControllerDelegte: NSObjectProtocol {
    
    /// メニューが閉じられる直前
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - parameter shouldShowLoading: メニューを閉じる時にローディング(HUD)を表示するかどうか
    func bookMenu(_ bookMenu: BookMenuViewController, willHide shouldShowLoading: Bool)
    
    /// 「本を閉じる」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapCloseBook(_ bookMenu: BookMenuViewController)
    
    /// 設定ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapConfigure(_ bookMenu: BookMenuViewController)
	
	/// プロットボタン押下時
	/// - parameter bookMenu: 書籍閲覧メニューコントローラ
	func bookMenuDidTapPlot(_ bookMenu: BookMenuViewController)
	
    /// 全文コピーボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapCopy(_ bookMenu: BookMenuViewController)
    
    /// 「このページにしおり」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapBookmark(_ bookMenu: BookMenuViewController)
    
    /// 「目次を開く」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapTOC(_ bookMenu: BookMenuViewController)
    
    /// 「前の章へ移動」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapPrevChapter(_ bookMenu: BookMenuViewController)
    
    /// 「次の章へ移動」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapNextChapter(_ bookMenu: BookMenuViewController)
    
    /// 「前の節へ移動」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapPrevSentence(_ bookMenu: BookMenuViewController)
    
    /// 「次の節へ移動」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapNextSentence(_ bookMenu: BookMenuViewController)
    
    /// 「最初に移動」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapToFirst(_ bookMenu: BookMenuViewController)
    
    /// 「最後まで移動」ボタン押下時
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    func bookMenuDidTapToLast(_ bookMenu: BookMenuViewController)
}

// MARK: - BookMenuViewControllerDataSource -

/// 書籍閲覧メニューコントローラのデータソースプロトコル
protocol BookMenuViewControllerDataSource: NSObjectProtocol {
    
    /// 編集可能のメニューかどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 編集可能のメニューかどうか
    func bookMenuShouldEdit(_ bookMenu: BookMenuViewController) -> Bool
    
    /// 「前の章へ移動」が可能かどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 可能/不可能
    func bookMenuShouldEnablePrevChapter(_ bookMenu: BookMenuViewController) -> Bool
    
    /// 「次の章へ移動」が可能かどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 可能/不可能
    func bookMenuShouldEnableNextChapter(_ bookMenu: BookMenuViewController) -> Bool
    
    /// 「前の節へ移動」が可能かどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 可能/不可能
    func bookMenuShouldEnablePrevSentence(_ bookMenu: BookMenuViewController) -> Bool
    
    /// 「次の節へ移動」が可能かどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 可能/不可能
    func bookMenuShouldEnableNextSentence(_ bookMenu: BookMenuViewController) -> Bool
    
    /// 「最初に移動」が可能かどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 可能/不可能
    func bookMenuShouldEnableToFirst(_ bookMenu: BookMenuViewController) -> Bool
    
    /// 「最後まで移動」が可能かどうかを返す
    /// - parameter bookMenu: 書籍閲覧メニューコントローラ
    /// - returns: 可能/不可能
    func bookMenuShouldEnableToLast(_ bookMenu: BookMenuViewController) -> Bool
}

/// 書籍閲覧メニュービューコントローラ
class BookMenuViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeArea: UIView!
    
    /// テーブルビューアダプタ
    private var adapter : BookMenuTableViewController!
    
    /// デリゲート
    weak var delegate: BookMenuViewControllerDelegte?
    
    /// データソース
    weak var dataSource: BookMenuViewControllerDataSource?
    
    /// メニューを閉じた時のコールバック
    private var closed: VoidClosure?
    
    /// 閉じるためのタップジェスチャレコグナイザ
    private var tapGesture: UITapGestureRecognizer?
    
	// MARK: - インスタンス生成
	
    /// 自身のインスタンスを生成する
    /// - parameter delegate: デリゲート
    /// - parameter dataSource: データソース
    /// - returns: 新しい自身のインスタンス
    class func create(delegate: BookMenuViewControllerDelegte, dataSource: BookMenuViewControllerDataSource) -> BookMenuViewController {
        let ret = App.Storyboard("Book").id("menu").get(BookMenuViewController.self)
        ret.delegate = delegate
        ret.dataSource = dataSource
        return ret
    }
    
    // MARK: - 表示開始/終了

    /// メニューを開く
    /// - parameter controller: デリゲート
    /// - parameter closed: 完了時のコールバック
    func showMenu(_ controller: UIViewController, closed: VoidClosure?) {
        self.closed = closed
        self.view.frame = controller.view.bounds
        self.view.parent = controller.view
        self.showAnimate()
    }
    
    /// メニューを閉じる
    @objc func hideMenu() {
        self.hideAnimate()
    }
    
    /// 表示開始のアニメーションを行う
    private func showAnimate() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.updateView(true)
        }, completion: { _ in
            self.attachCloseRecognizer()
        })
    }
    
    /// 表示終了のアニメーションを行う
    /// - parameter indexPath: 選択されたインデックスパス(アダプタからの呼び出し用)
    fileprivate func hideAnimate(at indexPathOrNil: IndexPath? = nil) {
        if let indexPath = indexPathOrNil {
            let item = self.adapter.item(at: indexPath)
            self.delegate?.bookMenu(self, willHide: item.shouldShowLoadingWhenMenuHiding)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.dettachCloseRecognizer()
            self.updateView(false)
        }, completion: { _ in
            if let indexPath = indexPathOrNil {
                self.adapter.action(at: indexPath)
            }
            self.closed?()
        })
    }
    
    /// ビューの更新
    /// - parameter show: 表示時/非表示時
    private func updateView(_ show: Bool) {
        self.view.alpha = show ? 1 : 0
        self.tableView.frame = self.tableFrame(show)
        self.closeArea.frame = self.closeAreaFrame(show)
        self.view.layoutIfNeeded()
    }
    
    /// テーブルビューの座標
    /// - parameter show: 表示時/非表示時
     fileprivate func tableFrame(_ show: Bool) -> CGRect {
        let s = 20.f // s = status-bar height
        let w = App.Dimen.Screen.Width * 0.8.f
        let h = App.Dimen.Screen.Height - s
        return show ? CGRect(0, s, w, h) : CGRect(-w, s, w, h)
    }
    
    // MARK: - ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.updateView(false)
    }
    
    // MARK: - セットアップ
        
    /// テーブルビューのセットアップ
    private func setupTableView() {
        self.adapter = BookMenuTableViewController()
        self.adapter.owner = self
        self.adapter.setup(self.tableView)
    }
    
    // MARK: - 閉じる領域イベント
    
    /// 閉じる領域ビューにタップレコグナイザを付与する
    private func attachCloseRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        self.closeArea.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    
    /// 閉じる領域ビューからタップレコグナイザを取り外す
    private func dettachCloseRecognizer() {
        if let tapGesture = self.tapGesture {
            self.closeArea.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }
    
    /// 閉じる領域ビューの座標
    /// - parameter show: 表示時/非表示時
    fileprivate func closeAreaFrame(_ show: Bool) -> CGRect {
        var frame = self.tableFrame(show)
        frame.origin.x = frame.maxX
        frame.size.width = App.Dimen.Screen.Width - frame.minX
        return frame
    }
}

// MARK: - BookMenuTableViewController -

/// 書籍閲覧メニューテーブルコントローラ
class BookMenuTableViewController: NBTableViewController {
    
    private var cellHeight = 0.f

	/// 親となる書籍閲覧メニュービューコントローラ
    weak var owner: BookMenuViewController!
	
	/// メニューアイテムの配列
	private var items: [BookMenuItem] {
		let editable = self.owner.dataSource?.bookMenuShouldEdit(self.owner) ?? false
		return BookMenuItem.items(editable: editable)
	}
	
	/// 指定のインデックスパスのメニューアイテムを取得する
	/// - parameter indexPath: インデックスパス
	/// - returns: メニューアイテム
	func item(at indexPath: IndexPath) -> BookMenuItem {
		return self.items[indexPath.row]
	}

    /// 指定のインデックスパスのメニューアイテムのアクションを実行する
    /// - parameter indexPath: インデックスパス
    func action(at indexPath: IndexPath) {
        self.item(at: indexPath).action(self.owner)
    }
	
    override func setup(_ tableView: UITableView) {
        super.setup(tableView)
        for item in self.items {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: item.rawValue)
        }
        NBCellBackgroundView.prepareTableView(tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if self.item(at: indexPath).isEnabled(self.owner) {
            self.owner.hideAnimate(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellHeight == 0.f {
            let baseHeight = self.owner.tableFrame(true).height
            self.cellHeight = baseHeight / self.items.count.f
        }
        return self.cellHeight
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = self.item(at: indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: item.rawValue, for: indexPath)
		
		// 背景ビューの設定
		if !(cell.selectedBackgroundView is NBCellBackgroundView) {
			cell.backgroundColor = UIColor.clear
			
			var options = NBCellBackgroundViewOptions()
			options.backgroundColor = item.backgroundColor
			options.highlightedBackgroundColor = item.highlightColor
			options.separatorColor = UIColor.darkGray
			cell.setCellBackgrounView(options: options)
		}
		
		let enabled = item.isEnabled(self.owner)
		
		cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
		cell.textLabel?.text = item.title
		
		let alpha = enabled ? 1.0.f : 0.3.f
		cell.textLabel?.textColor = item.textColor.withAlphaComponent(alpha)
		cell.selectionStyle = enabled ? .blue : .none
		
		return cell
	}
}

// MARK: - BookMenuViewControllerDelegte初期値 -
extension BookMenuViewControllerDelegte {
    func bookMenu(_ bookMenu: BookMenuViewController, willHide shouldShowLoading: Bool) {}
    func bookMenuDidTapCloseBook(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapConfigure(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapPlot(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapCopy(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapBookmark(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapTOC(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapPrevChapter(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapNextChapter(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapPrevSentence(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapNextSentence(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapToFirst(_ bookMenu: BookMenuViewController) {}
    func bookMenuDidTapToLast(_ bookMenu: BookMenuViewController) {}
}

// MARK: - BookMenuViewControllerDataSource初期値 -
extension BookMenuViewControllerDataSource {
    func bookMenuShouldEdit(_ bookMenu: BookMenuViewController) -> Bool { return false }
    func bookMenuShouldEnablePrevChapter(_ bookMenu: BookMenuViewController) -> Bool { return false }
    func bookMenuShouldEnableNextChapter(_ bookMenu: BookMenuViewController) -> Bool { return false }
    func bookMenuShouldEnablePrevSentence(_ bookMenu: BookMenuViewController) -> Bool { return false }
    func bookMenuShouldEnableNextSentence(_ bookMenu: BookMenuViewController) -> Bool { return false }
    func bookMenuShouldEnableToFirst(_ bookMenu: BookMenuViewController) -> Bool { return false }
    func bookMenuShouldEnableToLast(_ bookMenu: BookMenuViewController) -> Bool { return false }
}

