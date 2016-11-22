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
            setBorders(for: maleFilterButton)
            setColors(for: maleFilterButton, currentState: genderFilter, selectedState: .Male)
        }
    }
    @IBOutlet weak var femaleFilterButton: UIButton! {
        didSet {
            setBorders(for: femaleFilterButton)
            setColors(for: femaleFilterButton, currentState: genderFilter, selectedState: .Female)
        }
    }
    @IBOutlet weak var ageSortButton: UIButton! {
        didSet {
            setBorders(for: ageSortButton)
            setColorsAndTitle(for: ageSortButton, currentState: ageSort, title: UISettings.ageSortLabel[ageSort])
        }
    }
    @IBOutlet weak var nameSortButton: UIButton! {
        didSet {
            setBorders(for: nameSortButton)
            setColorsAndTitle(for: nameSortButton, currentState: nameSort, title: UISettings.nameSortLabel[nameSort])
        }
    }
    var genderFilter: GenderFilterMode {
        get { return SAFSettings.sharedInstance.genderFilterSetting }
        set {
            SAFSettings.sharedInstance.genderFilterSetting = newValue
            setColors(for: maleFilterButton, currentState: newValue, selectedState: .Male)
            setColors(for: femaleFilterButton, currentState: newValue, selectedState: .Female)
        }
    }
    var ageSort: SortOrderMode {
        get { return SAFSettings.sharedInstance.ageSortSetting }
        set {
            SAFSettings.sharedInstance.ageSortSetting = newValue
            setColorsAndTitle(for: ageSortButton, currentState: ageSort, title: UISettings.ageSortLabel[ageSort])
        }
    }
    var nameSort: SortOrderMode {
        get { return SAFSettings.sharedInstance.nameSortSetting }
        set {
            SAFSettings.sharedInstance.nameSortSetting = newValue
            setColorsAndTitle(for: nameSortButton, currentState: nameSort, title: UISettings.nameSortLabel[nameSort])
        }
    }
    var animationShrinkedFrame: CGRect?
    var animationExpandedFrame: CGRect?

    @IBAction func addNewProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AddNewProfile", sender: self)
    }
    @IBAction func clearFiltersOrSorts(_ sender: UIButton) {
        genderFilter = .None
        ageSort = .None
        nameSort = .None
        dismissMeWithDelay()
    }
    @IBAction func setUnsetMaleFilter(_ sender: UIButton) {
        switch genderFilter {
        case .None, .Female: genderFilter = .Male
        case .Male: genderFilter = .None
        }
        dismissMeWithDelay()
    }
    @IBAction func setUnsetFemaleFilter(_ sender: UIButton) {
        switch genderFilter {
        case .None, .Male: genderFilter = .Female
        case .Female: genderFilter = .None
        }
        dismissMeWithDelay()
    }
    @IBAction func setUnsetAgeSort(_ sender: UIButton) {
        switch ageSort {
        case .None: ageSort = .Ascending
        case .Ascending: ageSort = .Descending
        case .Descending: ageSort = .None
        }
        dismissMeWithDelay()
    }
    @IBAction func setUnsetNameSort(_ sender: UIButton) {
        switch nameSort {
        case .None: nameSort = .Ascending
        case .Ascending: nameSort = .Descending
        case .Descending: nameSort = .None
        }
        dismissMeWithDelay()
    }

    // MARK: Helper methods
    private func setColors(for button: UIButton, currentState: GenderFilterMode, selectedState: GenderFilterMode){
        if currentState == selectedState {
            button.backgroundColor = UISettings.blue
            button.setTitleColor(UISettings.white, for: .normal)
        } else {
            button.backgroundColor = UISettings.white.withAlphaComponent(1.0)
            button.setTitleColor(UISettings.blue, for: .normal)
        }
    }
    private func setColorsAndTitle(for button: UIButton, currentState: SortOrderMode, title: String?){
        if currentState != .None {
            button.backgroundColor = UISettings.blue
            button.setTitleColor(UISettings.white, for: .normal)
        } else {
            button.backgroundColor = UISettings.white.withAlphaComponent(1.0)
            button.setTitleColor(UISettings.blue, for: .normal)
        }
        button.setTitle(title, for: .normal)
    }
    private func setBorders(for button: UIButton){
        button.layer.cornerRadius = UISettings.cornerRadius
        button.layer.borderWidth = UISettings.borderWidth
        button.layer.borderColor = UISettings.blue.cgColor
    }
    private func dismissMeWithDelay(){
        self.perform(#selector(dismissMe), with: nil, afterDelay: 0.8)
    }
    func dismissMe(){
        performSegue(withIdentifier: "RefreshTableView", sender: self)
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
