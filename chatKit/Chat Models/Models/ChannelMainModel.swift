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
    var opponentUser = OwnerDetailsModel(id: "alex754", username: "Alex")

    /// Latest Message Date
    var latestMessageDate: TimeInterval? = Date().timeIntervalSince1970

    /// Latest Messge
    var latestMessage: String? = Lorem.fullName
}
