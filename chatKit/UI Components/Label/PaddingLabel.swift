//
//  PaddingLabel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/19.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    // MARK: - Views

    // MARK: - Variables

    var topInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var rightInset: CGFloat = 0

    // MARK: - Init

    convenience init(inset: UIEdgeInsets) {
        self.init(frame: .zero)

        // Set Inset
        topInset = inset.top
        bottomInset = inset.bottom
        leftInset = inset.left
        rightInset = inset.right
    }

    // MARK: - drawText

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    // MARK: - intrinsicContentSize

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    // MARK: - bounds

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }

    // MARK: - sizeThatFits

    override func sizeThatFits(_: CGSize) -> CGSize {
        let size = intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
