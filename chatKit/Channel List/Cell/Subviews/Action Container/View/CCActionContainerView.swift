//
//  CCActionContainerView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Combine
import PinLayout
import UIKit

class CCActionContainerView: UIView {
    // MARK: - Views

    //  Stack View
    var stackView = PinStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .start
        $0.style = .auto
    }

    // MARK: - Variables

    // View Model
    var viewModel: CCActionContainerViewModel!

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

    convenience init(viewModel: CCActionContainerViewModel) {
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
        // Add Stack View Items
        for item in viewModel.actions ?? [] {
            // Add Item
            stackView.addItem(item).width(70).height(ratio: 1)
        }
        // Add Subviews
        addSubview(stackView)

        // Clip To Bound To Prevent Container Overlap with Cell View
        clipsToBounds = true
    }

    // MARK: - Bind Values

    func bindValues() {
        viewModel.$actions
            .dropFirst()
            .compactMap { $0 }
            .sink { [weak self] actions in
                guard let self = self else { return }

                // Clear Previous Items
                self.stackView.subviews.forEach { self.stackView.removeItem($0) }

                // Add Stack View Items
                for item in actions {
                    // Add Item
                    self.stackView.addItem(item).width(70).height(ratio: 1)
                }
            }.store(in: &cancellables)
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout View
        layout()
    }

    // MARK: - Layout

    func layout() {
        // Pin Stack View
        stackView.pin.top().height(100%).sizeToFit(.height)
    }

    // MARK: - Layout

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: layout)
    }
}
