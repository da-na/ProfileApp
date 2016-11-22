//
//  UISettings.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

class UISettings {

    // MARK: Button Layer related settings
    static let cornerRadius = CGFloat(5.0)
    static let borderWidth = CGFloat(1.0)

    // MARK: Menu Buttons settings
    static let menuButtonDiameter = CGFloat(60.0)

    // MARK: Offset settings
    static let standardOffset = CGFloat(20.0)

    // MARK: Colors
    static let green = UIColor(colorLiteralRed: 0.43, green: 0.81, blue: 0.02, alpha: 1)
    static let blue = UIColor(colorLiteralRed: 0.20, green: 0.50, blue: 0.87, alpha: 1)
    static let gray = UIColor.lightGray
    static let darkGray = UIColor.darkGray
    static let white = UIColor.white

    // MARK: Filter settings
    static let genderFilterLabel: [GenderFilterMode: String] = [.None: "\u{1F469} or \u{1F466}", .Female: "\u{1F469}", .Male: "\u{1F466}"]
    static let nameSortLabel: [SortOrderMode: String] = [.None: "Name", .Ascending: "Name ⬆︎", .Descending: "Name ⬇︎"]
    static let ageSortLabel: [SortOrderMode: String] = [.None: "Age", .Ascending: "Age ⬆︎", .Descending: "Age ⬇︎"]
    static let resetFilters = "reset"
    static let addNewProfile = "+\u{1F464}"

    // MARK: MENU settings
    static let menuWidth = CGFloat(200.0)
    static let menuHeight = CGFloat(230.0)
}
