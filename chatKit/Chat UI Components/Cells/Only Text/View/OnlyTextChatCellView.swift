//
//  OnlyTextChatCellView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Combine
import PinLayout
import UIKit

final class OnlyTextChatCellView: UIView {
    // MARK: - Views

    // Date Label
    var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textAlignment = .right
        $0.textColor = .white
        $0.lineBreakMode = .byTruncatingTail
        $0.text = ""
    }

    // Text Label
    var textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .left
        $0.textColor = .white
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.text = ""
    }

    // Container View
    var containerView = UIView().then {
        // Background Color
        $0.backgroundColor = .systemGreen
        // Corner Radius
        $0.cornerRadius = 10
        // Set clipToBounds To False, For Shadow
        $0.clipsToBounds = false
    }

    // MARK: - Variables

    // View Model
    var viewModel: OnlyTextChatCellViewModel!

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Container View Wrapping Inset
    var containerViewWrappingInset = PEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(viewModel: OnlyTextChatCellViewModel) {
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
        // Add Subviews
        addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(textLabel)
    }

    // MARK: - Bind Values

    func bindValues() {}

    // MARK: - Set Details Of Message Model

    func setDetails(model: MessageModel) {
        // Set View Model
        viewModel.cellModel = model
        // Set Text
        switch model.messageType {
        case let .onlyText(text: text):
            textLabel.text = text
        default: break
        }

        // Set Time String
        if let timeString = CDateFormatter.shared.formatToMessageStyle(timeInterval: model.creationDate) {
            dateLabel.text = timeString
        }

        switch model.owner {
        case .owner:
            textLabel.textAlignment = .left
            dateLabel.textAlignment = .right
            containerView.backgroundColor = .systemGreen
        case .opponent:
            textLabel.textAlignment = .left
            dateLabel.textAlignment = .left
            containerView.backgroundColor = .systemPink
        case .system:
            textLabel.textAlignment = .center
        }

        // Layout View
        layoutView()
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout
        layout()

        // Container View Corner Radius
        containerView.cornerRadiusWithShadow(cornerRadius: 12)
    }

    // MARK: - Layout

    func layout() {
        // Container View
        containerView.pin.top().width(65%)
        // Switch Over Owner Mode
        switch viewModel.cellModel.owner {
        // If Owner is My self
        case .owner:

            // Text Label
            textLabel.pin.top().horizontally().justify(.right).marginRight(7).sizeToFit(.widthFlexible)
            // Date Label
            dateLabel.pin.below(of: textLabel, aligned: .right).marginTop(5).sizeToFit(.content)
            // Container View Wrap Content
            containerView.pin.wrapContent(.all, padding: containerViewWrappingInset).right(10)

        case .opponent:

            // Text Label
            textLabel.pin.top().horizontally().justify(.right).marginRight(7).sizeToFit(.widthFlexible)
            // Date Label
            dateLabel.pin.below(of: textLabel).right().marginTop(5).sizeToFit()
            // Container View Wrap Content
            containerView.pin.wrapContent(.all, padding: containerViewWrappingInset).left(10)

        case .system:
            break
        }
    }

    // MARK: - Layout

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Calculated size
        autoSizeThatFits(size, layoutClosure: layout)
    }
}
