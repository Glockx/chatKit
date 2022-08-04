//
//  CellViewProvider.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import CollectionKit
import Foundation
import UIKit

protocol CellViewProvider: UIView {
    static var viewSourceProvider: ViewSource<MessageModel, Self> { get }
}
