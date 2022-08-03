//
//  OnlyTextChatCellViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Combine
import Foundation

class OnlyTextChatCellViewModel {
    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Cell Model
    @Published var cellModel: MessageModel!

    // MARK: - INIT

    init() {
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
