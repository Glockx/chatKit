//
//  MediaAndTextChatCellViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/05.
//

import Combine
import Foundation
import UIKit

class MediaAndTextChatCellViewModel: NSObject, UIContextMenuInteractionDelegate {
    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Cell Model
    @Published var cellModel: MessageModel!

    /// Media Asset Item
    var mediaItem: MediaItem!

    // MARK: - INIT

    override init() {
        super.init()
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}

    // MARK: - contextMenuInteraction

    func contextMenuInteraction(_: UIContextMenuInteraction, configurationForMenuAtLocation _: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { _ in
                                              UIMenu(title: "", children: [])

                                          })
    }
}
