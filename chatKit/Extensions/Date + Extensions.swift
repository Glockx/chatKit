//
//  Date + Extensions.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Foundation

extension Date {
    /// Generate Random Date With-in Given Dates
    /// - Parameter range: A range of Two Dates
    /// - Returns: A Date
    static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow ... range.upperBound.timeIntervalSinceNow
            )
        )
    }
}
