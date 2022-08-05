//
//  ChatLayout.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/04.
//

import CollectionKit
import Foundation
import UIKit

class ChatMainLayout: SimpleLayout {
    // MARK: - Variables

    /// General Spacing Between "opponent" and "owner" cells
    var generalSpacing: CGFloat = 15

    /// Vertical Spacing Between Same Owner cells
    var sameCellSpacing: CGFloat = 3

    /// Only Text Chat Cell
    let onlyTextChatCellView = OnlyTextChatCellView(viewModel: .init())
    /// Only Emoji Chat Cell
    let onlyEmojiChatCellView = OnlyEmojiChatCellView(viewModel: .init())
    /// Only Media Chat Cell
    let onlyMediaChatCellView = OnlyMediaChatCellView(viewModel: .init())

    // MARK: - simpleLayout

    /// Layouting The Collection
    override func simpleLayout(context: LayoutContext) -> [CGRect] {
        // Cell Frames
        var frames: [CGRect] = []
        // Last Message
        var lastMessage: MessageModel?
        // Frame Of Last Message
        var lastFrame: CGRect?
        // Current Width Of The CollectionView
        let maxWidth: CGFloat = context.collectionSize.width

        // For each Item In
        for i in 0 ..< context.numberOfItems {
            // Make Sure Data Exists In The Data Source
            guard let currentMessage = context.data(at: i) as? MessageModel else { return frames }
            // The Current Y Height
            var yHeight: CGFloat = 0
            // The Frame Of The Current Cell
            var cellFrame = getCellFrame(model: currentMessage, collectionWidth: maxWidth)

            // Check If there any previous message cell and cell frame
            if let lastMessage = lastMessage, let lastFrame = lastFrame {
                // The Previous Cell's Owner Has Not Changed (John -> John -> John....)
                if lastMessage.owner == currentMessage.owner {
                    yHeight = lastFrame.maxY + sameCellSpacing
                    // The Previous Cell's Owner Is Not Changed (John -> Nijat -> John....)
                } else {
                    yHeight = lastFrame.maxY + generalSpacing
                }
            }

            // Set Current Cell frame Origin
            cellFrame.origin.y = yHeight

            // Set Last Frame
            lastFrame = cellFrame
            // Set Last Message
            lastMessage = currentMessage

            // Append Frame
            frames.append(cellFrame)
        }

        return frames
    }

    // MARK: - Get Cell Frame

    func getCellFrame(model: MessageModel, collectionWidth: CGFloat) -> CGRect {
        switch model.messageType {
        case .onlyText:
            // Set Cell Details
            onlyTextChatCellView.setDetails(model: model)
            // Get Cell Size
            let size = onlyTextChatCellView.sizeThatFits(.init(width: collectionWidth, height: .greatestFiniteMagnitude))
            // Crete New Frame From Cell Size
            let frame = CGRect(x: 0, y: 0, width: collectionWidth, height: size.height)
            // Return Frame
            return frame
        case .onlyMedia:
            // Set Cell Details
            onlyMediaChatCellView.setDetails(model: model)
            // Get Cell Size
            let size = onlyMediaChatCellView.sizeThatFits(.init(width: collectionWidth, height: .greatestFiniteMagnitude))
            // Crete New Frame From Cell Size
            let frame = CGRect(x: 0, y: 0, width: collectionWidth, height: size.height)
            // Return Frame
            return frame
        case .mediaAndText:
            return .null
        case .audio:
            return .null
        case .emoji:
            // Set Cell Details
            onlyEmojiChatCellView.setDetails(model: model)
            // Get Cell Size
            let size = onlyEmojiChatCellView.sizeThatFits(.init(width: collectionWidth, height: .greatestFiniteMagnitude))
            // Crete New Frame From Cell Size
            let frame = CGRect(x: 0, y: 0, width: collectionWidth, height: size.height)
            // Return Frame
            return frame
        }
    }
}
