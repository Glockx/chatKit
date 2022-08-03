//
//  MessageOwner.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation

/// Message Owner can be used during UI Layouting and Message Component Management.
/// Current Types Are:
/// 1. opponent - The message is belongs to the opponent user. Layout alignment: Left
/// 2. owner  - The message is belongs to the logged in user. Layout alignment: Right
/// 3. system - The message is belongs to the system. Layout alignment: Center
public enum MessageOwner: Equatable, Hashable {
    /// The message is belongs to the opponent use
    case opponent(owner: OwnerDetailsModel)

    /// The message is belongs to the logged in user.
    case owner(owner: OwnerDetailsModel)

    /// The message is belongs to the system
    case system
}
