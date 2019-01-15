/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - BookViewController -

/// 書籍閲覧画面ビューコントローラ
class BookViewController: UIViewController, VerticalViewControllerDelegate {
    
    @IBOutlet private weak var chapterLabel: UILabel!
    @IBOutlet private weak var pageNumberLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var editButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var menuButton: UIButton!
    @IBOutlet private weak var pagingSlider: UISlider!
    @IBOutlet private weak var verticalArea: UIView!
    
    /// 書籍
    fileprivate(set) var book: Book!
    
    /// 編集可能かどうか
    fileprivate(set) var isEditable = false
    
    /// 縦書きビューコントローラ
    fileprivate var vertical : VerticalViewController!
    
    /// 書籍閲覧メニュー
    fileprivate var menu : BookMenuViewController!
    
    /// 読み込まれた節(文章)のID
    private var loadedSentenceID = ""
    
    // MARK: - インスタンス生成
    
    /// インスタンスを生成する
    /// - parameter book: 書籍
    /// - parameter editable: 編集可能かどうか
    /// - returns: 新しいインスタンス
    class func create(book: Book, editable: Bool) -> BookViewController {
        let ret = App.Storyboard("Book").get(BookViewController.self)
        ret.book = book
        ret.isEditable = editable
        return ret
    }
    
