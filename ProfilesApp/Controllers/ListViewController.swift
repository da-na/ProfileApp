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

    // MARK: Properties
    var profiles: [Profile] = []
    let ref = FIRDatabase.database().reference(withPath: "profiles")

    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatabaseObserver()
    }

    // MARK: Helper methods
    func addDatabaseObserver() {
        ref.observe(.value, with: { snapshot in
            var newProfiles: [Profile] = []

            for item in snapshot.children {
                let profile = Profile(snapshot: item as! FIRDataSnapshot)
                newProfiles.append(profile)
            }
            self.profiles = newProfiles
            self.tableView.reloadData()
        })
    }
    // MARK: Navigation methods
    @IBAction func unwindToListView(_ segue: UIStoryboardSegue){
        // this function does not need a body, but it needs to be here,
        // so that it's possible to unwind(segue) back here
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
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
