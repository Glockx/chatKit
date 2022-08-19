//
//  CLChannelCellViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Combine
import Foundation
import UIKit

class CLChannelCellViewModel {
    // MARK: - Enum

    /// Cell Action Position: The Current Cell Action Alignment Position
    enum CellActionPosition {
        /// Left Side
        case left

        // Right Side
        case right

        /// Regular Position
        case regular
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Right Cell Actions
    @Published var rightCellActions: [ChannelCellActionView]? = []

    /// Left Cell Actions
    @Published var leftCellActions: [ChannelCellActionView]? = []

    /// Cell Action Swipe Position
    @Published var cellActionSwipePosition = CellActionPosition.regular

    // MARK: - INIT

    init() {
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
