//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit
import UserNotifications

class PushNotification: NSObject {
    
    func register() {
        DispatchQueue.main.async {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
                guard error == nil && granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func createLocalPushNotificationRequest(creationHandler: @escaping (UNNotificationRequest) -> Void) {
        
        let content = UNMutableNotificationContent()
        content.title = "タイトル"
        content.body = "本文"
        content.badge = 1
        content.sound = .default
        content.userInfo = [:]
        
        let request = createTriggeredLocalPushNotificationRequest(content: content)
        creationHandler(request)
    }
    
    func request(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { _ in }
    }
}

extension PushNotification: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("通知をタップした時にここを通る")
        completionHandler()
    }
}

private extension PushNotification {
    
    func createTriggeredLocalPushNotificationRequest(content: UNNotificationContent) -> UNNotificationRequest {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App"
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
}

