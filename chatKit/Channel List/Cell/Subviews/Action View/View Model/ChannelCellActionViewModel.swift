//
//  ChannelCellActionViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Combine
import Foundation
import UIKit

class ChannelCellActionViewModel {
    // MARK: - Enum

    /// Action Style Of Cell Swipe Action
    /// 1. Regular
    /// 2. Destructive
    enum ActionStyle {
        /// Regular Style
        case regular

        /// Destructive Style
        case destructive
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Cell Action Style
    var actionStyle: ActionStyle

    /// Cell Icon Image
    var cellIcon: UIImage?

    /// Cell Action
    var action: (() -> Void)!

    // MARK: - INIT

    init(actionStyle: ActionStyle, cellIcon: UIImage? = nil, action: @escaping (() -> Void)) {
        // Set Action Style
        self.actionStyle = actionStyle
        // Set Cell Icon
        self.cellIcon = cellIcon
        // Set Action
        self.action = action

        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
