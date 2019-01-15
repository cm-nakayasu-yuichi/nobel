//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

/// 文章編集画面ビューコントローラ
class EditViewController: UIViewController {
	
	/// 編集管理時コールバッククロージャ
	typealias EditedClosure = (EditViewController, String) -> ()
	
	@IBOutlet private weak var textView: UITextView!
	@IBOutlet private weak var textViewBottom: NSLayoutConstraint!
    
    @IBOutlet private var normalFeatureButtons: [UIView]!
    @IBOutlet private var boardFeatureButtons: [UIView]!
    
	
	/// 編集管理時コールバック
	var edited: EditedClosure?
	
	/// 初期値
	private(set) var initialText = ""
	
	/// キーボード管理オブジェクト
	private var kem: NBKeyboardEventManager!
	
	private var board: EditBoardViewController!
	
	// MARK: - インスタンス生成
	
	/// 自身のインスタンスを生成する
	/// - parameter initialText: 初期値
	/// - parameter text: テキスト
	/// - returns: 新しい自身のインスタンス
	class func create(initialText: String, edited: EditedClosure?) -> EditViewController {
		let ret = App.Storyboard("Edit").get(EditViewController.self)
		ret.initialText = initialText
		ret.edited = edited
		return ret
	}
	
	// MARK: - ライフサイクル
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.kem = NBKeyboardEventManager() { [unowned self] (distance) in
			self.textViewBottom.constant = distance
		}
		self.textView.text = self.initialText
		self.textView.selectedRange = NSMakeRange(0, 0)
        
        self.isShowedBoardFeatureButtons = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.textView.becomeFirstResponder()
	}
	
	// MARK: - ボタンイベント
	
	/// 保存ボタン押下時
	@IBAction private func didTapSaveButton() {
		self.edited?(self, self.textView.text)
	}
    
    /// ボードを閉じるボタン押下時
    @IBAction private func didTapCloseBoardButton() {
		self.setBoard(nil)
    }
	
	/// 全角空白挿入ボタン押下時
	@IBAction private func didTapAddWhiteSpaceButton() {
		self.appendText(text: "　")
	}
	
	/// ルビ振りボタン押下時
	@IBAction private func didTapAddRubyButton() {
		self.encloseText(start: "｜", end: "《ふりがな》", forward: 1, selectLength: 4)
	}
	
	/// カギ括弧ボタン押下時
	@IBAction private func didTapSayingButton() {
		self.setBoard(EditBoardViewController.create(owner: self, type: .saying))
	}
	
	/// 中央寄せボタン押下時
	@IBAction private func didTapCenteringButton() {
		self.encloseText(start: "｜＊", end: "＊｜")
	}
	
	/// 線挿入ボタン押下時
	@IBAction private func didTapAddLineButton() {
		self.setBoard(EditBoardViewController.create(owner: self, type: .line))
	}
	
	/// 閉じるボタン押下時
	@IBAction private func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
	}
    
    // MARK: - UI操作
    
    /// ボード機能用のUIを表示するかどうか
    private var isShowedBoardFeatureButtons = false {
        didSet {
            for v in self.normalFeatureButtons {
                v.isHidden = isShowedBoardFeatureButtons
            }
            for v in self.boardFeatureButtons {
                v.isHidden = !isShowedBoardFeatureButtons
            }
        }
    }

	/// ボードの設定
	/// - parameter boardOrNil: 文章編集入力ボードビューコントローラ
	func setBoard(_ boardOrNil: EditBoardViewController?) {
		if let board = boardOrNil {
			self.isShowedBoardFeatureButtons = true
			self.textView.inputView = board.view
		} else {
			self.isShowedBoardFeatureButtons = false
			self.textView.inputView = nil
		}
		self.textView.reloadInputViews()
		self.board = boardOrNil
	}
	
	// MARK: - 文字列操作
	
	/// 現在の位置に指定の文字列を追加する
	/// - parameter text: ルビ文字列
	func appendText(text: String) {
		self.textView.isScrollEnabled = false
		
		var r = self.textView.selectedRange
		var target = self.textView.text ?? ""
		
		let index = target.index(target.startIndex, offsetBy: r.location)
        target.insert(contentsOf: text, at: index)
		self.textView.text = target
		
		r.location += text.count
		self.textView.selectedRange = r
		
		self.textView.isScrollEnabled = true
	}
	
	/// 現在の選択範囲に指定の文字列で囲む
	/// - parameter start: 囲む文字の開始
	/// - parameter end: 囲む文字の終了
	/// - parameter forward: 囲んだ後に選択位置を進ませる量
	/// - parameter selectLength: 囲んだ後に選択する文字量
	func encloseText(start: String, end: String, forward: Int = 0, selectLength: Int = 0) {
		self.textView.isScrollEnabled = false
		
		var r = self.textView.selectedRange
		var target = self.textView.text ?? ""
		
		var len = 0
		if r.length > 0 {
			let t = target.substring(range: r)
			target = target.replace(r, start + t + end)
			len = t.count
		} else {
			let index = target.index(target.startIndex, offsetBy: r.location)
			target.insert(contentsOf: start + end, at: index)
		}
		
		self.textView.text = target
		
		r.location += start.count + len + forward
		r.length = selectLength
		self.textView.selectedRange = r
		
		self.textView.isScrollEnabled = true
	}
}
