/**
 * Novel Writter App
 * (c) NeroBlu All Rights Reserved.
 */
import UIKit

// MARK: - ConfigureThemeSelectType -

/// テーマ選択設定画面の種別
enum ConfigureThemeSelectType {
    
	case colorTheme
	case fontType
	case textSize
	
    /// ナビゲーションのタイトル文言
    var title: String {
        switch self {
		case .colorTheme: return "テーマ"
		case .fontType:   return "フォント"
		case .textSize:   return "文字サイズ"
        }
    }
}

// MARK: - ConfigureThemeSelectViewController -

/// テーマ選択設定画面ビューコントローラ
class ConfigureThemeSelectViewController: ConfigureChildViewController, VerticalViewControllerDelegate {
    
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var previewArea: UIView!
	@IBOutlet private weak var previewVerticalArea: UIView!
	
    /// 選択完了時のコールバッククロージャ
    typealias SelectedClosure = (ConfigureThemeSelectViewController, Int) -> ()
    
    /// 選択完了時のコールバック
    fileprivate var selected: SelectedClosure?
	
	/// 設定テキストフィールド入力画面の種別
	fileprivate var type = ConfigureThemeSelectType.colorTheme
	
	/// プレビュー用の縦書き表示ビュー
	fileprivate var verticalView : VerticalView!
	
	/// テーブルビューアダプタ
	fileprivate var adapter : ConfigureThemeSelectTableViewController!
	
    // MARK: - インスタンス生成
    
    /// インスタンスを生成する
    /// - parameter type: 設定テキストフィールド入力画面の種別
	/// - parameter selected: 選択完了時のコールバック
    /// - returns: 新しいインスタンス
	class func create(type: ConfigureThemeSelectType, selected: SelectedClosure? = nil) -> ConfigureThemeSelectViewController {
        let ret = App.Storyboard("Configure").id("themeSelect").get(ConfigureThemeSelectViewController.self)
        ret.type = type
        ret.selected = selected
        return ret
    }
	
	// MARK: - ライフサイクル
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = self.type.title
		self.setupTableView()
		self.update()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.update()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if self.verticalView == nil {
			let options = self.owner.configuredBook.verticalViewOptions
			let verticalView = VerticalView(frame: self.previewVerticalArea.frame)
			verticalView.text            = File.mainBundle.append(pathComponent: "preview.txt").contents ?? ""
			verticalView.options         = options
			verticalView.backgroundColor = options.backgroundColor
			verticalView.parent          = self.previewArea
			self.verticalView = verticalView
			
			self.previewVerticalArea.parent = nil
		}
	}
	
	// MARK: - セットアップ
	
	/// テーブルビューのセットアップ
	private func setupTableView() {
		self.adapter = ConfigureThemeSelectTableViewController()
		self.adapter.owner = self
		self.adapter.setup(self.tableView)
	}
	
	// MARK: - 更新
	
	/// 設定値を確定
	fileprivate func commit(index: Int) {
		self.selected?(self, index)
	}
	
	/// 描画を更新する
	fileprivate func update() {
		let options = self.configuredOptions
		self.previewArea.backgroundColor = options.backgroundColor
		
		if let v = self.previewVerticalArea {
			v.backgroundColor = options.backgroundColor
		}
		if let v = self.verticalView {
			v.options = options
			v.backgroundColor = options.backgroundColor
			v.setNeedsDisplay()
		}
	}
}

// MARK: - ConfigureThemeSelectTableViewController -

/// テーマ選択設定画面テーブルコントローラ
class ConfigureThemeSelectTableViewController: NBTableViewController {
	
	weak var owner: ConfigureThemeSelectViewController!
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch self.owner.type {
		case .colorTheme: return ColorTheme.items.count
		case .fontType:   return FontType.items.count
		case .textSize:   return TextSize.items.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		switch self.owner.type {
		case .colorTheme: cell.textLabel?.text = ColorTheme.items[indexPath.row].name
		case .fontType:   cell.textLabel?.text = FontType.items[indexPath.row].name
		case .textSize:   cell.textLabel?.text = TextSize.items[indexPath.row].name
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
		
		switch self.owner.type {
		case .colorTheme: self.owner.configuredBook.colorTheme = ColorTheme.items[indexPath.row]
		case .fontType:   self.owner.configuredBook.fontType   = FontType.items[indexPath.row]
		case .textSize:   self.owner.configuredBook.textSize   = TextSize.items[indexPath.row]
		}
		
		self.owner.commit(index: indexPath.row)
		self.owner.update()
	}
}
