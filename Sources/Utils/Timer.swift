//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class TimerHelper {
    
    private static var timerObjects = [TimerObject]()
    
    /// タイマーのスタート
    /// - Parameters:
    ///   - time: タイマーの発火時間
    ///   - firedHandler: 発火したときの処理
    class func start(time: TimeInterval, firedHandler: (() -> ())?) {
        let timerObject = TimerObject()
        TimerHelper.timerObjects.append(timerObject)
        
        timerObject.firedHandler = firedHandler
        timerObject.timer = Timer.scheduledTimer(
            timeInterval: time,
            target: timerObject,
            selector: #selector(TimerObject.didFireTimer),
            userInfo: nil,
            repeats: false
        )
    }
    
    private class TimerObject: NSObject {
        
        var firedHandler: (() -> ())?
        
        weak var timer: Timer?
        
        @objc func didFireTimer() {
            firedHandler?()
            self.timer = nil
            
            if let index = TimerHelper.timerObjects.index(of: self) {
                TimerHelper.timerObjects.remove(at: index)
            }
        }
        
        deinit {
            print("DEINIT \(TimerHelper.timerObjects)")
        }
    }
}
