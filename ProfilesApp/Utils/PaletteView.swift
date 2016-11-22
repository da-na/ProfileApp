//
//  PaletteView.swift
//  ProfilesApp
//
//  Created by Dagna Bieda on 11/20/16.
//  Copyright © 2016 Dagna Bieda. All rights reserved.
//
//  Most of code comes from http://stackoverflow.com/questions/27208386/simple-swift-color-picker-popover-ios

import UIKit

class PaletteView: UIView {
    let saturationExponentTop: Float = 2.0
    let saturationExponentBottom: Float = 0.8
    var numberOfElements: CGFloat = 7.0 {
        didSet { setNeedsDisplay() }
    }
    var elementSize: CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        elementSize = rect.height / numberOfElements
        let context = UIGraphicsGetCurrentContext()

        for y in stride(from: CGFloat(0.0), to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height

            for x in stride(from: CGFloat(0.0), to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: x, y: y, width: elementSize, height: elementSize))
            }
        }
    }

    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                                   y: elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)

        var yPos: CGFloat = 0.0
        let halfHeight = (self.bounds.height / 2)

        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else { //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        let xPos = hue * self.bounds.width

        return CGPoint(x: xPos, y: yPos)
    }
}
