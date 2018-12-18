//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class DialogZoomBehavior: DialogBehavior {
    
    private let scale: CGFloat
    
    init(scale: CGFloat = 0.25) {
        self.scale = scale
        super.init()
    }
    
    class Presentation: DialogAnimatedTransitioning {
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to),
                let zoomBehavior = behavior as? DialogZoomBehavior
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.alpha = 0
            toView.transform = CGAffineTransform(scaleX: zoomBehavior.scale, y: zoomBehavior.scale)
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    class Dismissal: DialogAnimatedTransitioning {
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from),
                let zoomBehavior = behavior as? DialogZoomBehavior
                else {
                    return
            }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(scaleX: zoomBehavior.scale, y: zoomBehavior.scale)
                fromView.alpha = 0
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    override var presentation: DialogAnimatedTransitioning? {
        return Presentation(behavior: self)
    }
    
    override var dismissal: DialogAnimatedTransitioning? {
        return Dismissal(behavior: self)
    }
}
