//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class DialogTopDrawBehavior: DialogBehavior {
    
    private let height: CGFloat
    
    init(height: CGFloat = 250) {
        self.height = height
        super.init()
    }
    
    override func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: containerSize.width,
            height: height
        )
    }
    
    class Presentation: DialogAnimatedTransitioning {
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to),
                let bottomDrawBehavior = behavior as? DialogTopDrawBehavior
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: 0, y: -bottomDrawBehavior.height)
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = CGAffineTransform.identity
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
    
    class Dismissal: DialogAnimatedTransitioning {
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let fromView = transitionContext.view(forKey: .from),
                let bottomDrawBehavior = behavior as? DialogTopDrawBehavior
                else {
                    return
            }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(translationX: 0, y: -bottomDrawBehavior.height)
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
