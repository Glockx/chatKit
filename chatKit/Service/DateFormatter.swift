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

    /// Relative Date Formatter
    var relativeDateFormatter = RelativeDateTimeFormatter().then {
        $0.unitsStyle = .full
        $0.dateTimeStyle = .numeric
        $0.formattingContext = .dynamic
    }

    /// Date Formatter
    var dateFormatter = DateFormatter().then {
        $0.dateFormat = "HH:mm a"
    }

    // MARK: - Init

    init() {}

    // MARK: - Format Relative Date To Message Time Style

    /// - Parameter date: Date
    /// - Returns: Format Date To Message Time Style. Example: 4:25 PM
    func relativeFormatToMessageStyle(timeInterval: TimeInterval) -> String? {
        return relativeDateFormatter.string(for: Date(timeIntervalSince1970: timeInterval))
    }

    // MARK: - Format Relative Date To Message Time Style

    /// - Parameter date: Date
    /// - Returns: Format Date To Message Time Style. Example: 4:25 PM
    func formatToMessageStyle(timeInterval: TimeInterval) -> String? {
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}
