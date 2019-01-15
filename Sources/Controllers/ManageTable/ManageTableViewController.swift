//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

// MARK: - ManageTableViewControllerDelegte -

protocol ManageTableViewControllerDelegte: class {
    
	func manageTable(textAt index: Int) -> String
    
    func manageTable(_ manageTable: ManageTableViewController, didDrilldownRowAt index: Int)
	func manageTable(_ manageTable: ManageTableViewController, didSelectRowAt index: Int)
    func manageTable(_ manageTable: ManageTableViewController, didTapRenameRowAt index: Int)
	func manageTable(_ manageTable: ManageTableViewController, didTapDeleteRowAt index: Int, deleted: @escaping ()->())
	func manageTable(_ manageTable: ManageTableViewController, didExchangeFrom from: Int, to: Int)
	func manageTableDidTapAddRow(_ manageTable: ManageTableViewController)
}

extension ManageTableViewControllerDelegte {
    
    func manageTable(_ manageTable: ManageTableViewController, didDrilldownRowAt index: Int) {}
    func manageTable(_ manageTable: ManageTableViewController, didSelectRowAt index: Int) {}
    func manageTable(_ manageTable: ManageTableViewController, didTapRenameRowAt index: Int) {}
    func manageTable(_ manageTable: ManageTableViewController, didTapDeleteRowAt index: Int, deleted: @escaping ()->()) {}
    func manageTable(_ manageTable: ManageTableViewController, didExchangeFrom from: Int, to: Int) {}
    func manageTableDidTapAddRow(_ manageTable: ManageTableViewController) {}
}

// MARK: - ManageTableViewController -

/// データ管理用テーブルコントローラのモード
enum ManageTableViewControllerMode {
	
	case select
	case drilldown
	case rename
	case sort
	
	var accessoryType: UITableViewCell.AccessoryType {
		switch self {
		case .drilldown: return .disclosureIndicator
		case .select, .rename, .sort: return .none
		}
	}
	
	var buttonTitle: String {
		switch self {
		case .select:    return "選択"
		case .drilldown: return "選択"
		case .rename:    return "名前変更＋追加"
		case .sort:      return "並び替え＋削除"
		}
	}
}

// MARK: - ManageTableViewController -

/// データ管理用テーブルコントローラ
class ManageTableViewController: NBTableViewController {
	
	let Normal = "cell"
	let Add    = "add"
    
    /// データの配列
	var items: [Any] = []
    
    /// デリゲート
    weak var delegate: ManageTableViewControllerDelegte?
	
    /// 親となるビューコントローラ(ナビゲーションの配下にある想定)
    weak var owner: UIViewController?
    
    /// セットアッブ
	override func setup(_ tableView: UITableView) {
        super.setup(tableView)
		self.updateRightButton()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.Normal)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.Add)
	}
    
    // MARK: - モード
    
    /// 使用するモードの配列
    var modes: [ManageTableViewControllerMode] = [.drilldown, .rename, .sort]
    
    /// 現在のモード
    var mode: ManageTableViewControllerMode {
        if !self.modes.inRange(at: self.modeIndex) { return .select }
        return self.modes[self.modeIndex]
    }
    
    /// 現在のモードのインデックス
    var modeIndex = 0 {
        didSet {
            self.updateRightButton()
            self.tableView?.isEditing = (self.mode == .sort)
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource実装
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ret = self.items.count
        if self.hasAddRow {
            ret += 1
        }
        return ret
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(at: indexPath), for: indexPath)
		if self.isAddRow(at: indexPath) {
			self.setupAddCell(cell)
		} else {
			cell.textLabel?.text = self.delegate?.manageTable(textAt: indexPath.row)
            cell.accessoryType = self.mode.accessoryType
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
        if self.isAddRow(at: indexPath) {
            delegate?.manageTableDidTapAddRow(self)
        } else {
            switch self.mode {
            case .drilldown:
                delegate?.manageTable(self, didDrilldownRowAt: indexPath.row)
            case .select:
                delegate?.manageTable(self, didSelectRowAt: indexPath.row)
            case .rename:
                delegate?.manageTable(self, didTapRenameRowAt: indexPath.row)
            default: break
            }
        }
	}
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.mode == .sort
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete || self.mode != .sort { return }
        delegate?.manageTable(self, didTapDeleteRowAt: indexPath.row, deleted: {
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.mode == .sort
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.manageTable(self, didExchangeFrom: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // MARK: - ナビゲーション右ボタン
    
    /// 右ボタンの表示更新をする
    private func updateRightButton() {
        guard let vc = self.owner, self.modes.count >= 2 else { return }
        
        let next = self.modes.nextLoopIndex(of: self.modeIndex)
        let nextMode = self.modes[next]
        
        let button = UIBarButtonItem(title: nextMode.buttonTitle, style: .plain, target: self, action: #selector(didTapRightButton))
        vc.navigationItem.rightBarButtonItem = button
    }
    
    /// 右ボタン押下時
    @objc func didTapRightButton() {
        self.modeIndex = self.modes.nextLoopIndex(of: self.modeIndex)
        self.updateRightButton()
    }
	
	// MARK: - 追加ボタン
	
	/// 追加ボタン行を持つかどうか
	private var hasAddRow: Bool {
		return self.mode == .rename
	}

	/// 指定したインデックスパスが追加ボタン行かどうか
	/// - parameter indexPath: インデックスパス
	/// - returns: 追加ボタン行かどうか
	private func isAddRow(at indexPath: IndexPath) -> Bool {
		if !self.hasAddRow {
			return false
		}
		return indexPath.row == self.items.count
	}
	
	/// 指定したインデックスパスのセル識別子を取得する
	/// - parameter indexPath: インデックスパス
	/// - returns: セル識別子
	private func cellIdentifier(at indexPath: IndexPath) -> String {
		return self.isAddRow(at: indexPath) ? self.Add : self.Normal
	}
	
	/// 追加ボタン行のセルのセットアップをする
	/// - parameter cell: セル
	private func setupAddCell(_ cell: UITableViewCell) {
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "＋ 新しく追加する"
        cell.textLabel?.textColor = UIColor(rgb: 0x007AFF)
	}
}

