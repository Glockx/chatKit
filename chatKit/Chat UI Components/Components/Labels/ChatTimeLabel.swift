//
//  ChatTimeLabel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/05.
//

import Foundation
import UIKit

class ChatTimeLabel: UILabel {
    // MARK: - Views

    // MARK: - Variables

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
    }

    // MARK: - configureView

    func configureView() {
        font = .systemFont(ofSize: 10, weight: .regular)
        textAlignment = .right
        textColor = .white
        lineBreakMode = .byTruncatingTail
        text = ""
    }

    // MARK: - layoutSubviews

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
