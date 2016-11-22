//
//  ListViewController.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {
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

    @IBOutlet weak var profilesAppDisplay: UIButton!
    @IBOutlet weak var tableView: UITableView!

    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setOrUpdateDatabaseObserver()
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
    private func updateInfoLabel() {
        var infoLabels: [String] = []
        var title = UISettings.appName

        if genderFilter != .None { infoLabels += [UISettings.genderFilterLabel[genderFilter]!] }
        if ageSort != .None { infoLabels += [UISettings.ageSortLabel[ageSort]!] }
        if nameSort != .None { infoLabels += [UISettings.nameSortLabel[nameSort]!] }

        if infoLabels != [] { title = infoLabels.joined(separator: " ") }

        profilesAppDisplay.setTitle(title, for: .normal)
    }

    // MARK: Navigation methods
    @IBAction func unwindToListView(_ segue: UIStoryboardSegue) {
        // this function does not need a body, but it needs to be here,
        // so that it's possible to unwind(segue) back here
    }
    @IBAction func unwindToListViewAndRefreshData(_ segue: UIStoryboardSegue) {
        updateInfoLabel()
        setOrUpdateDatabaseObserver()
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewProfile" {
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.mode = .Add

                // Animation settings
                profileVC.modalPresentationStyle = .custom
                profileVC.transitioningDelegate = profileVC

                let expandedFrame = self.view.frame.insetBy(dx: UISettings.standardOffset,
                                                            dy: 2.5 * UISettings.standardOffset)
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
        if segue.identifier == "DropDownMenu" {
            if let menuVC = segue.destination as? MenuViewController {
                // Animation settings
                menuVC.modalPresentationStyle = .custom
                menuVC.transitioningDelegate = menuVC

                let menuWidth = UISettings.menuWidth
                let menuHeight = UISettings.menuHeight

                let screenFrame = self.view.frame
                let xOrigin = screenFrame.width - menuWidth - UISettings.standardOffset
                let yOrigin = 3.0 * UISettings.standardOffset

                let expandedFrame = CGRect(x: xOrigin, y: yOrigin, width: menuWidth, height: menuHeight)
                var shrinkedFrame = expandedFrame
                shrinkedFrame.size.height = 1.0

                menuVC.animationShrinkedFrame = shrinkedFrame
                menuVC.animationExpandedFrame = expandedFrame
            }
        }
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource methods
extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.profileImage.image = profiles[indexPath.row].profileImage
        cell.name.text = profiles[indexPath.row].name
        cell.age.text = String(profiles[indexPath.row].age)
        cell.gender.text = profiles[indexPath.row].gender.description
        cell.hobbies.text = profiles[indexPath.row].hobbies.joined(separator: ", ")
        cell.backgroundColor = profiles[indexPath.row].backgroundColor
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let profile = profiles[indexPath.row]
            profile.ref?.removeValue()
        }
    }
}
