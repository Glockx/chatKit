//
//  ChatTextingBarView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import Combine
import PinLayout
import Then
import UIKit

class ChatTextingBarView: UIView, UITextViewDelegate {
    // MARK: - Views

    // Add Button
    lazy var addButton = UIButton().then { [weak self] in
        guard let self = self else { return }
        $0.tintColor = .brandMainBlue
        var config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular), scale: .large)
        var image = UIImage(systemName: "plus", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.isUserInteractionEnabled = true
        $0.showsMenuAsPrimaryAction = true
        $0.menu = self.viewModel.mediaMenu
    }

    // Send Button
    var sendButton = UIButton().then {
        $0.tintColor = .brandMainBlue
        var config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22, weight: .regular), scale: .large)
        var image = UIImage(systemName: "paperplane.circle.fill", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.isEnabled = false
        $0.isUserInteractionEnabled = true
    }

    // Text Field
    lazy var textView = UITextView().then { [weak self] in
        guard let self = self else { return }
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .init(hex: 0x171717)
        $0.applyCIBorderAndCornerRadius(cornerRadius: 15, borderWidth: 1, borderColor: .lightGray)
        $0.clipsToBounds = true
        $0.textContainerInset = .init(top: 10, left: 5, bottom: 10, right: 5)
        $0.autocapitalizationType = .none
        $0.delegate = self
    }

    // Separator
    var topSeparator = UIView().then {
        $0.backgroundColor = .lightGray
    }

    // MARK: - Variables

    // View Model
    var viewModel: ChatTextingBarViewModel!

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

    convenience init(viewModel: ChatTextingBarViewModel) {
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
        backgroundColor = .secondarySystemBackground
        // Add Subviews
        addSubview(topSeparator)
        addSubview(addButton)
        addSubview(sendButton)
        addSubview(textView)

        // Send Button Target
        sendButton.addTarget(self, action: #selector(sendMessage), for: .primaryActionTriggered)
    }

    // MARK: - Bind Values

    func bindValues() {
        // Text View Text Publisher
        textView.textPublisher
            .receive(on: RunLoop.main)
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                // Check If Text Is Empty
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    // Disable Send Button
                    self.sendButton.isEnabled = false
                } else {
                    // Enable Send Button
                    self.sendButton.isEnabled = true
                }

                // Set Text View Height
                var textViewHeight = self.textView.sizeThatFits(.init(width: self.textView.frame.width, height: .greatestFiniteMagnitude)).height

                // If Text View Height Smaller Than Default Text View Height, Enlarge it.
                if textViewHeight <= self.viewModel.defaultTextviewHeight {
                    textViewHeight = self.viewModel.defaultTextviewHeight
                }

                // Set Text View Height
                self.viewModel.textViewHeight = min(self.viewModel.maxTextViewHeight, textViewHeight)

            }.store(in: &cancellables)

        // Observe The Text View Height
        viewModel.$textViewHeight
            .receive(on: RunLoop.main)
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                // Layout Self
                self.layoutView(withAnimation: true, duration: 0.2)
                // Layout Parent View
                self.superview?.layoutView(withAnimation: true, duration: 0.2)
            }.store(in: &cancellables)
    }

    // MARK: - Send Message

    @objc func sendMessage() {
        // MARK: - Emoji Only

        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).containsOnlyEmoji {
            // Send A Simple Text Message
            //    viewModel.chatMainModel.sendMessage(text: textView.text.trimmingCharacters(in: .whitespacesAndNewlines), textType: .onlyEmoji)
        } else {
            // MARK: - Text Only

            // Send A Simple Text Message
            //  viewModel.chatMainModel.sendMessage(text: textView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        // Clear Text
        textView.text.removeAll()
        // Disable Send Button
        sendButton.isEnabled = false
        // Restore Text View Size
        viewModel.textViewHeight = viewModel.defaultTextviewHeight
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout
        layout()
        // Text View Corner Radius
        if textView.frame.height == viewModel.defaultTextviewHeight {
            textView.applyCIBorderAndCornerRadius(cornerRadius: viewModel.textViewHeight / 2, borderWidth: 1, borderColor: .lightGray)
        } else {
            textView.applyCIBorderAndCornerRadius(cornerRadius: 15, borderWidth: 1, borderColor: .lightGray)
        }
    }

    // MARK: - Layout

    func layout() {
        // Top Separator
        topSeparator.pin.top().height(0.5).horizontally()
        // Text View
        if viewModel.keyboardIsHidden {
            // When Keyboard On Screen
            textView.pin.top(8).height(viewModel.textViewHeight).width(75%).hCenter().marginBottom(viewModel.keyboardIsHidden ? (10 + (superview?.safeAreaInsets.bottom ?? 0)) : 10)
        } else {
            // When Keyboard Is Dismissed
            textView.pin.top(8).height(viewModel.textViewHeight).width(75%).hCenter().marginBottom(10)
        }
        // Add Button
        addButton.pin.before(of: textView, aligned: .bottom).marginBottom(viewModel.textViewHeight == viewModel.defaultTextviewHeight ? 5 : 0).marginRight(10).sizeToFit()
        // Send Button
        sendButton.pin.after(of: textView, aligned: .bottom).marginBottom(viewModel.textViewHeight == viewModel.defaultTextviewHeight ? 1 : 0).marginLeft(10).sizeToFit()
    }

    // MARK: - Layout

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return autoSizeThatFits(size, layoutClosure: layout)
    }
}
