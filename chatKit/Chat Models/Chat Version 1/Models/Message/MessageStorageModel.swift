//
//  MessageStorageModel.swift
//  chatKit
//
//  Created by spresto on 2022/08/31.
//

import CoreStore
import Foundation

extension ChatV1 {
    /// The Main Message Model Of The Chatting System.
    ///  The Structure Of The Message Model:
    ///  1. id: The Identifier Of The Message
    ///  2. owner: The Owner Of The Message.
    ///  3. messageType: Message Type Of Chat Content
    ///  4. creationDate: Creation Date Of The Message
    ///  5. updateDate: Last Update Date Of The Message (Optional)
    class MessageStorageModel: CoreStoreObject {
        /// The Identifier Of The Message
        @Field.Stored("id", dynamicInitialValue: { UUID().uuidString })
        var id: String
        
        ///  The Owner Of The Message
        @Field.Virtual("messageOwner", customGetter: { object, _ in
            MessageOwner(object)
        })
        public var owner: MessageOwner
        
        /// Message Type Of Chat Content
        @Field.Virtual("messageType", customGetter: { object, _ in
            MessageContentType(object)
        })
        public var messageType: MessageContentType

        /// Creation Date Of The Message
        @Field.Stored("createdAt", dynamicInitialValue: { Date().timeIntervalSince1970 })
        public var createdAt: TimeInterval

        /// Last Update Date Of The Message (Optional)
        @Field.Stored("updateAt")
        public var updatedAt: TimeInterval?

        /// Channel Relationship
        @Field.Relationship("channel", inverse: \.$messages)
        var channel: ChannelStorageModel?
    }
}
