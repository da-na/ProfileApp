//
//  ColorPickerController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {
    weak internal var delegate: ColorPickerDelegate?

    var animationShrinkedFrame: CGRect?
    var animationExpandedFrame: CGRect?

    // MARK: VCLifecycle
    override func viewDidLoad() {
        self.view = PaletteView()
        self.view.clipsToBounds = true
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(touchedColor))
        self.view.addGestureRecognizer(touchGesture)
    }

    // MARK: Gesture recognition
    func touchedColor(gestureRecognizer: UITapGestureRecognizer){
        let point = gestureRecognizer.location(in: self.view)
        let color = (self.view as! PaletteView).getColorAtPoint(point: point)

        self.delegate?.colorPickerTouched(sender: self, color: color, point: point, state: gestureRecognizer.state)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIViewControllerTransitioningDelegate methods
extension ColorPickerController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presented == self ?
            CustomPresentationController(presentedViewController: presented, presentingViewController: source, startingFrame: animationShrinkedFrame!)
            : nil
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presented == self ?
            CustomTransition(isPresenting: true, frameToResizeTo: animationExpandedFrame!)
            : nil
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissed == self ?
            CustomTransition(isPresenting: false, frameToResizeTo: animationShrinkedFrame!)
            : nil
    }
}
