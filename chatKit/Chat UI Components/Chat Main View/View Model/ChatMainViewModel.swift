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
        "\(data.hashValue)"
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
        collectionProvider = BasicProvider(dataSource: collectionDataSource, viewSource: collectionViewSource, sizeSource: collectionSizeSource, layout: FlowLayout(spacing: 5).inset(by: .init(top: 10, left: 0, bottom: 10, right: 0)), tapHandler: tapHandler)
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
                // Scroll To Bottom After Adding Message
                self.collectionProvider.collectionView?.scrollTo(edge: .bottom, animated: true)
            }.store(in: &cancellables)
    }

    // MARK: - Send Message

    func sendMessage(text: String) {
        let model = MessageModel(id: UUID().uuidString, owner: .owner(owner: .init(id: "7541", username: "nicat")), messageType: .onlyText(text: text), creationDate: Date().timeIntervalSince1970, updaetDate: nil)

        // Add My Message
        messageData.append(model)

        // Add Opponent
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            var item = model
            item.messageType = .onlyText(text: UUID().uuidString)
            item.owner = .opponent(owner: .init(id: "854", username: "frog"))
            self.messageData.append(item)
        }
    }
}
