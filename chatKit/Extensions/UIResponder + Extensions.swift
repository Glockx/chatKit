//
//  UIResponder.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation
import UIKit

extension UIResponder {
    // MARK: - Parent Controller of responder with given generic UIViewController type

    func parentController<T: UIViewController>(of type: T.Type) -> T? {
        guard let next = self.next else {
            return nil
        }
        return (next as? T) ?? next.parentController(of: T.self)
    }
}
