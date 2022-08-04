//
//  OnlyEmojiChatCellView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/04.
//

import Combine
import PinLayout
import UIKit

final class OnlyEmojiChatCellView: UIView {
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
        $0.textAlignment = .center
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

    /// Container View Wrapping Inset
    var containerViewWrappingInset = PEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)

    // MARK: - Variables

    // View Model
    var viewModel: OnlyEmojiChatCellViewModel!

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

    convenience init(viewModel: OnlyEmojiChatCellViewModel) {
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

        switch model.messageType {
        case let .emoji(text: text):
            // Set Text
            textLabel.text = text

            // Set Emoji Count
            viewModel.emojiCount = text.count

            // Set Font Size According Count Of Emoji
            switch text.count {
            case 1:
                textLabel.font = .systemFont(ofSize: 35, weight: .regular)
            case 2:
                textLabel.font = .systemFont(ofSize: 32, weight: .regular)
            case 3:
                textLabel.font = .systemFont(ofSize: 29, weight: .regular)
            default:
                textLabel.font = .systemFont(ofSize: 14, weight: .regular)
            }
        default: break
        }

        // Set Time String
        if let timeString = CDateFormatter.shared.formatToMessageStyle(timeInterval: model.creationDate) {
            dateLabel.text = timeString
        }

        // Set Cell Style
        setStyle(owner: model.owner)

        // Layout View
        layoutView()
    }

    // MARK: - Set Style

    func setStyle(owner: MessageOwner) {
        switch owner {
        case .owner:
            // Date Label
            dateLabel.textAlignment = .right
            dateLabel.textColor = .white
            // Container View
            containerView.backgroundColor = .brandMainBlue
        case .opponent:
            // Date Label
            dateLabel.textAlignment = .left
            dateLabel.textColor = .chatDarkBlueText
            // Container View
            containerView.backgroundColor = .brandMainGray
        case .system:
            textLabel.textAlignment = .center
        }
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout
        layout()

        // Container View Corner Radius
        containerView.chatCorner(owner: viewModel.cellModel.owner)
    }

    // MARK: - Layout

    func layout() {
        // Container View
        containerView.pin.top().width(65%)
        // Switch Over Owner Mode
        switch viewModel.emojiCount {
        case 1:
            // Text Label
            textLabel.pin.top().horizontally().justify(.center).sizeToFit(.widthFlexible)
            // Date Label
            dateLabel.pin.below(of: textLabel).hCenter().marginTop(5).sizeToFit(.content)
        default:
            // Text Label
            textLabel.pin.top().horizontally().justify(.right).sizeToFit(.widthFlexible)
            // Date Label
            dateLabel.pin.below(of: textLabel).right().marginTop(5).sizeToFit(.content)
        }

        switch viewModel.cellModel.owner {
        // If Owner is My self
        case .owner:
            // Container View Wrap Content
            containerView.pin.wrapContent(.all, padding: containerViewWrappingInset).right(10)
        case .opponent:
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
