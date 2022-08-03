//
//  ChatTextingBarViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import Combine
import CoreGraphics
import Foundation

class ChatTextingBarViewModel {
    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Default Text View Height
    var defaultTextviewHeight: CGFloat = 40

    /// Text View Height
    @Published var textViewHeight: CGFloat = 40

    /// Max Text View Height
    var maxTextViewHeight: CGFloat = 75.0

    /// Keyboard Is Hidden
    var keyboardIsHidden = true

    /// Chat Main Model
    weak var chatMainModel: ChatMainViewModel!

    // MARK: - INIT

    init(chatMainModel: ChatMainViewModel) {
        // Set Chat Main Model
        self.chatMainModel = chatMainModel
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
