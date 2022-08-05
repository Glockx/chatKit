//
//  ChatTextingBarViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import Combine
import Foundation
import UIKit

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

    /// Only Image Action
    lazy var onlyImageAction = UIAction(title: "Only Image",
                                        image: UIImage(systemName: "photo.fill")) { [weak self] _ in
        guard let self = self else { return }
        // Send Image Only
        self.chatMainModel.sendOnlyImageAction()
    }

    /// Only Video Action
    lazy var onlyVideoAction = UIAction(title: "Only Video",
                                        image: UIImage(systemName: "tv.fill")) { [weak self] _ in
        guard let self = self else { return }
        // Send Image Only
        self.chatMainModel.sendOnlyVideoAction()
    }

    // Media Menu
    lazy var mediaMenu = UIMenu(title: "Media Items", identifier: .file, options: [], children: [onlyImageAction, onlyVideoAction])

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
