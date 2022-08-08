//
//  OnlyTextCellProvider.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import CollectionKit
import Foundation
import UIKit

extension OnlyTextChatCellView: CellViewProvider, CellSizeProvider {
    typealias CellData = MessageModel

    // MARK: - View Source Provider

    static var viewSourceProvider: ViewSource<MessageModel, OnlyTextChatCellView> {
        // Collection View Source
        return ClosureViewSource(viewGenerator: { _, _ -> OnlyTextChatCellView in
            OnlyTextChatCellView(viewModel: .init())
        }, viewUpdater: { (cell: OnlyTextChatCellView, data: MessageModel, _: Int) in
            // Set Model
            cell.setDetails(model: data)
        })
    }

    // MARK: - Size Source Provider

    static var sizeSourceProvider: SizeSource<CellData> {
        return OnlyTextChatCellSizeSource.shared
    }
}

// MARK: - OnlyTextChatCellViewSource


// MARK: - OnlyTextChatCellSizeSource

class OnlyTextChatCellSizeSource: SizeSource<MessageModel> {
    // Size Caches
    var sizeCaches: [MessageModel: CGFloat]! = [:]
    let cell = OnlyTextChatCellView(viewModel: .init())

    // Shared
    static let shared = OnlyTextChatCellSizeSource()

    // MARK: - Size

    override func size(at _: Int, data: MessageModel, collectionSize: CGSize) -> CGSize {
        // Check If Cahce Is Exist

        if sizeCaches[data] != nil {
            return .init(width: collectionSize.width, height: sizeCaches[data]!)
            // Calculate Size
        } else {
            // Set Details
            cell.setDetails(model: data)
            // Calculate New Size
            let size = cell.sizeThatFits(.init(width: collectionSize.width, height: .greatestFiniteMagnitude))
            // Set Cache
            sizeCaches[data] = size.height
            // Return Calculated size
            return .init(width: collectionSize.width, height: sizeCaches[data]!)
        }
    }
}
