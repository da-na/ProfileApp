//
//  MenuViewController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/22/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var addNewProfileButton: UIButton!
    @IBOutlet weak var clearFiltersOrSortsButton: UIButton!
    @IBOutlet weak var maleFilterButton: UIButton! {
        didSet {
            maleFilterButton.layer.cornerRadius = UISettings.cornerRadius
            maleFilterButton.layer.borderWidth = UISettings.borderWidth
            maleFilterButton.layer.borderColor = UISettings.blue.cgColor
            if genderFilter == .Male {
                maleFilterButton.backgroundColor = UISettings.blue
                maleFilterButton.setTitleColor(UISettings.white, for: .normal)
            }
        }
    }
    @IBOutlet weak var femaleFilterButton: UIButton! {
        didSet {
            femaleFilterButton.layer.cornerRadius = UISettings.cornerRadius
            femaleFilterButton.layer.borderWidth = UISettings.borderWidth
            femaleFilterButton.layer.borderColor = UISettings.blue.cgColor
            if genderFilter == .Female {
                femaleFilterButton.backgroundColor = UISettings.blue
                femaleFilterButton.setTitleColor(UISettings.white, for: .normal)
            }
        }
    }
    @IBOutlet weak var ageSortButton: UIButton! {
        didSet {
            ageSortButton.layer.cornerRadius = UISettings.cornerRadius
            ageSortButton.layer.borderWidth = UISettings.borderWidth
            ageSortButton.layer.borderColor = UISettings.blue.cgColor
            if ageSort != .None {
                ageSortButton.backgroundColor = UISettings.blue
                ageSortButton.setTitleColor(UISettings.white, for: .normal)
                ageSortButton.setTitle(UISettings.ageSortLabel[ageSort], for: .normal)
            }
        }
    }
    @IBOutlet weak var nameSortButton: UIButton! {
        didSet {
            nameSortButton.layer.cornerRadius = UISettings.cornerRadius
            nameSortButton.layer.borderWidth = UISettings.borderWidth
            nameSortButton.layer.borderColor = UISettings.blue.cgColor
            if nameSort != .None {
                nameSortButton.backgroundColor = UISettings.blue
                nameSortButton.setTitleColor(UISettings.white, for: .normal)
                nameSortButton.setTitle(UISettings.nameSortLabel[nameSort], for: .normal)
            }
        }
    }
    var genderFilter: GenderFilterMode {
        get { return SAFSettings.sharedInstance.genderFilterSetting }
        set { SAFSettings.sharedInstance.genderFilterSetting = newValue }
    }
    var ageSort: SortOrderMode {
        get { return SAFSettings.sharedInstance.ageSortSetting }
        set { SAFSettings.sharedInstance.ageSortSetting = newValue }
    }
    var nameSort: SortOrderMode {
        get { return SAFSettings.sharedInstance.nameSortSetting }
        set { SAFSettings.sharedInstance.nameSortSetting = newValue }
    }
    var animationShrinkedFrame: CGRect?
    var animationExpandedFrame: CGRect?

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


// MARK: UIViewControllerTransitioningDelegate methods
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
