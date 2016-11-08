//
//  Extensions.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/7/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

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


