//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class AlertHelper {
    
    func alertOk(from fromViewController: UIViewController, title: String, message: String, didOk: @escaping (() -> ())) {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "OK", style: .default, handler: { _ in
                didOk()
            }),
            ]
        alert(from: fromViewController, title: title, message: message, actions: actions)
    }
    
    func alertOkCancel(from fromViewController: UIViewController, title: String, message: String, didOk: @escaping (() -> ())) {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "キャンセル", style: .cancel, handler: nil),
            UIAlertAction(title: "OK", style: .default, handler: { _ in
                didOk()
            }),
            ]
        alert(from: fromViewController, title: title, message: message, actions: actions)
    }
    
    func alertYesNo(from fromViewController: UIViewController, title: String, message: String, didYes: @escaping (() -> ())) {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "いいえ", style: .cancel, handler: nil),
            UIAlertAction(title: "はい", style: .default, handler: { _ in
                didYes()
            }),
            ]
        alert(from: fromViewController, title: title, message: message, actions: actions)
    }
    
    func alertDeleteCancel(from fromViewController: UIViewController, title: String, message: String, didDecide: @escaping (() -> ())) {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "キャンセル", style: .cancel, handler: nil),
            UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                didDecide()
            }),
            ]
        alert(from: fromViewController, title: title, message: message, actions: actions)
    }
    
    func alertSaveClose(from fromViewController: UIViewController, title: String, message: String, didSave: @escaping (() -> ()), didClose: @escaping (() -> ())) {
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "閉じる", style: .cancel, handler: { _ in
                didClose()
            }),
            UIAlertAction(title: "保存", style: .default, handler: { _ in
                didSave()
            }),
            ]
        alert(from: fromViewController, title: title, message: message, actions: actions)
    }
    
    func alert(from fromViewController: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { action in
            alert.addAction(action)
        }
        fromViewController.present(alert, animated: true, completion: nil)
    }
}
