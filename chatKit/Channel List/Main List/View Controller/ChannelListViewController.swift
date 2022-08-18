//
//  ChannelListViewController.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/18.
//

import UIKit

class ChannelListViewController: UIViewController {
    // MARK: - View

    // View
    var contentView: ChannelListView!

    // MARK: - Variables

    // View Model
    var viewModel: ChannelListViewModel!

    // MARK: - Init

    init(viewModel: ChannelListViewModel) {
        super.init(nibName: nil, bundle: nil)

        // Set Parent Controller
        viewModel.parentController = self

        // Set View Model
        self.viewModel = viewModel

        // Init View
        contentView = ChannelListView(viewModel: self.viewModel)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set View
        view = contentView

        // Background
        view.backgroundColor = .white

        navigationController?.navigationBar.prefersLargeTitles = true

        // Navigation Bar background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.brandMainBlue

        // setup title font color
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = titleAttribute
        appearance.largeTitleTextAttributes = titleAttribute

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "Chats"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Deinit

    deinit {
        viewModel = nil
    }
}
