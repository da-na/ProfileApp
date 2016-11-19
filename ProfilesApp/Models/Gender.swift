//
//  Gender.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/19/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

enum Gender: String {
    case Female = "Female", Male = "Male"

    var description: String {
        return self.rawValue
    }

    static func allValues() -> [String]{
        return ["Female", "Male"]
    }
}
