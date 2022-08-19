//
//  ChannelCellActionView.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Combine
import PinLayout
import UIKit

class ChannelCellActionView: UIView {
    // MARK: - Views

    /// Cell Icon Image
    lazy var cellIconImage = UIImageView().then { [weak self] in
        guard let self = self else { return }
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        var config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular), scale: .large)
        // On Desctructive Action Style
        if self.viewModel.actionStyle == .destructive {
            // If User Set Custom Icon For Desctructive Mode
            if let cellIcon = self.viewModel.cellIcon {
                $0.image = cellIcon.withConfiguration(config)
            } else {
                $0.image = UIImage(systemName: "trash")!.withConfiguration(config)
            }

            // Regular Action Style
        } else {
            if let cellIcon = self.viewModel.cellIcon {
                $0.image = cellIcon.withConfiguration(config)
            }
        }
    }

    // MARK: - Variables

    // View Model
    var viewModel: ChannelCellActionViewModel!

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

    convenience init(viewModel: ChannelCellActionViewModel) {
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
        addSubview(cellIconImage)

        // Background Color
        backgroundColor = viewModel.actionStyle == .destructive ? .systemRed.withAlphaComponent(0.8) : .brandMainBlue

        // Enable User Interaction
        isUserInteractionEnabled = true

        // Add Action
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    // MARK: - Bind Values

    func bindValues() {}

    // MARK: - View Tapped

    @objc func tapped() {
        // Execute Cell Action
        viewModel.action()
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
        // Cell Icon Image
        cellIconImage.pin.center().sizeToFit()
    }
}
