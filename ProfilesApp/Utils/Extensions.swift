//
//  Extensions.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit
import Firebase

// MARK: Dictionary extension
// TODO: Uncomment what's below, when upgrading to Swift 3.1 :)
// extension Dictionary where Element == [String: Float] {
extension Dictionary where Key: ExpressibleByStringLiteral, Value: FloatingPoint {
    func toUIColor() -> UIColor? {
        if let red: Float = self["red"] as? Float,
            let green: Float = self["green"] as? Float,
            let blue: Float = self["blue"] as? Float,
            let alpha: Float = self["alpha"] as? Float {
            return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
        }
        return nil
    }
}

// MARK: UIColor extension
extension UIColor {
    func toDictionary() -> [String: Float] {
        var red: CGFloat = 0.0, green: CGFloat = 0.0,
            blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return ["red" : Float(red), "blue": Float(blue),
                "green": Float(green), "alpha": Float(alpha)]
    }
}

// MARK: Firebase extension
// NOTE: At this point Firebase allows only one call of self.queryOrdered(byChild: child)
// therefore, if ageSort or nameSort are set, then gender filtering must be done on client side
extension FIRDatabaseQuery {
    func sortAndFilterQuery() -> FIRDatabaseQuery {
        // NOTE: Only one of those functions actually calls a query on Firebase - which one depends on SAFSettings
        return self.uidSort().genderFilter().ageSort().nameSort()
    }
    func genderFilter() -> FIRDatabaseQuery {
        let settings = SAFSettings.sharedInstance
        let genderFilter = settings.genderFilterSetting
        let ageSort = settings.ageSortSetting
        let nameSort = settings.nameSortSetting

        guard genderFilter != .None && ageSort == .None && nameSort == .None else { return self }

        return self.queryOrdered(byChild: "gender").queryEqual(toValue: genderFilter.description)
    }
    func ageSort() -> FIRDatabaseQuery {
        let ageSort = SAFSettings.sharedInstance.ageSortSetting
        guard ageSort != .None else { return self }

        return self.queryOrdered(byChild: "age")
    }
    func nameSort() -> FIRDatabaseQuery {
        let nameSort = SAFSettings.sharedInstance.nameSortSetting
        guard nameSort != .None else { return self }

        return self.queryOrdered(byChild: "name")
    }
    func uidSort() -> FIRDatabaseQuery {
        let settings = SAFSettings.sharedInstance
        let genderFilter = settings.genderFilterSetting
        let ageSort = settings.ageSortSetting
        let nameSort = settings.nameSortSetting

        guard genderFilter == .None && ageSort == .None && nameSort == .None else { return self }

        return self.queryOrdered(byChild: "uid")
    }
}


