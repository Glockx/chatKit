//
//  MediaAndTextChatCellProvider.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/05.
//

import CollectionKit
import Foundation

extension MediaAndTextChatCellView: CellViewProvider, CellSizeProvider {
    typealias CellData = MessageModel

    // MARK: - View Source Provider

    static var viewSourceProvider: ViewSource<MessageModel, MediaAndTextChatCellView> {
        // Collection View Source
        return ClosureViewSource(viewGenerator: { _, _ -> MediaAndTextChatCellView in
            MediaAndTextChatCellView(viewModel: .init())
        }, viewUpdater: { (cell: MediaAndTextChatCellView, data: MessageModel, _: Int) in
            // Set Model
            cell.setDetails(model: data)
        })
    }

    // MARK: - Size Source Provider

    static var sizeSourceProvider: SizeSource<CellData> {
        return MediaAndTextChatCellSizeProvider()
    }
}

// MARK: - OnlyMediaChatCellSizeProvider

class MediaAndTextChatCellSizeProvider: SizeSource<MessageModel> {
    // Size Caches
    var sizeCaches: [MessageModel: CGFloat]! = [:]
    let cell = MediaAndTextChatCellView(viewModel: .init())

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
