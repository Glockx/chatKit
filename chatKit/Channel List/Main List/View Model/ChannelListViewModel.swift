//
//  ChannelListViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/18.
//

import CollectionKit
import Combine
import CoreStore
import Foundation
import LoremSwiftum

class ChannelListViewModel {
    // MARK: - CPI

    // Collection Provider
    var collectionProvider: BasicProvider<ChannelModel, CLChannelCellView>!

    // Collection Main Data Source
    var collectionDataSource = ArrayDataSource(data: [ChannelModel]()) { _, data in
        data.id
    }

    // Provider Size Source
    var collectionSizeSource = { (_: Int, _: ChannelModel, collectionSize: CGSize) -> CGSize in
        .init(width: collectionSize.width, height: 70)
    }

    // Collection View Source
    lazy var collectionViewSource = ClosureViewSource(viewGenerator: { _, _ -> CLChannelCellView in
        CLChannelCellView(viewModel: .init())
    }, viewUpdater: { [weak self] (cell: CLChannelCellView, model: ChannelModel, _: Int) in

        // Configure Model
        cell.configureModel(model: model)
        
        // Add Delete Action
        var deleteAction = ChannelCellActionView(viewModel: .init(actionStyle: .destructive, action: {
            // Delete Item
            ChatService.shared.channelTransactionService.deleteChannel(id: model.id)
        }))

        cell.addSwipeAction(alignment: .right, action: deleteAction)

        // Add Example Action
        var exampleAction = ChannelCellActionView(viewModel: .init(actionStyle: .regular, cellIcon: .init(systemName: "ellipsis"), action: {
            print("more")
        }))
        cell.addSwipeAction(alignment: .left, action: exampleAction)

    })

    // Collection Item Tap Handler
    lazy var tapHandler: BasicProvider<ChannelModel, CLChannelCellView>.TapHandler = { [weak self] context in
        guard let self = self else { return }

        // Update Model
        ChatService.shared.channelTransactionService.updateChannelDetils(model: context.data)

        // Push To Chat Controller
        // self.pushToChatContoller(model: context.data)
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Parent Controller
    weak var parentController: ChannelListViewController!

    /// Channels
    @Published var channels = [ChannelModel]()

    // Channel List Observer
    var channelListObserve: ListPublisher<ChannelModel>!

    // MARK: - INIT

    init() {
        // Init Provider
        collectionProvider = BasicProvider(dataSource: collectionDataSource, viewSource: collectionViewSource, sizeSource: collectionSizeSource, layout: FlowLayout(spacing: 5).inset(by: .init(top: 10, left: 0, bottom: 10, right: 0)), animator: FadeAnimator(), tapHandler: tapHandler)

        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {
        // Set Channels To Collection Data Source
        $channels
            .dropFirst()
            .sink { [weak self] channels in
                guard let self = self else { return }
                // Set Data
                self.collectionDataSource.data = channels
                // Reload Provider
                self.collectionProvider.reloadData()
            }.store(in: &cancellables)

        // Set All Channels List For First Time
        ChatService.shared.$hasSetChatStorage
            .filter { $0 == true }
            .delay(for: 0.01, scheduler: RunLoop.current)
            .first()
            .sink { [weak self] _ in
                guard let self = self else { return }
                // Get All Chat Items
                self.collectionDataSource.data = ChatService.shared.channelTransactionService.getAllChannels()

                // Start Channel Observe
                self.startChannelObserve()
            }.store(in: &cancellables)
    }

    // MARK: - startChannelObserve

    /// Start Channel Listening After Chat Storage System Starting
    func startChannelObserve() {
        // Channel List Observer and order them by latestMessageDate and Created Time
        channelListObserve = ChatService.shared.dataStack.publishList(From<ChannelModel>().orderBy([.descending(\.$latestMessageDate), .descending(\.$createdAt)]))

        // Add Observer
        channelListObserve.addObserver(self, notifyInitial: false) { publisher in
            // Set Channels
            self.channels = publisher.snapshot.compactMap { $0.object }
        }
    }

    // MARK: - Navigation Bar Add Button Clicked

    /// Navigation Bar Add Button Clicked
    @objc func addButtonClicked() {
        // Add New Chatting Channel To Storage
        ChatService.shared.channelTransactionService.addChannel(username: Lorem.firstName)
    }

    // MARK: - Push To Chat Controller

    func pushToChatContoller(model: ChannelModel) {
        let vc = ChatMainViewController(viewModel: .init(chatChannelModel: model))
        parentController.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Deinit

    deinit {
        // Remove Channel List Observer
        channelListObserve.removeObserver(self)
    }
}
