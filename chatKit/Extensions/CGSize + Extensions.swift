//
//  CGSize + Extensions.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import CoreGraphics
import Foundation

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(height)
        hasher.combine(width)
    }
}
