//
//  ChatMainViewController.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import UIKit

class ChatMainViewController: UIViewController {
    // MARK: - View

    // View
    var conentView: ChatMainView!

    // MARK: - Variables

    /// View Model
    var viewModel: ChatMainViewModel!

    // MARK: - Init

    init(viewModel: ChatMainViewModel) {
        super.init(nibName: nil, bundle: nil)

        // Set View Model
        self.viewModel = viewModel

        // Set Parent Controller
        self.viewModel.parentController = self

        // Init View
        conentView = ChatMainView(viewModel: self.viewModel)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set View
        view = conentView

        // Background
        view.backgroundColor = .white
    }

    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Prefer Large Titles
        navigationController?.navigationBar.prefersLargeTitles = false

        // Navigation Title
        title = "\(viewModel.chatChannelModel.opponentUser.username)"
    }

    // MARK: - Deinit

    deinit {
        viewModel = nil
    }
}
