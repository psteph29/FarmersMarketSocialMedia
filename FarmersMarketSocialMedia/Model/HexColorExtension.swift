//
//  HexColorExtension.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 9/22/23.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        var hexColor = hex

        if hex.hasPrefix("#") {
            hexColor.remove(at: hexColor.startIndex)
        }

        if hexColor.count == 6 {
            hexColor.append("FF") // append "FF" to represent the alpha value of 1.0
        }

        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }

        return nil
    }
}

