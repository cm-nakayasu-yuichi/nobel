//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class DialogNoneBehavior: DialogBehavior {
    
    class Presentation: DialogAnimatedTransitioning {
        
        override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to)
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            toView.alpha = 1
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(true)
        }
    }
    
    class Dismissal: DialogAnimatedTransitioning {
        
        override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0
        }
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from)
                else {
                    return
            }
            
            fromView.alpha = 0
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    override var presentation: DialogAnimatedTransitioning? {
        return Presentation(behavior: self)
    }
    
    override var dismissal: DialogAnimatedTransitioning? {
        return Dismissal(behavior: self)
    }
}
