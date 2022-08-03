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
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .right
        $0.textColor = .white
        $0.lineBreakMode = .byTruncatingTail
        $0.text = ""
    }

    // Text Label
    var textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .right
        $0.textColor = .white
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 0
        $0.text = ""
    }

    // MARK: - Variables

    // View Model
    var viewModel: OnlyTextChatCellViewModel!

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
        // Background Color
        backgroundColor = .systemGreen
        // Corner Radius
        cornerRadius = 5
        // Add Subviews
        addSubview(dateLabel)
        addSubview(textLabel)
    }

    // MARK: - Bind Values

    func bindValues() {
        viewModel.$cellModel
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // Set Details
                    self.setDetails(model: model)
                }
            }.store(in: &cancellables)
    }

    // MARK: - Set Details

    func setDetails(model: MessageModel) {
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

        // Layout View
        layoutView()
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout
        layout()
    }

    // MARK: - Layout

    func layout() {
        // Text Label
        textLabel.pin.top(5).width(60%).sizeToFit(.width)
        // Date Label
        dateLabel.pin.below(of: textLabel).right(5).sizeToFit(.content)
    }

    // MARK: - Layout

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = autoSizeThatFits(size, layoutClosure: layout)
        print(size)
        return size
    }
}
