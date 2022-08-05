//
//  MediaAndTextChatCellView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/05.
//

import Combine
import PinLayout
import UIKit

final class MediaAndTextChatCellView: UIView {
    // MARK: - Views

    // Time Label
    var timeLabel = ChatTimeLabel()

    // Image View
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.kf.indicatorType = .activity
        $0.cornerRadius = 7
        $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
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
    lazy var containerView = UIView().then { [weak self] in
        guard let self = self else { return }
        // Background Color
        $0.backgroundColor = .brandMainBlue
        // Set clipToBounds To False, For Shadow
        $0.clipsToBounds = false
        // Add Context Menu To Cell
        $0.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: viewModel)
        $0.addInteraction(interaction)
    }

    // Play Button
    var playButton = UIButton().then {
        $0.tintColor = .white
        var config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular), scale: .large)
        var image = UIImage(systemName: "play.circle", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = .init(width: 0, height: 2)
        $0.layer.shadowRadius = 5
        $0.layer.shadowOpacity = 0.5
    }

    // MARK: - Variables

    // View Model
    var viewModel: MediaAndTextChatCellViewModel!

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    /// Container View Wrapping Inset
    var containerViewWrappingInset = PEdgeInsets(top: 5, left: 5, bottom: 6, right: 5)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(viewModel: MediaAndTextChatCellViewModel) {
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
        containerView.addSubview(imageView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(textLabel)
        containerView.addSubview(playButton)
    }

    // MARK: - Bind Values

    func bindValues() {}

    // MARK: - Set Details Of Message Model

    func setDetails(model: MessageModel) {
        // Set View Model
        viewModel.cellModel = model

        // Set Text
        switch model.messageType {
        case let .mediaAndText(text: text, media: mediaItem):
            // Set Media Item
            viewModel.mediaItem = mediaItem
            // Get Thumbnail Image
            if let imageURL = mediaItem.thumbnailURL {
                // Set Image
                imageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))], completionHandler: nil)
            }

            // Set Text
            textLabel.text = text

            // Check Media Type and Set Play Button State
            if mediaItem.mediaType == .image {
                // Hide Play Button
                playButton.isHidden = true
            } else {
                playButton.isHidden = false
            }

        default: break
        }

        // Set Time String
        if let timeString = CDateFormatter.shared.formatToMessageStyle(timeInterval: model.creationDate) {
            timeLabel.text = timeString
        }

        // Set Cell Style
        setCellStyle(owner: model.owner)

        // Layout View
        layoutView()
    }

    // MARK: - Set Cell Style

    /// Set Cell Style
    func setCellStyle(owner: MessageOwner) {
        switch owner {
        case .opponent:
            // Text Label
            textLabel.textAlignment = .left
            textLabel.textColor = .chatDarkBlueText
            // Time Label
            timeLabel.textAlignment = .left
            timeLabel.textColor = .chatDarkBlueText
            // Container View
            containerView.backgroundColor = .brandMainGray
        case .owner:
            // Text Label
            textLabel.textAlignment = .right
            textLabel.textColor = .white
            // Time Label
            timeLabel.textAlignment = .right
            timeLabel.textColor = .white
            // Container View
            containerView.backgroundColor = .brandMainBlue
        case .system:
            break
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
        switch viewModel.cellModel.owner {
        // If Owner is My self
        case .owner:

            // Image View
            imageView.pin.top().horizontally().justify(.right).height(viewModel.mediaItem.size.height).maxHeight(150).width(viewModel.mediaItem.size.width).maxWidth(65%)
            // Play Button
            playButton.pin.center(to: imageView.anchor.center).sizeToFit()
            // Text Label
            textLabel.pin.below(of: imageView, aligned: .center).marginTop(5).width(of: imageView).sizeToFit(.width)
            // Date Label
            timeLabel.pin.below(of: textLabel, aligned: .right).marginTop(5).sizeToFit(.content)
            // Container View Wrap Content
            containerView.pin.wrapContent(.all, padding: containerViewWrappingInset).right(10)

        case .opponent:

            // Image View
            imageView.pin.top().horizontally().justify(.right).height(viewModel.mediaItem.size.height).maxHeight(150).width(viewModel.mediaItem.size.width).maxWidth(65%)
            // Play Button
            playButton.pin.center(to: imageView.anchor.center).sizeToFit()
            // Text Label
            textLabel.pin.below(of: imageView, aligned: .center).marginTop(5).width(of: imageView).sizeToFit(.width)
            // Time Label
            timeLabel.pin.below(of: textLabel).right().marginTop(5).sizeToFit()
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
