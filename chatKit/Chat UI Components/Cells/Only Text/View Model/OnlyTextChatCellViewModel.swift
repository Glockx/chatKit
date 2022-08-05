//
//  OnlyTextChatCellViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Combine
import Foundation
import UIKit

class OnlyTextChatCellViewModel: NSObject, UIContextMenuInteractionDelegate {
    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Cell Model
    @Published var cellModel: MessageModel!

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
