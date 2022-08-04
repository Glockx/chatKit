//
//  OnlyEmojiChatCellViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/04.
//

import Combine
import Foundation

class OnlyEmojiChatCellViewModel {
    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Cell Model
    @Published var cellModel: MessageModel!

    // Emoji Count
    var emojiCount = 1

    // MARK: - INIT

    init() {
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
