//
//  CLChannelCellView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/18.
//

import CollectionKit
import Combine
import Kingfisher
import PinLayout
import UIKit

class CLChannelCellView: UIView, CollectionViewReusableView {
    // MARK: - Views

    // Container View
    var containerView = UIView()

    // Right Action Container View
    var rightActionContainer = CCActionContainerView(viewModel: .init(actions: nil, alignment: .right))

    // Left Action Container View
    var leftActionContainer = CCActionContainerView(viewModel: .init(actions: nil, alignment: .left))

    /// Profile Image View
    var profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.kf.indicatorType = .activity
        $0.backgroundColor = .lightGray
    }

    // Username Label
    var usernameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "N/A"
    }

    // Message Count Label
    var messageCountLabel = PaddingLabel(inset: .init(top: 2, left: 4, bottom: 2, right: 4)).then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .brandMainBlue
        $0.textColor = .white
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "/"
    }

    // dateLabel
    var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .right
        $0.textColor = .darkGray
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "N/A"
    }

    // Last Message Label
    var lastMessageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textAlignment = .left
        $0.textColor = .lightGray
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 2
        $0.text = "N/A"
    }

    // Separator
    var bottomSeparator = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.4)
    }

    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // View Model
    var viewModel: CLChannelCellViewModel!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(viewModel: CLChannelCellViewModel) {
        self.init(frame: .zero)

        // Set View Model
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
        addSubview(leftActionContainer)
        addSubview(rightActionContainer)
        containerView.addSubview(profileImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(messageCountLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(lastMessageLabel)
        containerView.addSubview(bottomSeparator)

        // Append Swipe Gesture
        addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
        addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
    }

    // MARK: - Bind Values

    func bindValues() {
        // Delet Action Has Changed
        viewModel.$cellActionSwipePosition
            .receive(on: RunLoop.main)
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                // Layout View
                self.layoutView(withAnimation: true, duration: 0.2)
            }.store(in: &cancellables)

        // Set Right Actions
        viewModel.$rightCellActions
            .dropFirst()
            .sink { [weak self] actions in
                guard let self = self else { return }
                self.rightActionContainer.viewModel.actions = actions
            }.store(in: &cancellables)

        // Set Left Actions
        viewModel.$leftCellActions
            .dropFirst()
            .sink { [weak self] actions in
                guard let self = self else { return }
                self.leftActionContainer.viewModel.actions = actions
            }.store(in: &cancellables)
    }

    // MARK: - Configure Model

    /// Configure Details Of Cell With Given Channel Model
    /// - Parameter model: Channel Model
    func configureModel(model: ChannelMainModel) {
        // Set Profile Image
        if let imageString = model.opponentUser.profileImage, let imageURL = URL(string: imageString) {
            // Set Image
            profileImageView.kf.setImage(with: imageURL, options: [.processor(DownsamplingImageProcessor(size: .init(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage, .transition(.fade(0.3))], completionHandler: nil)
        } else {
            // Remove Profile Image
            profileImageView.image = nil
        }

        // Set Username
        usernameLabel.text = model.opponentUser.username

        // Set Latest Message Date
        if let messageDate = model.latestMessageDate, let timeString = CDateFormatter.shared.relativeFormatToMessageStyle(timeInterval: messageDate) {
            dateLabel.text = timeString
        }

        // Set Latest Message
        lastMessageLabel.text = model.latestMessage

        // Unread Message Count
        if model.unreadMessageCount == 0 {
            // Hide Message Count Label
            messageCountLabel.isHidden = true
            // Set Message Count Label To 0
            messageCountLabel.text = "0"
        } else {
            // Show Message Count Label
            messageCountLabel.isHidden = false
            // Set Message Count
            messageCountLabel.text = "\(model.unreadMessageCount)"
        }

        // Layout View
        layoutView()
    }

    // MARK: - Create Swipe Gesture Recognized

    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))

        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizer.direction = direction

        return swipeGestureRecognizer
    }

    // MARK: - swipped

    @objc func didSwipe(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .left:

            switch viewModel.cellActionSwipePosition {
            case .regular:
                viewModel.cellActionSwipePosition = .right
            case .left:
                viewModel.cellActionSwipePosition = .regular
            case .right:
                viewModel.cellActionSwipePosition = .regular
            }

        case .right:

            switch viewModel.cellActionSwipePosition {
            case .regular:
                viewModel.cellActionSwipePosition = .left
            case .left:
                viewModel.cellActionSwipePosition = .regular
            case .right:
                viewModel.cellActionSwipePosition = .regular
            }
        default:
            break
        }
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout View
        layout()
    }

    // MARK: - Layout

    func layout() {
        // Set Container According To Cell Action Swipe Position
        switch viewModel.cellActionSwipePosition {
        // Regular Position
        case .regular:
            // Container View
            containerView.pin.all()

            // Right Action Container View
            rightActionContainer.pin.height(100%).width(0%).right()

            // Left Action Container View
            leftActionContainer.pin.left().height(100%).width(0%)

        // Right Container Activated
        case .right:
            // Right Action Container View
            rightActionContainer.pin.right().height(100%).sizeToFit(.height)

            // Container View
            containerView.pin.before(of: rightActionContainer).height(100%).width(100%)

        // Left Container Activated
        case .left:
            // Left Action Container View
            leftActionContainer.pin.left().height(100%).sizeToFit(.height)

            // Container View
            containerView.pin.after(of: leftActionContainer).height(100%).width(100%)
        }

        // Profile Image View
        profileImageView.pin.centerLeft(20).size(55)
        profileImageView.cornerRadius = profileImageView.frame.height / 2
        // Message Count Label
        messageCountLabel.pin.right(20).top(to: profileImageView.edge.top).sizeToFit()
        messageCountLabel.cornerRadius = messageCountLabel.frame.height / 2
        // Date Label
        if messageCountLabel.isHidden {
            dateLabel.pin.right(20).top(to: profileImageView.edge.top).sizeToFit()
        } else {
            dateLabel.pin.below(of: messageCountLabel, aligned: .right).marginTop(10).sizeToFit()
        }

        // Username Label
        usernameLabel.pin.after(of: profileImageView, aligned: .top).marginLeft(10).right(to: dateLabel.edge.left).marginRight(5).sizeToFit(.width)
        // Last Message Label
        lastMessageLabel.pin.below(of: usernameLabel, aligned: .left).marginTop(3).right(to: dateLabel.edge.left).marginRight(5).sizeToFit(.width)
        // Bottom Separator
        bottomSeparator.pin.bottom().horizontally().height(0.5)
    }

    // MARK: - Layout

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        autoSizeThatFits(size, layoutClosure: layout)
    }

    // MARK: - prepareForReuse

    func prepareForReuse() {
        /// Restore Swipe Action
        viewModel.cellActionSwipePosition = .regular
        /// Remove Right Actions
        viewModel.rightCellActions = []
        /// Remove Left Action
        viewModel.leftCellActions = []
    }
}
