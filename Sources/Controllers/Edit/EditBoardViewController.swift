/**
* Novel Writter App
* (c) NeroBlu All Rights Reserved.
*/
import UIKit

/// 文章編集入力ボード種別
enum EditBoardType {
	case saying
	case line
}

/// 文章編集入力ボードアイテムプロトコル
protocol EditBoardItem {
	
	/// アイテムの配列
    static var items: [Self] { get }
	
	/// アイテムの表示文字列
    var title: String { get }
	
	/// 自身のインスタンスを生成する
	/// - parameter vc: 文章編集画面ビューコントローラ
	func execute(_ vc: EditViewController)
}

/// 文章編集入力ボードアイテム: 括弧
enum EditBoardSayingItem: EditBoardItem {
	
	case kagi
	case nijuKagi
	case maru
	case sumitsuki
	case dai
	case kou
	case yama
	case chu
	case doubleQuote
	case singleQuate
	
	static var items: [EditBoardSayingItem] {
		return [.kagi, .nijuKagi, .maru, .sumitsuki, .dai, .kou, .yama, .chu, .doubleQuote, .singleQuate]
	}
	
	var title: String {
		switch self {
		case .kagi:        return "カギ括弧 「」 "
		case .nijuKagi:    return "二重カギ括弧 『』"
		case .maru:        return "丸括弧 （）"
		case .sumitsuki:   return "隅付き括弧 【】"
		case .dai:         return "大括弧 ［］"
		case .kou:         return "甲括弧 〔〕"
		case .yama:        return "山括弧 〈〉"
		case .chu:         return "中括弧 ｛｝"
		case .doubleQuote: return "ダブルクォーテーション “”"
		case .singleQuate: return "シングルクォーテーション ’’"
		}
	}
	
	func execute(_ vc: EditViewController) {
		let start: String
		let end: String
		let len: Int
		
		switch self {
		case .kagi:        start = "「"; end = "会話」";        len = 2
		case .nijuKagi:    start = "『"; end = "会話内会話等』"; len = 6
		case .maru:        start = "（"; end = "感情等）";      len = 3
		case .sumitsuki:   start = "【"; end = "隅付き括弧】";   len = 5
		case .dai:         start = "［"; end = "大括弧］";      len = 3
		case .kou:         start = "〔"; end = "甲括弧〕";      len = 3
		case .yama:        start = "〈"; end = "山括弧〉";      len = 3
		case .chu:         start = "｛"; end = "中括弧｝";      len = 3
		case .doubleQuote: start = "“";  end = "引用等”";      len = 3
		case .singleQuate: start = "’";  end = "引用等’";      len = 3
		}
		vc.encloseText(start: start, end: end, forward: 0, selectLength: len)
		vc.setBoard(nil)
	}
}

/// 文章編集入力ボードアイテム: 線
enum EditBoardLineItem: EditBoardItem {
	
	case short
	case midium
	case long
	case veryLong
	
	static var items: [EditBoardLineItem] {
		return [.short, .midium, .long, .veryLong]
	}
	
    var title: String {
		switch self {
		case .short:    return "短めの線"
		case .midium:   return "程よい線"
		case .long:     return "長めの線"
		case .veryLong: return "非常に長い線"
		}
    }
	
	func execute(_ vc: EditViewController) {
		let text: String
		switch self {
		case .short:    text = "---"
		case .midium:   text = "------"
		case .long:     text = "------------"
		case .veryLong: text = "------------------------"
		}
		vc.appendText(text: text)
		vc.setBoard(nil)
	}
}

/// 文章編集入力ボードビューコントローラ
class EditBoardViewController: UIViewController {
	
    @IBOutlet private weak var tableView: UITableView!
	
	fileprivate var owner: EditViewController!
	
	fileprivate var type: EditBoardType!
	
    private var adapter: EditBoardTableController!
	
	// MARK: - インスタンス生成
	
	/// 自身のインスタンスを生成する
	/// - parameter owner: 親となる文章編集画面ビューコントローラ
	/// - parameter type: 文章編集入力ボード種別
	/// - returns: 新しい自身のインスタンス
	class func create(owner: EditViewController, type: EditBoardType) -> EditBoardViewController {
		let ret = App.Storyboard("Edit").id("board").get(EditBoardViewController.self)
		ret.owner = owner
		ret.type = type
		return ret
	}
	
	// MARK: - ライフサイクル
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTableView()
	}
	
	// MARK: - セットアップ
	
	/// コレクションビューのセットアップ
	func setupTableView() {
		self.adapter = EditBoardTableController()
		self.adapter.owner = self
		self.adapter.setup(self.tableView)
	}
}

// MARK: - EditBoardTableController -

/// 文章編集入力ボードのテーブルビューコントローラ
class EditBoardTableController: NBTableViewController {
	
	/// 親となる文章編集入力ボードビューコントローラ
	weak var owner: EditBoardViewController!
	
	override func setup(_ tableView: UITableView) {
		super.setup(tableView)
		NBCellBackgroundView.prepareTableView(tableView)
	}
	
	// MARK: - UITableViewDelegate, UITableViewDataSource実装
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch self.owner.type! {
		case .saying: return EditBoardSayingItem.items.count
		case .line: return EditBoardLineItem.items.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		switch self.owner.type! {
		case .saying: cell.textLabel?.text = EditBoardSayingItem.items[indexPath.row].title
		case .line:   cell.textLabel?.text = EditBoardLineItem.items[indexPath.row].title
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
		switch self.owner.type! {
		case .saying: EditBoardSayingItem.items[indexPath.row].execute(self.owner.owner)
		case .line:   EditBoardLineItem.items[indexPath.row].execute(self.owner.owner)
		}
	}
}
