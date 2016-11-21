//
//  SortOrderMode.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/21/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

enum SortOrderMode {
    case Ascending, Descending, None

    mutating func flipValue() {
        switch self {
        case .Ascending : self = .Descending
        case .Descending : self = .Ascending
        default: break // Do nothing
        }
    }
}