    // MARK: - ライフサイクル
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.isLoading = true
        self.updatePageNumber(index: nil)
        self.updateChapter(nil)
        self.updateColors()
        self.updateEditButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 縦書きビューコントローラのセットアップ
        if self.vertical == nil {
            let vw = VerticalViewController()
            self.vertical = vw
            vw.text = self.loadText()
            vw.options = self.book.verticalViewOptions
            vw.delegate = self
            vw.view.frame = self.verticalArea.frame
            self.verticalArea.parent = nil
            vw.view.parent = self.view // 文章が読み込まれたら、verticalDidReload(_:)が呼ばれる
        }
    }
    
    func loadText() -> String {
        if self.isEditable {
            return self.book.loadCurrentSentenceText()
        } else {
            return self.book.bookmarkedChapter.loadText()
        }
    }
    
    // MARK: - VerticalViewControllerDelegate実装
    
    /// 縦書きビューコントローラの読み込みが完了した時
    func verticalDidReload(_ vertical: VerticalViewController) {
        self.resetPagingSlider()
        self.updatePageNumber(index: vertical.currentPageIndex)
        self.updateChapter(self.book.currentChapterName)
        self.isLoading = false
    }
    
    /// 縦書きビューコントローラのページが変更された時
    func vertical(_ vertical: VerticalViewController, didMoveFrom pageIndex: Int) {
        self.updatePagingSlider()
        self.updatePageNumber(index: pageIndex)
    }
    
    // MARK: - 縦書きビュー関連
    
    /// 縦書きビューコントローラ再読込
    fileprivate func reloadVertical() {
        self.vertical.text = self.book.loadCurrentSentenceText()
        self.vertical.options = self.book.verticalViewOptions
        if self.book.currentSentenceID != self.loadedSentenceID {
            self.loadedSentenceID = self.book.currentSentenceID
            self.vertical.currentPageIndex = 0
        }
        self.vertical.reload()
        self.updateColors()
    }
    
    // MARK: - ユーザインターフェイス管理
    
    /// ローディング中かどうか
    fileprivate var isLoading = true {
        didSet { let v = self.isLoading
            self.isLoadingVisible = v
            self.isControllable = !v
        }
    }
    
    /// ローディングの表示/非表示
    fileprivate var isLoadingVisible: Bool {
        get {
            return HUD.isVisible
        }
        set {
            if newValue {
                HUD.show(style: .analyzing)
            } else {
                HUD.hide()
            }
        }
    }
    
    /// コントロール部の使用可否
    fileprivate var isControllable = true {
        didSet { let v = self.isControllable
            for component in [self.editButton, self.menuButton, self.pagingSlider] as [UIControl] {
                component.isEnabled = v
            }
            if self.vertical != nil {
                self.vertical.scrollView.isScrollEnabled = v
            }
        }
    }
    
    // MARK: - ボタンイベント
    
    /// 編集ボタン押下時
    @IBAction private func didTapEditButton() {
		let initialText = self.vertical.currentRawText
		self.present(EditViewController.create(initialText: initialText) { [unowned self] (vc, editedText) in
			self.isLoading = true
			
			let replacedText = self.vertical.replace(text: editedText)
			self.book.currentSentence?.save(text: replacedText)
			self.vertical.text = self.book.loadCurrentSentenceText()
			
			vc.dismiss() {
				asyncSleep(0.1) {
                    // リロードが終わると、verticalDidReload(_:)が呼ばれるため
                    // ここでは、self.isLoading = false を読んでいない
					self.reloadVertical()
				}
			}
		})
    }
	
    /// メニューボタン押下時
    @IBAction private func didTapMenuButton() {
        self.menu = BookMenuViewController.create(delegate: self, dataSource: self)
        self.menu.showMenu(self) { [unowned self] in
            self.menu = nil
        }
    }
    
    // MARK: - ページスライダー
    
    /// ページスライダーの値をリセットする
    fileprivate func resetPagingSlider() {
        self.pagingSlider.minimumValue = 0
        self.pagingSlider.maximumValue = self.vertical.lastPageIndex.float
        self.updatePagingSlider()
    }
    
    /// ページスライダーの値を更新する
    fileprivate func updatePagingSlider() {
        self.pagingSlider.value = self.vertical.currentViewIndex.float
    }
    
    /// ページスライダーの値がユーザによって変更された時
    @IBAction private func didChangePagingSlider() {
        let index = (self.pagingSlider.maximumValue - self.pagingSlider.value).int
        self.vertical.move(to: index, animated: false)
    }
    
    // MARK: - ページ番号と章の名前
    
    /// ページ番号の設定
    fileprivate func updatePageNumber(index indexOrNil: Int?) {
        var text = ""
        if let index = indexOrNil {
            text = (index + 1).string
        }
        self.pageNumberLabel.text = text
    }
    
    /// 章の名前の設定
    fileprivate func updateChapter(_ chapterOrNil: String?) {
        var text = ""
        if let chapter = chapterOrNil {
            text = chapter
        }
        self.chapterLabel.text = text
    }
    
    // MARK: - テーマカラーの更新
    
    /// テーマカラーを更新する
    fileprivate func updateColors() {
        self.applyBackgroundColorTheme()
        self.applyTextColorThemeAndFontType()
        self.applySliderColorTheme()
    }
    
    /// 背景色にテーマカラーを適用する
    fileprivate func applyBackgroundColorTheme() {
        let backgroundColorViews: [UIView?] = [
            self.view,
            self.verticalArea,
            ]
        let backgroundColor = self.book.colorTheme.backgroundColor
        for view in backgroundColorViews {
            if let v = view {
                v.backgroundColor = backgroundColor
            }
        }
    }
    
    /// 縦書きビュー以外のラベル要素に文字色とフォントのテーマカラーを適用する
    fileprivate func applyTextColorThemeAndFontType() {
        let textColorViews: [UIView?] = [
            self.pageNumberLabel,
            self.chapterLabel,
            ]
        let textColor = self.book.colorTheme.textColor
        let fontType = self.book.fontType
        for view in textColorViews {
            if let label = view as? UILabel {
                label.textColor = textColor
                label.font = fontType.font(point: label.font.pointSize)
            }
        }
    }
    
    /// スライダーにテーマカラーに適用する
    fileprivate func applySliderColorTheme() {
        let color = self.book.colorTheme.sliderTrackColor
        self.pagingSlider.maximumTrackTintColor = color
        self.pagingSlider.minimumTrackTintColor = color
        
        self.pagingSlider.setThumbImage(self.pagingSliderThumbImage(large: false), for: .normal)
        self.pagingSlider.setThumbImage(self.pagingSliderThumbImage(large: true),  for: .highlighted)
    }
    
    /// スライダーのサムの画像を生成する
    /// - parameter large: 大きい画像(14pt)にするか小さい画像(10pt)にするか
    /// - returns: スライダーのサムの画像
    fileprivate func pagingSliderThumbImage(large: Bool) -> UIImage {
        let size = large ? 14 : 10
        let rect = CGRect(0, 0, size.f, size.f)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let c = UIGraphicsGetCurrentContext()!
        c.setFillColor(self.book.colorTheme.sliderThumbColor.cgColor)
        c.fillEllipse(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - ステータスバー
    
    /// ステータスバーのスタイル
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.book.colorTheme.ui.statusBarStyle
    }
    
    // MARK: - 編集ボタン
    
    /// 編集ボタンのセットアップ
    private func updateEditButton() {
        if !self.isEditable {
            self.editButton.isHidden = true
            self.editButtonWidth.constant = 12.f
        }
    }
    
    // MARK: - その他汎用処理
    
    /// 縦書きビューコントローラの全文
    fileprivate var textInVertical: String {
        return self.vertical.texts.reduce("") { return $0 + $1 }
    }
}

