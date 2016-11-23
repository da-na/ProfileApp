//
//  GenderFilterMode.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/21/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

enum GenderFilterMode {
    case Male, Female, None

    var description: String {
        switch self {
        case .Male : return "Male"
        case .Female : return "Female"
        default: return ""
        }
    }
}

