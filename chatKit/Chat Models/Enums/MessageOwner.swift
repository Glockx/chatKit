//
//  MessageOwner.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import CoreStore
import Foundation

/// Message Owner can be used during UI Layouting and Message Component Management.
/// Current Types Are:
/// 1. opponent - The message is belongs to the opponent user. Layout alignment: Left
/// 2. owner  - The message is belongs to the logged in user. Layout alignment: Right
/// 3. system - The message is belongs to the system. Layout alignment: Center
enum MessageOwner: Equatable, Hashable {
    /// The message is belongs to the opponent use
    case opponent(owner: ChannelOpponentModel)

    /// The message is belongs to the logged in user.
    case owner(owner: ChannelOpponentModel)

    /// The message is belongs to the system
    case system

    init(_ object: ObjectProxy<ChatV1.MessageStorageModel>) {
        switch object.$owner.primitiveValue {
        case let .opponent(owner: owner):
            self = .opponent(owner: owner)
        case let .owner(owner: owner):
            self = .owner(owner: owner)
        case .system:
            self = .system
        case .none:
            self = .system
        }
    }
}
