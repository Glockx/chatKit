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
        case .onlyText:
            return OnlyTextChatCellView.sizeSourceProvider
        case .onlyMedia:
            return OnlyMediaChatCellView.sizeSourceProvider
        case .mediaAndText:
            return OnlyTextChatCellView.sizeSourceProvider
        case .audio:
            return OnlyTextChatCellView.sizeSourceProvider
        case .emoji:
            return OnlyEmojiChatCellView.sizeSourceProvider
        }
    }

    /// Collection View Source
    lazy var collectionViewSource = ComposedViewSource<MessageModel>.init { data in
        switch data.messageType {
        case .onlyText:
            return OnlyTextChatCellView.viewSourceProvider
        case .onlyMedia:
            return OnlyMediaChatCellView.viewSourceProvider
        case .mediaAndText:
            return OnlyTextChatCellView.viewSourceProvider
        case .audio:
            return OnlyTextChatCellView.viewSourceProvider
        case .emoji:
            return OnlyEmojiChatCellView.viewSourceProvider
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

    /// Parent Controller Of View Model
    weak var parentController: UIViewController!

    // MARK: - INIT

    init() {
        // Collection Provider
        collectionProvider = BasicProvider(dataSource: collectionDataSource, viewSource: collectionViewSource, sizeSource: collectionSizeSource, layout: ChatMainLayout().insetVisibleFrame(by: .init(top: -250, left: 0, bottom: -250, right: 0)).inset(by: .init(top: 10, left: 0, bottom: 10, right: 0)), animator: ScaleAnimator(), tapHandler: tapHandler)
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

    func sendMessage(text: String, textType: TextStringType = .text) {
        // Init Mocking Model
        let model = MessageModel(id: UUID().uuidString, owner: .owner(owner: .init(id: "7541", username: "nicat")), messageType: textType == .text ?.onlyText(text: text) : .emoji(text: text), creationDate: Date().timeIntervalSince1970, updaetDate: nil)

        // Add My Message
        messageData.append(model)

        // Add Opponent
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            var item = model
            item.messageType = textType == .onlyEmoji ? .emoji(text: String(UnicodeScalar(Array(0x1F300 ... 0x1F3F0).randomElement()!)!)) : .onlyText(text: UUID().uuidString)
            item.owner = .opponent(owner: .init(id: "854", username: "frog"))
            self.messageData.append(item)
        }
    }

    // MARK: - Add Photo Item

    /// Add Random Photo
    func sendMediaItem() {
        // Item Seed
        let itemSeed = UUID().uuidString

        // Asset Size
        let assetSize = CGSize(width: .random(in: 100 ... 1000), height: .random(in: 100 ... 1000))

        // Create Media Asset
        let mediaAsset = MediaItem(mediaType: .image, mediaURL: .init(string: "https://picsum.photos/seed/\(itemSeed)/\(assetSize.width)/\(assetSize.height)"), thumbnailURL: .init(string: .init("https://picsum.photos/seed/\(itemSeed)/1000/1000")), size: assetSize)

        // Create Message Model
        let messageModel = MessageModel(id: UUID().uuidString, owner: .owner(owner: .init(id: "7541", username: "nicat")), messageType: .onlyMedia(media: mediaAsset), creationDate: Date().timeIntervalSince1970, updaetDate: nil)

        // Add Item To Data Source
        messageData.append(messageModel)
        
        // Send Mock Answer
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            var item = messageModel
            item.owner = .opponent(owner: .init(id: "854", username: "frog"))
            self.messageData.append(item)
        }
    }
}
