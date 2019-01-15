/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - ConfigureTextFieldType -

/// 設定テキストフィールド入力画面の種別
enum ConfigureTextFieldType {
    
    case bookName
    case author
    case chapter
    case sentence
    case plot
	
	/// 見出しの文言
    var titleLabelText: String {
        switch self {
        case .bookName: return "書籍のタイトルを入力してください"
        case .author:   return "書籍の作者名を入力してください"
        case .chapter:  return "章の名前を入力してください"
        case .sentence: return "節(文章)の名前を入力してください"
        case .plot:     return "プロットのタイトルを入力してください"
        }
    }
	
    /// ナビゲーションのタイトル文言
    var navigationTitleLabelText: String {
        switch self {
		case .bookName: return "書籍名"
		case .author:   return "作者名"
		case .chapter:  return "章の名前"
		case .sentence: return "節(文章)の名前"
		case .plot:     return "プロット"
        }
    }
}

// MARK: - ConfigureTextFieldViewController -

/// 設定テキストフィールド入力画面ビューコントローラ
class ConfigureTextFieldViewController: ConfigureChildViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var bottom: NSLayoutConstraint!
    
    /// 編集完了時のコールバッククロージャ
    typealias EditedClosure = (ConfigureTextFieldViewController, String) -> ()
    
    /// 編集完了時のコールバック
    private var edited: EditedClosure?
	
	/// 設定テキストフィールド入力画面の種別
	private var type: ConfigureTextFieldType!
	
	/// 初期文字列
	private var initialText = ""
	
	/// 
	private var keyboard: NBKeyboardEventManager!
	
    // MARK: - インスタンス生成
    
    /// インスタンスを生成する
    /// - parameter type: 画面の種別
	/// - parameter initialText: 初期文字列
	/// - parameter edited: 編集完了時のコールバック
    /// - returns: 新しいインスタンス
	class func create(type: ConfigureTextFieldType, initialText: String = "", edited: EditedClosure? = nil) -> ConfigureTextFieldViewController {
        let ret = App.Storyboard("Configure").id("textField").get(ConfigureTextFieldViewController.self)
        ret.type = type
        ret.edited = edited
		ret.initialText = initialText
        return ret
    }
	
	// MARK: - ライフサイクル
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupLabels()
		self.setupTextField()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.textField.becomeFirstResponder()
	}
	
	// MARK: - セットアップ
	
	/// 各ラベルのセットアップ
	private func setupLabels() {
		self.title           = self.type.navigationTitleLabelText
		self.titleLabel.text = self.type.titleLabelText
	}
	
	/// テキストフィールドのセットアップ
	private func setupTextField() {
		self.keyboard = NBKeyboardEventManager() { [unowned self] (height) in
			self.bottom.constant = height + 5.f
		}
		
		self.textField.text = self.initialText
		self.textField.returnKeyType = .done
		self.textField.delegate = self
	}
	
	// MARK: - 確定
	
	/// 設定値を確定
	private func commit() {
		let text = self.textField.text ?? ""
		self.edited?(self, text)
		self.popConfigure()
	}
	
	// MARK: - UITextFieldDelegate実装
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.commit()
		return true
	}
}
