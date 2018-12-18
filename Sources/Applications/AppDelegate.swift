//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private(set) var lifeCycle: ApplicationLifeCycle = .none
    private(set) var pushNotification: PushNotification = PushNotification()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("""
        /**
         * Welcome to Nobel.
         * Copyright (c) Yuichi Nakayasu. All rights reserved.
         */

        Realm: open \(Realm.path)
        """)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        lifeCycle = .willResignActive
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        lifeCycle = .didEnterBackground
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lifeCycle = .willEnterForeground
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        lifeCycle = .didBecomeActive
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        lifeCycle = .willTerminate
    }
}

extension UIApplication {
    
    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var lifeCycle: ApplicationLifeCycle {
        return UIApplication.appDelegate.lifeCycle
    }
}
