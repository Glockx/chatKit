//
//  DateFormatter.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation

class CDateFormatter {
    // MARK: - Variables

    // Shared
    static let shared = CDateFormatter()

    /// Date Formatter
    var dateFormatter = DateFormatter().then {
        $0.dateFormat = "hh:mm a"
    }

    // MARK: - Init

    init() {}

    // MARK: - Format Date To Message Time Style

    /// - Parameter date: Date
    /// - Returns: Format Date To Message Time Style. Example: 4:25 PM
    func formatToMessageStyle(timeInterval: TimeInterval) -> String? {
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}
