//
//  CustomPresentationController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect { return startingFrame }
    lazy var dimmingView: UIView = {
        return UIView(frame: self.containerView!.bounds)
    }()
    var dimmingViewBackgroundColor: UIColor!
    var startingFrame: CGRect

    // MARK: Initializer
    init(presentedViewController: UIViewController, presentingViewController: UIViewController, startingFrame: CGRect, dimmingColor: UIColor = UISettings.gray.withAlphaComponent(0.5)) {

        self.startingFrame = startingFrame
        self.dimmingViewBackgroundColor = dimmingColor

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: Gesture recognition
    func initGestureRecognizer(){
        let tapGestureRecognizerOutsidePresentedView = UITapGestureRecognizer.init(target: self, action: #selector(recognizeTapGesture))
        self.dimmingView.addGestureRecognizer(tapGestureRecognizerOutsidePresentedView)
    }
    @objc func recognizeTapGesture(sender: UITapGestureRecognizer){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }

    // MARK: Presentation Controller Lifecycle
    override func presentationTransitionWillBegin() {

        // Add round border to the presented view
        self.presentedView?.clipsToBounds = true
        self.presentedView!.layer.cornerRadius = UISettings.cornerRadius
        self.presentedView!.layer.borderWidth = UISettings.borderWidth
        self.presentedView!.layer.borderColor = UISettings.gray.cgColor

        // Add the dimming view and the presented view to the hierarchy
        dimmingView.backgroundColor = dimmingViewBackgroundColor
        dimmingView.frame = self.containerView!.bounds
        dimmingView.alpha = 0.0

        self.containerView!.addSubview(dimmingView)
        self.containerView!.addSubview(self.presentedView!)
        self.initGestureRecognizer()

        // Fade in the dimming view alongside the transition
        let transitionCoordinator = self.presentingViewController.transitionCoordinator

        transitionCoordinator!.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 1.0 }, completion:nil)
    }

    override func presentationTransitionDidEnd(_ completed: Bool)  {
        if !completed { self.dimmingView.removeFromSuperview() }
    }

    override func dismissalTransitionWillBegin()  {
        // Fade out the dimming view alongside the transition
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator!.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 0.0 }, completion:nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed { self.dimmingView.removeFromSuperview() }
    }
}
