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

    // Provider
    var collectionProvider: BasicProvider<ChannelMainModel, CLChannelCellView>!

    // Collection Main Data Source
    var collectionDataSource = ArrayDataSource(data: [ChannelMainModel]()) { _, data in
        data.id
    }

    // Provider Size Source
    var collectionSizeSource = { (_: Int, _: ChannelMainModel, collectionSize: CGSize) -> CGSize in
        .init(width: collectionSize.width, height: 70)
    }

    // Collection View Source
    lazy var collectionViewSource = ClosureViewSource(viewGenerator: { _, _ -> CLChannelCellView in
        CLChannelCellView(viewModel: .init())
    }, viewUpdater: { [weak self] (cell: CLChannelCellView, model: ChannelMainModel, _: Int) in

        // Add Delete Action
        var deleteAction = ChannelCellActionView(viewModel: .init(actionStyle: .destructive, action: {
            print("Hello")
        }))

        cell.addSwipeAction(alignment: .right, action: deleteAction)

        // Add Example Action
        var exampleAction = ChannelCellActionView(viewModel: .init(actionStyle: .regular, cellIcon: .init(systemName: "ellipsis"), action: {
            print("more")
        }))
        cell.addSwipeAction(alignment: .left, action: exampleAction)

        // Configure Model
        cell.configureModel(model: model)
    })

    // Collection Item Tap Handler
    lazy var tapHandler: BasicProvider<ChannelMainModel, CLChannelCellView>.TapHandler = { [weak self] context in
        guard let self = self else { return }

        // Push To Chat Controller
        self.pushToChatContoller(model: context.data)
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Parent Controller
    weak var parentController: ChannelListViewController!

    /// Channels
    @Published var channels = [ChannelMainModel]()

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
    }

    // MARK: - Navigation Bar Add Button Clicked

    /// Navigation Bar Add Button Clicked
    @objc func addButtonClicked() {
        print("clicked")

        ChatStorageService.shared.channelTransactionService.addChannel(username: Lorem.firstName)
    }

    // MARK: - Push To Chat Controller

    func pushToChatContoller(model: ChannelMainModel) {
        let vc = ChatMainViewController(viewModel: .init(chatChannelModel: model))
        parentController.navigationController?.pushViewController(vc, animated: true)
    }
}
