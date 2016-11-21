//
//  SAFSettings.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/21/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

// Sorts and Filter related settings singleton class
// This global class enables elegant extension of FIRDatabaseQuery

class SAFSettings {
    static let sharedInstance = SAFSettings()
    private init() {}

    var genderFilterSetting = GenderFilterMode.None
    var ageSortSetting = SortOrderMode.None {
        didSet {
            if ageSortSetting != .None { nameSortSetting = .None }
        }
    }
    var nameSortSetting = SortOrderMode.None {
        didSet {
            if nameSortSetting != .None { ageSortSetting = .None }
        }
    }
}
