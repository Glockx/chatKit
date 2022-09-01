//
//  ChatService.swift
//  chatKit
//
//  Created by spresto on 2022/08/31.
//

import Combine
import CoreStore
import Foundation

class ChatService: NSObject {
    // MARK: - Enum

    /// Transactions
    enum TransactionSource {
        case add
        case delete
        case edit
    }

    // MARK: - Variables

    // Data Stack
    var dataStack: DataStack!

    // MARK: - Init

    init(dataStack: DataStack) {
        super.init()

        // Set Data Stack
        self.dataStack = dataStack
    }

    // MARK: - Add Message Type

    func addMessageToStorage(channel: ChannelModel, owner: MessageOwner, messageType: MessageContentType) {
        dataStack.perform(asynchronous: { transaction in
            // Create Message Model
            let message = transaction.create(Into<ChatV1.MessageStorageModel>())
            message.owner = owner
            message.messageType = messageType
            message.channel = channel

        }, sourceIdentifier: TransactionSource.add) { result in
            switch result {
            case .success:
                print("Message Has Added To Channel")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
