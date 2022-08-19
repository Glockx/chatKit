//
//  ChannelCellActionContainerViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Combine
import Foundation

class CCActionContainerViewModel {
    // MARK: - Enum

    /// Alignment Of Cell Actions' Container View
    ///  1. Left
    ///  2. Right
    enum ContainerAlignment {
        /// Left
        case right

        // Right
        case left
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Container Alignment
    var alignment: ContainerAlignment

    // Actions
    @Published var actions: [ChannelCellActionView]? = []

    // MARK: - INIT

    init(actions: [ChannelCellActionView]?, alignment: ContainerAlignment) {
        // Set Actions
        self.actions = actions

        // Container Alignment
        self.alignment = alignment

        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
