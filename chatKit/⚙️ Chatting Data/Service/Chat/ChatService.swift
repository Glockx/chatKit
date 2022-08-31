//
//  ChatService.swift
//  chatKit
//
//  Created by spresto on 2022/08/31.
//

import Combine
import CoreStore
import Foundation

class ChatService: NSObject {
    // MARK: - Variables

    // Data Stack
    var dataStack: DataStack!

    // MARK: - Init

    init(dataStack: DataStack) {
        super.init()

        // Set Data Stack
        self.dataStack = dataStack
    }
}
