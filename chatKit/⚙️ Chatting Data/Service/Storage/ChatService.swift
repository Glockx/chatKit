//
//  ChatStorageService.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/29.
//

import Combine
import CoreStore
import Foundation

/// The general wrapper around the chat storage system.
class ChatService: NSObject {
    // MARK: - Typealias

    /// Current Channel Storage
    typealias ChannelStorage = ChatV1.ChannelStorageModel

    /// Current Owner Storage
    typealias OwnerStorage = ChatV1.ChannelOwnerStorageModel

    // MARK: - Variables

    /// Shared Instance Of Chat Storage Service
    static let shared = ChatService()

    // Channel TransactionService
    lazy var channelTransactionService = ChannelTransactionService(dataStack: dataStack)

    /// Has Chat Storage Setted
    @Published var hasSetChatStorage = false

    /// Chat Data Stack
    let dataStack = DataStack(CoreStoreSchema(
        modelVersion: "V1",
        entities: [
            Entity<ChannelStorage>("Chats"),
            Entity<OwnerStorage>("Opponents"),
        ]
    ), migrationChain: ["V1"])

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    override init() {
        super.init()

        // Create Chat Storage
        createChatStorage()
    }

    // MARK: - Bind Values

    /// Observe the file changes related to the storage file and object entities.
    func bindValues() {}

    // MARK: - Create Chat Storage

    /// Create Chat Storage And Migrate The New Version If Needed.
    func createChatStorage() {
        let _: Progress? = dataStack.addStorage(
            SQLiteStore(
                fileName: "Chat.sqlite",
                localStorageOptions: [.recreateStoreOnModelMismatch]
            ),
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(storage):
                    print("Successfully added sqlite store: \(storage)")
                    // Has Set Chat Storage
                    self.hasSetChatStorage = true
                    // Bind Values
                    self.bindValues()

                case let .failure(error):

                    // Has Set Chat Storage
                    self.hasSetChatStorage = false

                    print("Failed adding sqlite store with error: \(error)")
                }
            }
        )
    }
}
