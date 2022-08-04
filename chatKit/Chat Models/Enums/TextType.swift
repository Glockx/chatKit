//
//  TextType.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/04.
//

import Foundation

/// While Sending A Message, we should determine if message contains only emojis or not. This is helpful while configuring the message cell type.
enum TextStringType {
    /// Only Emoji String
    case onlyEmoji

    /// General Text String
    case text
}
