//
//  ChannelListView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/18.
//

import CollectionKit
import Combine
import PinLayout
import UIKit

class ChannelListView: UIView {
    // MARK: - Views

    // Collection View
    var collectionView = CollectionView()

    // MARK: - Variables

    // View Model
    var viewModel: ChannelListViewModel!

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(viewModel: ChannelListViewModel) {
        self.init(frame: .zero)

        // Set Model
        self.viewModel = viewModel

        // Configure View
        configureView()

        // Bind Values
        bindValues()
    }

    // MARK: - configureView

    func configureView() {
        // Collection View Provider
        collectionView.provider = viewModel.collectionProvider
        // Add Subviews
        addSubview(collectionView)
    }

    // MARK: - Bind Values

    func bindValues() {}

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Collection View
        collectionView.pin.top().horizontally().bottom()
    }

    // MARK: - safeAreaInsetsDidChange

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        // Layout View When Safe Area Inset Changes
        layoutView()
    }
}
