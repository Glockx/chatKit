//
//  ChannelStorageModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/30.
//

import CoreStore
import Foundation

public extension ChatV1 {
    ///  Channel Storage Model
    class ChannelStorageModel: CoreStoreObject {
        /// Channel ID
        @Field.Stored("id", dynamicInitialValue: { UUID().uuidString })
        var id: String

        /// Created
        @Field.Stored("createdAt", dynamicInitialValue: { Date().timeIntervalSince1970 })
        var createdAt: TimeInterval

        /// Latest Message Date
        @Field.Stored("latestMessageDate")
        var latestMessageDate: TimeInterval?

        /// Latest Messge
        @Field.Stored("latestMessage")
        var latestMessage: String?

        /// Unread Message Count
        @Field.Stored("unreadMessageCount")
        var unreadMessageCount = 0

        /// Message Owner
        @Field.Relationship("opponentUser")
        var opponentUser: ChannelOwnerStorageModel?
        
        /// Message Owner
        @Field.Relationship("messages")
        var messages: [MessageStorageModel]
    }
}
