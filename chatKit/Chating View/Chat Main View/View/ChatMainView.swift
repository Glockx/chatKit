//
//  ChatMainView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import CollectionKit
import Combine
import PinLayout
import UIKit

class ChatMainView: UIView, UIScrollViewDelegate {
    // MARK: - Views

    // Collection View
    lazy var collectionView = CollectionView().then { [weak self] in
        guard let self = self else { return }
        $0.keyboardDismissMode = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnCollection))
        // Add Target To Collection View's Tap Gesture For Dismissing Keyboard.
        $0.tapGestureRecognizer.addTarget(self, action: #selector(tappedOnCollection))
        $0.delegate = self
    }

    // Text Field
    lazy var chatTextingBarView = ChatTextingBarView(viewModel: .init(chatMainModel: self.viewModel))

    // MARK: - Variables

    // View Model
    var viewModel: ChatMainViewModel!

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Keyboard Spacing
    var keyboardSpacing: CGFloat?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(viewModel: ChatMainViewModel) {
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
        // Collection View Data Source
        collectionView.provider = viewModel.collectionProvider
        // Add Subviews
        addSubview(collectionView)
        addSubview(chatTextingBarView)
    }

    // MARK: - Bind Values

    func bindValues() {
        // Keyboard Will Show
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo }
            .sink { [weak self] info in
                guard let self = self else { return }

                // Keyboard Will Show
                self.keyboardWillShow(info: info)

            }.store(in: &cancellables)

        // Keyboard Will Hide
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }

                // Keyboard Will Hide
                self.keyboardWillHide()

            }.store(in: &cancellables)
    }

    // MARK: - Keyboard Will Show

    func keyboardWillShow(info: [AnyHashable: Any]) {
        // Keyboard Frame
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        // Set Keyboard Spacing
        keyboardSpacing = (keyboardFrame.height)

        // Chat Text Field Keyboard Is Hidden State
        chatTextingBarView.viewModel.keyboardIsHidden = false

        // Layout
        layoutView(withAnimation: true, duration: 0.25)
    }

    // MARK: - Keyboard Will Hide

    func keyboardWillHide() {
        // Keyboard Spacing
        keyboardSpacing = nil

        // Chat Text Field Keyboard Is Hidden State
        chatTextingBarView.viewModel.keyboardIsHidden = true

        // Layout
        layoutView(withAnimation: true, duration: 0.25)
    }

    // MARK: - User Tapped On Collection

    @objc func tappedOnCollection() {
        print("tapped")
        endEditing(true)
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Chat Text Field Section
        if let keyboardSpacing = keyboardSpacing {
            chatTextingBarView.pin.bottom(keyboardSpacing).horizontally().sizeToFit(.width)
        } else {
            chatTextingBarView.pin.bottom().horizontally().sizeToFit(.width)
        }
        // Collection View
        collectionView.pin.top(pin.safeArea).horizontally(pin.safeArea).above(of: chatTextingBarView)
    }
}
