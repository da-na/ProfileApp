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

    mutating func flipValue() {
        switch self {
        case .Male : self = .Female
        case .Female : self = .Male
        default: break // Do nothing
        }
    }
}

