//
//  ChannelOwnerStorageModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/30.
//

import CoreStore
import Foundation

extension ChatV1 {
    /// Channel Owner Storage Model
    class ChannelOwnerStorageModel: CoreStoreObject {
        /// Channel Relationship
        @Field.Relationship("channel", inverse: \.$opponentUser)
        var channel: ChannelStorageModel?

        /// The ID of the Owner
        @Field.Stored("id", dynamicInitialValue: { UUID().uuidString })
        var id: String

        /// Username of the owner
        @Field.Stored("username")
        var username = ""

        /// Profile Image
        @Field.Stored("profileImage", dynamicInitialValue: { "https://picsum.photos/seed/\(UUID().uuidString)/1000/1000" })
        var profileImage: String?
    }
}
