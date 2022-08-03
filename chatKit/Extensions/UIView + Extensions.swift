//
//  UIView + Extensions.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Border Color

    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue!.cgColor
        }
    }

    // MARK: - Border Width

    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    // MARK: - Corner Radius

    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
    }

    // MARK: - Apply Border And Corner Radius

    func applyCIBorderAndCornerRadius(cornerRadius: CGFloat = 10, borderWidth: CGFloat = 1, borderColor: UIColor = .init(hex: 0xF1F1F1)) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }

    // MARK: - Layout View

    /// Layout subviews with or without animation
    func layoutView(withAnimation: Bool = false, duration: TimeInterval = 0.3) {
        if withAnimation {
            UIView.animate(withDuration: duration) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        } else {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    // MARK: - Get Parent Controller Of UIView

    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
