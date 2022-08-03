//
//  CellSizeProvider.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import CollectionKit
import Foundation

protocol CellSizeProvider: UIView {
    associatedtype CellData
    static var sizeSourceProvider: SizeSource<CellData> { get }
}
