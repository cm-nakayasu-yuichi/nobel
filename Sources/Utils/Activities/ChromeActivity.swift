//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class ChromeActivity: UIActivity {
    
    private var url: URL?
    
    override public var activityTitle: String? {
        return "Chromeで開く" // TODO: ローカライズ
    }
    
    override public var activityImage: UIImage? {
        return UIImage(named: "icon_chrome")
    }
    
    override public func canPerform(withActivityItems activityItems: [Any]) -> Bool {
//        guard let scheme = URL(string: "googlechrome://"), UIApplication.shared.canOpenURL(scheme) else {
//            return false
//        }
        for item in activityItems {
            if let itemUrl = item as? URL, (itemUrl.scheme == "http" || itemUrl.scheme == "https") {
                return true
            }
        }
        return false
    }
    
    override public func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let itemUrl = item as? URL, (itemUrl.scheme == "http" || itemUrl.scheme == "https") {
                url = itemUrl
                return
            }
        }
    }
    
    override public func perform() {
        if let url = self.url {
            let schemedUrlString = "googlechrome://" + url.absoluteString.urlEncode
            
            if let targetUrl = URL(string: schemedUrlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(targetUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(targetUrl)
                }
            }
        }
        self.activityDidFinish(true)
    }
}
