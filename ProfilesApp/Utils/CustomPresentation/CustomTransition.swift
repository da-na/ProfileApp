//
//  CustomTransition.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let isPresenting: Bool
    let duration: TimeInterval = 0.5
    let frameToResizeTo: CGRect

    // MARK: Initializer
    init(isPresenting: Bool, frameToResizeTo: CGRect) {
        self.frameToResizeTo = frameToResizeTo
        self.isPresenting = isPresenting
        super.init()
    }

    // MARK: UIViewControllerAnimatedTransitioning methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)  {
        isPresenting ?
            animatePresentationWithTransitionContext(transitionContext: transitionContext)
            : animateDismissalWithTransitionContext(transitionContext: transitionContext)
    }

    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {

        let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView

        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController!)
        containerView.addSubview(presentedControllerView)

        // Animate the presented view to it's final position
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {

            presentedControllerView.frame = self.frameToResizeTo

        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }

    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)!

        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {

            presentedControllerView.frame = self.frameToResizeTo

        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
        })
    }
}

