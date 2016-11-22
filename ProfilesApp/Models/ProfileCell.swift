//
//  ProfileCell.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.clipsToBounds = true
            profileImage.layer.cornerRadius = 0.5 * UISettings.menuButtonDiameter
            profileImage.layer.borderWidth = UISettings.borderWidth
            profileImage.layer.borderColor = UISettings.darkGray.cgColor
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var hobbies: UILabel!

}
