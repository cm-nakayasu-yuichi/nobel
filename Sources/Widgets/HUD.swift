//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import KRProgressHUD

class HUD {
    
    enum Style {
        case analyzing
        case copied
    }
    
    /// HUDを表示する
    /// - parameter style: スタイル
    class func show(style: HUD.Style = .analyzing) {
        switch style {
        case .analyzing:
            KRProgressHUD.showMessage("文章を解析中...")
        case .copied:
            KRProgressHUD.showSuccess(withMessage: "コピーしました")
        }
    }
    
    /// HUDを隠す
    class func hide() {
        KRProgressHUD.dismiss()
    }
    
    /// HUDを表示しているかどうか
    class var isVisible: Bool {
        return KRProgressHUD.isVisible
    }
}
