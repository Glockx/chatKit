//
//  OnlyEmojiCellProvider.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/04.
//

import CollectionKit
import Foundation

extension OnlyEmojiChatCellView: CellViewProvider, CellSizeProvider {
    typealias CellData = MessageModel

    // MARK: - View Source Provider

    static var viewSourceProvider: ViewSource<MessageModel, OnlyEmojiChatCellView> {
        // Collection View Source
        return ClosureViewSource(viewGenerator: { _, _ -> OnlyEmojiChatCellView in
            OnlyEmojiChatCellView(viewModel: .init())
        }, viewUpdater: { (cell: OnlyEmojiChatCellView, data: MessageModel, _: Int) in
            // Set Model
            cell.setDetails(model: data)
        })
    }

    // MARK: - Size Source Provider

    static var sizeSourceProvider: SizeSource<CellData> {
        return OnlyEmojiChatCellSizeSource()
    }
}

// MARK: - FAQCellViewCachedSizeSource

class OnlyEmojiChatCellSizeSource: SizeSource<MessageModel> {
    // Size Caches
    var sizeCaches: [MessageModel: CGFloat]! = [:]
    let cell = OnlyEmojiChatCellView(viewModel: .init())

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
