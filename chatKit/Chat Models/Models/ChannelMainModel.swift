//
//  ChannelMainModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/18.
//

import Foundation
import LoremSwiftum

/// Channel Main Model Is Used For Listing The Avaliable Chatting Channels
struct ChannelMainModel: Equatable, Hashable, Identifiable {
    /// Channel ID
    var id: String = UUID().uuidString

    /// Profile
    var opponentUser = OwnerDetailsModel(id: Lorem.fullName, username: Lorem.firstName)

    /// Latest Message Date
    var latestMessageDate: TimeInterval? = Date.random(in: Date().addingTimeInterval(-120_000) ..< Date().addingTimeInterval(5000)).timeIntervalSince1970

    /// Latest Messge
    var latestMessage: String? = Lorem.sentence

    /// Unread Message Count
    var unreadMessageCount = Int.random(in: 0 ... 50)

    /// Is User Online
    var isOnline = Bool.random()
}
