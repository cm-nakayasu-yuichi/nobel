//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import UIKit

class DialogBehavior {
    
    var animationDuration: TimeInterval = 0.25
    
    var overlayTapDismissalEnabled = true
    
    var overlayColor = UIColor.black.withAlphaComponent(0.5)
    
    var overlayIsBlur = false
    
    var overlayBlurEffectStyle: UIBlurEffect.Style = .regular
    
    var overlayBlurAlpha: CGFloat = 1.0
    
    var fixedSize: CGSize?
    
    var presentation: DialogAnimatedTransitioning? {
        return nil
    }
    
    var dismissal: DialogAnimatedTransitioning? {
        return nil
    }
    
    func frame(containerSize: CGSize, presentedSize: CGSize) -> CGRect {
        let origin = CGPoint(
            x: (containerSize.width  - presentedSize.width)  / 2,
            y: (containerSize.height - presentedSize.height) / 2
        )
        return CGRect(origin: origin, size: presentedSize)
    }
}

class Dialog: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate static var instances = [Dialog]()
    
    private let behavior: DialogBehavior
    
    class func show(_ presentedViewController: UIViewController, from presentingViewController: UIViewController, behavior: DialogBehavior, completion: (() -> Void)? = nil) {
        let instance = Dialog(behavior)
        Dialog.instances.append(instance)
        
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.transitioningDelegate = instance
        
        presentingViewController.present(presentedViewController, animated: true, completion: completion)
    }
    
    private init(_ behavior: DialogBehavior) {
        self.behavior = behavior
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = DialogPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        controller.behavior = behavior
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return behavior.presentation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return behavior.dismissal
    }
}

private class DialogPresentationController: UIPresentationController {
    
    var behavior: DialogBehavior!
    
    private var overlay: UIView!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard
            let containerView = self.containerView,
            let presentedView = self.presentedView
            else {
                return .zero
        }
        
        if behavior.fixedSize == nil && presentedViewController.isNavigator {
            let width = UIScreen.main.bounds.width - 60
            let height = width * 0.8
            behavior.fixedSize = CGSize(width: width, height: height)
        }
        
        let presentedSize = behavior.fixedSize ??
            presentedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return behavior.frame(
            containerSize: containerView.bounds.size,
            presentedSize: presentedSize
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
        
        if behavior.overlayIsBlur {
            let effect = UIBlurEffect(style: behavior.overlayBlurEffectStyle)
            overlay = UIVisualEffectView(effect: effect)
            overlay.frame = containerView.bounds
            overlay.backgroundColor = .clear
        } else {
            overlay = UIView(frame: containerView.bounds)
            overlay.backgroundColor = behavior.overlayColor
        }
        
        overlay.alpha = 0
        if behavior.overlayTapDismissalEnabled {
            overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOverlay)))
        }
        
        containerView.insertSubview(overlay, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [unowned self] context in
                self.overlay.alpha = self.behavior.overlayIsBlur ? self.behavior.overlayBlurAlpha : 1
                }, completion: nil)
        } else {
            overlay.alpha = behavior.overlayIsBlur ? self.behavior.overlayBlurAlpha : 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            overlay.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [unowned self] context in
                self.overlay.alpha = 0
                }, completion: nil)
        } else {
            overlay.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlay.removeFromSuperview()
            Dialog.instances.removeLast()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        overlay.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    @objc func didTapOverlay() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

class DialogAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let behavior: DialogBehavior
    
    init(behavior: DialogBehavior) {
        self.behavior = behavior
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return behavior.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // expect override
        transitionContext.completeTransition(true)
    }
}

private extension UIViewController {
    
    var isNavigator: Bool {
        return self is UINavigationController || self is UITabBarController
    }
}
