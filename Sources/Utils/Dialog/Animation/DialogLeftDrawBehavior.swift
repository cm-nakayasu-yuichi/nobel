//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class DialogLeftDrawBehavior: DialogBehavior {
    
    private let width: CGFloat
    
    init(width: CGFloat = 200) {
        self.width = width
        super.init()
    }
    
    override func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: self.width,
            height: containerSize.height
        )
    }
    
    class Presentation: DialogAnimatedTransitioning {
        
        override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toView = transitionContext.view(forKey: .to),
                let toController = transitionContext.viewController(forKey: .to),
                let leftDrawBehavior = behavior as? DialogLeftDrawBehavior
                else {
                    return
            }
            
            toView.frame = transitionContext.finalFrame(for: toController)
            transitionContext.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(translationX: -leftDrawBehavior.width, y: 0)
            
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
                let leftDrawBehavior = behavior as? DialogLeftDrawBehavior
                else {
                    return
            }
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(translationX: -leftDrawBehavior.width, y: 0)
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
