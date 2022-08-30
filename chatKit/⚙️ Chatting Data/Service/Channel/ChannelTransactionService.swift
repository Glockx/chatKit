//
//  ChannelTransactionService.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/30.
//

import CoreStore
import Foundation
import LoremSwiftum

class ChannelTransactionService {
    // MARK: - TransactionSource

    enum TransactionSource {
        case add
        case delete
        case edit
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
            let opponent = transaction.create(Into<ChannelOpponentModel>())
            // Set Username
            opponent.username = username
            opponent.profileImage = profileImage

            // Create Channel
            let channel = transaction.create(Into<ChannelModel>())
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
    func getAllChannels() -> [ChannelModel] {
        // Make Sure Channel Storage Has Set Successfully
        guard ChatService.shared.hasSetChatStorage else { return [] }

        do {
            let items = try dataStack.fetchAll(From<ChannelModel>().orderBy([.descending(\.$latestMessageDate), .descending(\.$createdAt)]))
            return items

        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    // MARK: - Delete Channel

    /// Delete The Channel With Given Channel ID
    /// - Parameter id: Channel ID
    func deleteChannel(id: String) {
        dataStack.perform(asynchronous: { transaction in
            // Delete Channel
            try transaction.deleteAll(From<ChannelModel>().where { $0.$id == id })
        }, sourceIdentifier: TransactionSource.delete) { result in

            switch result {
            case .success:
                print("Deleted \(id) successfully")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Update Channel Details

    func updateChannelDetils(model: ChannelModel) {
        dataStack.perform(asynchronous: { transaction in
            // Get Channel
            let channel = transaction.edit(model)
            // Update Latest Message
            channel?.latestMessage = Lorem.title
            channel?.latestMessageDate = Date().timeIntervalSince1970
            // Increase Unread Message Count
            channel?.unreadMessageCount += 1

        }, sourceIdentifier: TransactionSource.edit) { result in
            switch result {
            case .success:
                print("Edited \(model.id) successfully")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