// MARK: - BookMenuViewControllerDelegte実装 -
extension BookViewController: BookMenuViewControllerDelegte {
    
    /// メニューが隠れる直前
    func bookMenu(_ bookMenu: BookMenuViewController, willHide shouldShowLoading: Bool) {
        if shouldShowLoading {
            self.isLoading = true
        }
    }
    
    /// 「本を閉じる」ボタン押下時
    func bookMenuDidTapCloseBook(_ bookMenu: BookMenuViewController) {
        self.book.currentSentence?.save(text: self.textInVertical)
        self.book.save()
		self.dismiss()
    }

	/// プロットボタン押下時
	func bookMenuDidTapPlot(_ bookMenu: BookMenuViewController) {
		
	}
    
    /// 設定ボタン押下時
    func bookMenuDidTapConfigure(_ bookMenu: BookMenuViewController) {
		self.present(ConfigureViewController.create(scenario: .update(book: self.book)) { [unowned self] (vc, configuredBook) in
			self.isLoading = true
			self.book = configuredBook
			self.book.save()
			vc.dismiss() {
				self.reloadVertical()
			}
		})
    }
    
    /// 全文コピーボタン押下時
    func bookMenuDidTapCopy(_ bookMenu: BookMenuViewController) {
		UIPasteboard.general.setValue(self.textInVertical, forPasteboardType: "public.text")
        HUD.show(style: .copied)
        self.isLoading = false
    }
    
    /// 「このページにしおり」ボタン押下時
    func bookMenuDidTapBookmark(_ bookMenu: BookMenuViewController) {
        
    }
    
    /// 「目次を開く」ボタン押下時
    func bookMenuDidTapTOC(_ bookMenu: BookMenuViewController) {
        
    }
    
    // MARK: - 章移動
    
    /// 「前の章へ移動」ボタン押下時
    func bookMenuDidTapPrevChapter(_ bookMenu: BookMenuViewController) {
        if self.bookMenuShouldEnablePrevChapter(bookMenu) {
            self.commonTransferChapter() { return $0 - 1 }
        }
    }
    
    /// 「次の章へ移動」ボタン押下時
    func bookMenuDidTapNextChapter(_ bookMenu: BookMenuViewController) {
        if self.bookMenuShouldEnableNextChapter(bookMenu) {
            self.commonTransferChapter() { return $0 + 1 }
        }
    }
    
    private func commonTransferChapter(_ calculateTargetIndex: (Int)->(Int)) {
        guard
            let sentence = self.book.currentSentence,
            let chapter = sentence.parentChapter,
            let index = self.book.chapters.index(of: chapter)
            else {
                return
        }
        let i = calculateTargetIndex(index)
        let targetChapter = self.book.chapters[i]
        self.book.selectCurrentSentence(id: targetChapter.sentences[0].id)
        self.reloadVertical()
    }
    
    // MARK: - 節移動
	
	/// 「前の節へ移動」ボタン押下時
	func bookMenuDidTapPrevSentence(_ bookMenu: BookMenuViewController) {
        if self.bookMenuShouldEnablePrevSentence(bookMenu) {
            self.commonTransferSentence() { return $0 - 1 }
        }
	}

	/// 「次の節へ移動」ボタン押下時
	func bookMenuDidTapNextSentence(_ bookMenu: BookMenuViewController) {
        if self.bookMenuShouldEnableNextSentence(bookMenu) {
            self.commonTransferSentence() { return $0 + 1 }
        }
	}
    
