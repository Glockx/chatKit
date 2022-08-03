//
//  ComposedSizeSource.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import CollectionKit
import Foundation

public class ComposedSizeSource<Data>: SizeSource<Data> {
    public var viewSizeSourceSelector: (Data) -> SizeSource<Data>

    public init(sizeSourceSelector: @escaping (Data) -> SizeSource<Data>) {
        viewSizeSourceSelector = sizeSourceSelector
    }

    override public func size(at index: Int, data: Data, collectionSize: CGSize) -> CGSize {
        viewSizeSourceSelector(data).size(at: index, data: data, collectionSize: collectionSize)
    }
}
