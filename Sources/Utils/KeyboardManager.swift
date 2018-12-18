//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

protocol KeyboardManagerDelegate: class {
    
    /// キーボード領域が変更される時に呼ばれる
    /// - Memo: 最後に view.layoutIfNeeded() を呼び出すと滑らかにアニメーションされます
    /// - Parameters:
    ///   - keyboardManager: キーボードマネージャ
    ///   - frame: 変更後の矩形座標
    func keyboardManager(_ keyboardManager: KeyboardManager, willChange frame: CGRect)
    
    /// キーボード領域が変更された時に呼ばれる
    /// - Parameters:
    ///   - keyboardManager: キーボードマネージャ
    ///   - frame: 変更後の矩形座標
    func keyboardManager(_ keyboardManager: KeyboardManager, didChange frame: CGRect)
}

class KeyboardManager {
    
    weak var delegate: KeyboardManagerDelegate?
    
    private var height = CGFloat.nan
    private var y = CGFloat.nan
    private(set) var beginFrame = CGRect.zero
    private(set) var endFrame = CGRect.zero
    
    /// 画面下からキーボード上端までの距離
    var distanceFromScreenBottom: CGFloat {
        var distance = UIScreen.main.bounds.height - endFrame.minY
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                distance -= window.safeAreaInsets.bottom
            }
        }
        if distance < 0 {
            distance = 0
        }
        return distance
    }
    
    init(delegate: KeyboardManagerDelegate?) {
        self.delegate = delegate
        observeKeyboardEvents()
    }
    
    private var notificationNames: [Notification.Name] {
        return [
            UIResponder.keyboardWillShowNotification,
            UIResponder.keyboardWillChangeFrameNotification,
            UIResponder.keyboardWillHideNotification,
        ]
    }
    
    private func observeKeyboardEvents() {
        notificationNames.forEach { name in
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(willChangeKeyboardFrame(_:)),
                name: name,
                object: nil
            )
        }
    }
    
    @objc private func willChangeKeyboardFrame(_ notify: Notification) {
        guard
            let userInfo = notify.userInfo,
            let begin = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
            let end = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        beginFrame = begin
        endFrame = end
        
        // 初回のみ
        if height.isNaN && y.isNaN {
            height = beginFrame.height
            y = beginFrame.minY
        }
        
        // 別画面でキーボードを表示すると変数yに大きな整数が入ってしまうため
        if endFrame.minY > UIScreen.main.bounds.height * 2 {
            return
        }
        // 高さもY座標も変化していない場合は処理抜け
        if height == endFrame.height && y == endFrame.minY {
            return
        }
        
        height = endFrame.height
        y = endFrame.minY
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: {
                self.delegate?.keyboardManager(self, willChange: self.endFrame)
            },
            completion: { _ in
                self.delegate?.keyboardManager(self, didChange: self.endFrame)
            }
        )
    }
}
