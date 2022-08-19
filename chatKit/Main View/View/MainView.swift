//
//  MainView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import Combine
import PinLayout
import UIKit

class MainView: UIView {
    // MARK: - Views

    // Chat View
    var chatMainView = ChatMainView(viewModel: .init(chatChannelModel: .init()))

    // MARK: - Variables

    // View Model
    var viewModel: MainViewModel!

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

    convenience init(viewModel: MainViewModel) {
        self.init(frame: .zero)

        // Set Model
        self.viewModel = viewModel

        // Set Chat Main View Parent Controller
        chatMainView.viewModel.parentController = self.viewModel.parentController

        // Configure View
        configureView()

        // Bind Values
        bindValues()
    }

    // MARK: - configureView

    func configureView() {
        // Add Subviews
        addSubview(chatMainView)
    }

    // MARK: - Bind Values

    func bindValues() {}

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        chatMainView.pin.all()
    }
}
