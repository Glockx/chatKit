//
//  MainViewController.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - View

    // View
    var contentView: MainView!

    // MARK: - Variables

    // View Model
    var viewModel: MainViewModel!

    // MARK: - Init

    init(viewModel: MainViewModel) {
        super.init(nibName: nil, bundle: nil)

        // Set Parent Controller
        viewModel.parentController = self

        // Set View Model
        self.viewModel = viewModel

        // Init View
        contentView = MainView(viewModel: self.viewModel)
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }

    @objc func handleTap() {
        print("tap")
        // Dismiss keyoard
        view.endEditing(true)
    }
    
    // MARK: - Deinit

    deinit {
        viewModel = nil
    }
}
