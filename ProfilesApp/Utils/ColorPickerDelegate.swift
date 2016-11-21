//
//  ColorPickerDelegate.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func colorPickerTouched(sender: ColorPickerController, color: UIColor, point: CGPoint, state: UIGestureRecognizerState)
}
