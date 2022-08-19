//
//  CLChannelCellView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/18.
//

import Combine
import Kingfisher
import PinLayout
import UIKit
class CLChannelCellView: UIView {
    // MARK: - Views

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

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(frame: .zero)

        // Configure View
        configureView()

        // Bind Values
        bindValues()
    }

    // MARK: - configureView

    func configureView() {
        // Add Subviews
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(messageCountLabel)
        addSubview(dateLabel)
        addSubview(lastMessageLabel)
        addSubview(bottomSeparator)
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
        if let messageDate = model.latestMessageDate, let timeString = CDateFormatter.shared.formatToMessageStyle(timeInterval: messageDate) {
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

    // MARK: - Bind Values

    func bindValues() {}

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout View
        layout()
    }

    // MARK: - Layout

    func layout() {
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
}
