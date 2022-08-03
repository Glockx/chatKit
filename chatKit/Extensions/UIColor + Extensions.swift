//
//  UIColor + Extensions.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - Color With Hex Number

    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    convenience init(hex: String, alpha: CGFloat = 1) {
        let chars = Array(hex.dropFirst())
        self.init(red: .init(strtoul(String(chars[0 ... 1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2 ... 3]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[4 ... 5]), nil, 16)) / 255,
                  alpha: alpha)
    }
}
