//
//  UITextView + Extensions.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Combine
import Foundation
import UIKit

extension UITextView {
    // MARK: - Text Publisher

    /// Text Publisher
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextView)?.text }
        .eraseToAnyPublisher()
    }
}
