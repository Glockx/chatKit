//
//  ChatMainViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import CollectionKit
import Combine
import Foundation
class ChatMainViewModel {
    // MARK: - CPI

    /// Collection View Provider
    var collectionProvider: BasicProvider<MessageModel, UIView>!

    /// Collection Main Data Source
    var collectionDataSource = ArrayDataSource(data: [MessageModel]()) { _, data in
        data.id
    }

    /// Provider Size Source
    lazy var collectionSizeSource = ComposedSizeSource<MessageModel>.init { data in
        switch data.messageType {
        case let .onlyText(text: text):
            return OnlyTextChatCellView.sizeSourceProvider
        case let .onlyMedia(media: media):
            return OnlyTextChatCellView.sizeSourceProvider
        case let .mediaAndText(text: text, media: media):
            return OnlyTextChatCellView.sizeSourceProvider
        case .audio:
            return OnlyTextChatCellView.sizeSourceProvider
        case let .emoji(text: text):
            return OnlyTextChatCellView.sizeSourceProvider
        }
    }

    /// Collection View Source
    lazy var collectionViewSource = ComposedViewSource<MessageModel>.init { data in
        switch data.messageType {
        case let .onlyText(text: text):
            return OnlyTextChatCellView.viewSourceprovider
        case let .onlyMedia(media: media):
            return OnlyTextChatCellView.viewSourceprovider
        case let .mediaAndText(text: text, media: media):
            return OnlyTextChatCellView.viewSourceprovider
        case .audio:
            return OnlyTextChatCellView.viewSourceprovider
        case let .emoji(text: text):
            return OnlyTextChatCellView.viewSourceprovider
        }
    }

    /// Collection Item Tap Handler
    lazy var tapHandler: BasicProvider<MessageModel, UIView>.TapHandler = { [weak self] _ in
        guard let self = self else { return }
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// The main data source of chat collection view.
    @Published var messageData = [MessageModel]()

    // MARK: - INIT

    init() {
        // Collection Provider
        collectionProvider = BasicProvider(dataSource: collectionDataSource, viewSource: collectionViewSource, sizeSource: collectionSizeSource, layout: FlowLayout(spacing: 5), tapHandler: tapHandler)
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {
        $messageData
            .removeDuplicates()
            .sink { [weak self] data in
                guard let self = self else { return }

                // Set Data
                self.collectionDataSource.data = data
                self.collectionProvider.reloadData()
            }.store(in: &cancellables)
    }

    // MARK: - Send Message

    func sendMessage(text: String) {
        let model = MessageModel(id: UUID().uuidString, owner: .owner(owner: .init(id: "7541", username: "nicat")), messageType: .onlyText(text: text), creationDate: Date().timeIntervalSince1970, updaetDate: nil)

        messageData.append(model)
    }
}
