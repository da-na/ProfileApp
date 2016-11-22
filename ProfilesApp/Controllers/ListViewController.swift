//
//  ListViewController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UITableViewController {

    @IBOutlet weak var genderFilterButton: UIBarButtonItem!
    @IBOutlet weak var ageSortButton: UIBarButtonItem!
    @IBOutlet weak var nameSortButton: UIBarButtonItem!
    @IBOutlet weak var resetFiltersButton: UIBarButtonItem!
    @IBOutlet weak var addNewProfileButton: UIBarButtonItem!

    let ref = FIRDatabase.database().reference(withPath: "profiles")
    var profiles: [Profile] = []

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

    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonLabels()
        setOrUpdateDatabaseObserver()
    }

    // MARK: Button handling methods
    @IBAction func setGenderFilter(_ sender: UIBarButtonItem) {
        if genderFilter == .None { genderFilter = .Male }
        genderFilter.flipValue()

        updateButtonLabels()
        setOrUpdateDatabaseObserver()
    }
    @IBAction func setAgeSort(_ sender: UIBarButtonItem) {
        if ageSort == .None { ageSort = .Descending }
        ageSort.flipValue()

        updateButtonLabels()
        setOrUpdateDatabaseObserver()
    }
    @IBAction func setNameSort(_ sender: UIBarButtonItem) {
        if nameSort == .None { nameSort = .Descending }
        nameSort.flipValue()

        updateButtonLabels()
        setOrUpdateDatabaseObserver()
    }
    @IBAction func clearSortsAndFilters(_ sender: Any) {
        genderFilter = .None
        ageSort = .None
        nameSort = .None

        setOrUpdateDatabaseObserver()
        updateButtonLabels()
    }
    // MARK: Helper methods
    private func setOrUpdateDatabaseObserver() {
        ref.removeAllObservers()
        ref.sortAndFilterQuery().observe(.value, with: { snapshot in self.setProfiles(snapshot) })
    }
    private func setProfiles(_ snapshot: FIRDataSnapshot) {
        var newProfiles: [Profile] = []

        for item in snapshot.children {
            let profile = Profile(snapshot: item as! FIRDataSnapshot)
            newProfiles.append(profile)
        }
        // NOTE: if ageSort or nameSort are set, then gender filtering must be done on client side
        let filterGenderLocally = (genderFilter != .None && (ageSort != .None || nameSort != .None))
        if filterGenderLocally {
            newProfiles = newProfiles.filter{ $0.gender.description == genderFilter.description }
        }

        if ageSort == .Descending || nameSort == .Descending {
            self.profiles = Array(newProfiles.reversed())
        } else {
            self.profiles = newProfiles
        }
        self.tableView.reloadData()
    }
    private func setButtonLabels() {
        updateButtonLabels()
        resetFiltersButton.title = ""
        addNewProfileButton.title = UISettings.addNewProfile
    }
    private func updateButtonLabels() {
        resetFiltersButton.title = UISettings.resetFilters
        genderFilterButton.title = UISettings.genderFilterLabel[genderFilter]
        ageSortButton.title = UISettings.ageSortLabel[ageSort]
        nameSortButton.title = UISettings.nameSortLabel[nameSort]
    }

    // MARK: Navigation methods
    @IBAction func unwindToListView(_ segue: UIStoryboardSegue){
        // this function does not need a body, but it needs to be here,
        // so that it's possible to unwind(segue) back here
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewProfile" {
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.mode = .Add

                // Animation settings
                profileVC.modalPresentationStyle = .custom
                profileVC.transitioningDelegate = profileVC

                let expandedFrame = self.view.frame.insetBy(dx: UISettings.standardOffset,
                                                            dy: 3.0 * UISettings.standardOffset)
                var shrinkedFrame = expandedFrame
                shrinkedFrame.size.height = 1.0

                profileVC.animationShrinkedFrame = shrinkedFrame
                profileVC.animationExpandedFrame = expandedFrame

                profileVC.preferredImageWidth = expandedFrame.width
            }
        }
        if segue.identifier == "EditProfile" {
            if let profileVC = segue.destination as? ProfileViewController,
               let cell = sender as? ProfileCell {
                let row = (self.tableView.indexPath(for: cell)?.row)!
                profileVC.profile = profiles[row]
                profileVC.mode = .Edit
            }
        }
    }

    // MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.profileImage.image = profiles[indexPath.row].profileImage
        cell.name.text = profiles[indexPath.row].name
        cell.age.text = String(profiles[indexPath.row].age)
        cell.gender.text = profiles[indexPath.row].gender.description
        cell.hobbies.text = profiles[indexPath.row].hobbies.joined(separator: ", ")
        cell.backgroundColor = profiles[indexPath.row].backgroundColor
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let profile = profiles[indexPath.row]
            profile.ref?.removeValue()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
