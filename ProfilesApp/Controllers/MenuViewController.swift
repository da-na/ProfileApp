//
//  MenuViewController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/22/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var animationShrinkedFrame: CGRect?
    var animationExpandedFrame: CGRect?

    @IBOutlet weak var addNewProfileButton: UIButton!
    @IBOutlet weak var clearFiltersOrSortsButton: UIButton!
    @IBOutlet weak var maleFilterButton: UIButton!
    @IBOutlet weak var femaleFilterButton: UIButton!
    @IBOutlet weak var ageSortButton: UIButton!
    @IBOutlet weak var nameSortButton: UIButton!

    @IBAction func addNewProfile(_ sender: UIButton) {
    }
    @IBAction func clearFiltersOrSorts(_ sender: UIButton) {
    }
    @IBAction func setUnsetMaleFilter(_ sender: UIButton) {
    }
    @IBAction func setUnsetFemaleFilter(_ sender: UIButton) {
    }
    @IBAction func setUnsetAgeSort(_ sender: UIButton) {
    }
    @IBAction func setUnsetNameSort(_ sender: UIButton) {
    }


}

extension MenuViewController: UIViewControllerTransitioningDelegate {

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
