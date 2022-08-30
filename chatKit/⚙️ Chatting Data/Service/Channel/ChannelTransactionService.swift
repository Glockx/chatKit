//
//  ChannelTransactionService.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/30.
//

import CoreStore
import Foundation

class ChannelTransactionService {
    // MARK: - TransactionSource

    enum TransactionSource {
        case add
        case delete
        case shuffle
        case clear
        case refetch
    }

    // MARK: - Variables

    /// Chat Data Stack
    let dataStack: DataStack

    // MARK: - Init

    init(dataStack: DataStack) {
        // Set Data Stack
        self.dataStack = dataStack
    }

    // MARK: - Add Channel

    /// Add Channel To Chat Storage
    /// - Parameter username: String
    /// - Parameter profileImage: String
    func addChannel(username: String, profileImage: String? = nil) {
        // Make Sure Channel Storage Has Set Successfully
        guard ChatService.shared.hasSetChatStorage else { return }

        // Add Channel
        dataStack.perform(asynchronous: { transaction in

            // Create Opponent
            let opponent = transaction.create(Into<ChatV1.ChannelOwnerStorageModel>())
            // Set Username
            opponent.username = username
            opponent.profileImage = profileImage

            // Create Channel
            let channel = transaction.create(Into<ChatV1.ChannelStorageModel>())
            channel.opponentUser = opponent

        }, sourceIdentifier: TransactionSource.add) { result in
            // Transaction Result
            switch result {
            case .success:
                print("Successfully added the \(username)'s Channel")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Get All Channel Items

    /// Fetch All Chat Channel
    /// - Returns: Array of ChannelMainModel
    func getAllChannels() -> [ChatV1.ChannelStorageModel] {
        // Make Sure Channel Storage Has Set Successfully
        guard ChatService.shared.hasSetChatStorage else { return [] }

        do {
            let items = try dataStack.fetchAll(From<ChatV1.ChannelStorageModel>())
            return items

        } catch {
            print(error.localizedDescription)
            return []
        }

        return []
    }
}
