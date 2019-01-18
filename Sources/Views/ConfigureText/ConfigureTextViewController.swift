//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ConfigureTextViewController: UIViewController {

    enum Kind {
        case bookName
        case author
        case chapter
        case sentence
        
        /// 見出しの文言
        var titleLabelText: String {
            switch self {
            case .bookName: return "作品名を入力してください"
            case .author:   return "作者名を入力してください"
            case .chapter:  return "章の名前を入力してください"
            case .sentence: return "節(文章)の名前を入力してください"
            }
        }
        
        /// ナビゲーションのタイトル文言
        var navigationTitleLabelText: String {
            switch self {
            case .bookName: return "作品名"
            case .author:   return "作者名"
            case .chapter:  return "章の名前"
            case .sentence: return "節(文章)の名前"
            }
        }
    }
    
    /// 編集完了時のコールバック
    typealias Edited = (String) -> ()
    
    var edited: Edited?
    var kind = Kind.bookName
    var initialText = ""
    
    private var keyboard: KeyboardManager!
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kind.navigationTitleLabelText
        titleLabel.text = kind.titleLabelText
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func setupTextField() {
        keyboard = KeyboardManager(delegate: self)
        
        textField.textValue = initialText
        textField.returnKeyType = .done
        textField.delegate = self
    }
    
    private func commit() {
        edited?(textField.textValue)
        Wireframe.pop(from: self)
    }
}

extension ConfigureTextViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commit()
        return true
    }
}

extension ConfigureTextViewController: KeyboardManagerDelegate {
    
    func keyboardManager(_ keyboardManager: KeyboardManager, willChange frame: CGRect) {
        bottom.constant = frame.height + 5
        view.layoutIfNeeded()
    }
    
    func keyboardManager(_ keyboardManager: KeyboardManager, didChange frame: CGRect) {
        // NOP.
    }
}
