//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class SafariActivity: UIActivity {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override public var activityTitle: String? {
        return "Safariで開く" // TODO: ローカライズ
    }
    
    override public var activityImage: UIImage? {
        return UIImage(named: "icon_safari")
    }
    
    override public func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    override public func prepare(withActivityItems activityItems: [Any]) {
    }
    
    override public func perform() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        self.activityDidFinish(true)
    }
}