    private func commonTransferSentence(_ calculateTargetIndex: (Int)->(Int)) {
        guard
            let sentence = self.book.currentSentence,
            let chapter = sentence.parentChapter,
            let index = chapter.sentences.index(of: sentence)
            else {
                return
        }
        let i = calculateTargetIndex(index)
        let targetSentence = chapter.sentences[i]
        self.book.selectCurrentSentence(id: targetSentence.id)
        self.reloadVertical()
    }
    
    // MARK: - ページ移動
    
    /// 「最初に移動」ボタン押下時
    func bookMenuDidTapToFirst(_ bookMenu: BookMenuViewController) {
        if self.bookMenuShouldEnableToFirst(bookMenu) {
            self.commonTransferPage(self.vertical.firstPageIndex)
        }
    }
    
    /// 「最後まで移動」ボタン押下時
    func bookMenuDidTapToLast(_ bookMenu: BookMenuViewController) {
        if self.bookMenuShouldEnableToLast(bookMenu) {
            self.commonTransferPage(self.vertical.lastPageIndex)
        }
    }
    
    private func commonTransferPage(_ targetIndex: Int) {
        self.vertical.move(to: targetIndex, animated: true)
    }
}

// MARK: - BookMenuViewControllerDataSource実装 -
extension BookViewController: BookMenuViewControllerDataSource {
    
    /// 編集可能のメニューかどうかを返す
    func bookMenuShouldEdit(_ bookMenu: BookMenuViewController) -> Bool {
        return !self.book.isLocked && self.isEditable
    }
    
    // MARK: - 章移動
    
    /// 「前の章へ移動」が可能かどうかを返す
    func bookMenuShouldEnablePrevChapter(_ bookMenu: BookMenuViewController) -> Bool {
        guard
            let sentence = self.book.currentSentence,
            let chapter = sentence.parentChapter,
            let index = self.book.chapters.index(of: chapter),
            let first = self.book.chapters.indices.first
            else {
                return false
        }
        return index > first
    }
    
    /// 「次の章へ移動」が可能かどうかを返す
    func bookMenuShouldEnableNextChapter(_ bookMenu: BookMenuViewController) -> Bool {
        guard
            let sentence = self.book.currentSentence,
            let chapter = sentence.parentChapter,
            let index = self.book.chapters.index(of: chapter),
            let last = self.book.chapters.indices.last
            else {
                return false
        }
        return index < last
    }
    
    // MARK: - 節移動
    
	/// 「前の節へ移動」が可能かどうかを返す
	func bookMenuShouldEnablePrevSentence(_ bookMenu: BookMenuViewController) -> Bool {
        guard
            let sentence = self.book.currentSentence,
            let chapter = sentence.parentChapter,
            let index = chapter.sentences.index(of: sentence),
            let first = chapter.sentences.indices.first
            else {
                return false
        }
        return index > first
	}

	/// 「次の節へ移動」が可能かどうかを返す
	func bookMenuShouldEnableNextSentence(_ bookMenu: BookMenuViewController) -> Bool {
        guard
            let sentence = self.book.currentSentence,
            let chapter = sentence.parentChapter,
            let index = chapter.sentences.index(of: sentence),
            let last = chapter.sentences.indices.last
            else {
                return false
        }
        return index < last
	}
    
    // MARK: - ページ移動
    
    /// 「最初に移動」が可能かどうかを返す
    func bookMenuShouldEnableToFirst(_ bookMenu: BookMenuViewController) -> Bool {
		let hasMultiPage = self.vertical.texts.count >= 2
		let isFirst = self.vertical.currentPageIndex == self.vertical.firstPageIndex
		return hasMultiPage && !isFirst
    }
    
    /// 「最後まで移動」が可能かどうかを返す
    func bookMenuShouldEnableToLast(_ bookMenu: BookMenuViewController) -> Bool {
		let hasMultiPage = self.vertical.texts.count >= 2
		let isLast = self.vertical.currentPageIndex == self.vertical.lastPageIndex
		return hasMultiPage && !isLast
	}
}
